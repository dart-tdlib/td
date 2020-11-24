import "dart:convert";
import "dart:ffi";
import 'dart:isolate';

import "package:ffi/ffi.dart";
import 'package:rxdart/rxdart.dart';
import 'package:td/src/tdclient/bindings.dart';
import 'package:td/td_api.dart';

TdJSONBindings bindings = TdJSONBindings();

Future<void> _receiveUpdates(Pointer client, SendPort port) async {
  final event = await Future(() => bindings.clientReceive(client, 1.0));

  if (event.address != 0) {
    final resString = Utf8.fromUtf8(event);
    port.send(json.decode(resString));
  }

  Future(() => _receiveUpdates(client, port));
}

void _clientIsolate(SendPort port) {
  var isolateReceivePort = ReceivePort();
  Pointer client = bindings.clientCreate();
  port.send(isolateReceivePort.sendPort);

  isolateReceivePort.listen((message) async {
    if (message is Map) {
      SendPort tmpSendPort;
      if (message.containsKey('port'))
        tmpSendPort = message['port'] as SendPort;
      switch (message['_requestType'] as String) {
        case 'execute':
          var tdlibRequest = message;
          tdlibRequest.remove('_requestType');
          tdlibRequest.remove('port');

          final result = bindings.clientExecute(
              client, Utf8.toUtf8(json.encode(tdlibRequest)));
          tmpSendPort.send(json.decode(Utf8.fromUtf8(result)));
          break;
        case 'send':
          var tdlibRequest = message;
          tdlibRequest.remove('_requestType');
          bindings.clientSend(client, Utf8.toUtf8(json.encode(tdlibRequest)));
          break;
        case 'destroy':
          bindings.clientDestroy(client);
          tmpSendPort.send(true);
      }
    }
  });

  _receiveUpdates(client, port);
}

class TdlibWrapper {
  Isolate _isolate;
  SendPort _sendPort;
  ReceivePort _receivePort;
  BehaviorSubject updates = BehaviorSubject();

  Future<void> initClient() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_clientIsolate, _receivePort.sendPort);
    // redirect all updates to BehaviorSubject so we can have multiple listeners
    _receivePort.listen((message) {
      if (message is SendPort)
        updates.add(message);
      else
        updates.add(convertToObject(message));
    });

    // first update will be a port to which we can send requests and get the response w/o main stream
    _sendPort = (await updates.first) as SendPort;
  }

  Future<TdObject> execute(TdFunction request) async {
    var tmpReceivePort = ReceivePort();
    var jsonRequest = request.toJson();

    jsonRequest['port'] = tmpReceivePort.sendPort;
    jsonRequest['_requestType'] = 'execute';
    _sendPort.send(jsonRequest);

    return convertToObject(await tmpReceivePort.first);
  }

  Future<void> send(TdFunction request) async {
    var jsonRequest = request.toJson();

    jsonRequest['_requestType'] = 'send';
    _sendPort.send(jsonRequest);
  }

  Future<void> dispose() async {
    var tmpReceivePort = ReceivePort();
    _sendPort.send({'_requestType': 'destroy', 'port': tmpReceivePort});

    if ((await tmpReceivePort.first) == true) {
      _isolate.kill();
      _isolate = null;
    }
  }
}
