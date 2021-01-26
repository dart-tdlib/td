import 'dart:async';
import "dart:convert";
import "dart:ffi";
import 'dart:isolate';

import "package:ffi/ffi.dart";
import 'package:flutter/services.dart';
import 'package:td/src/tdclient/ffi/bindigs_impls/base.dart';
import 'package:td/src/tdclient/ffi/bindings.dart';
import 'package:td/td_api.dart';

// TODO: Make this changable outside of Isolate
// Or just keep it as it is so we allow to choose bindings only by library itself?
// We can also pass to the Isolate names of ffi methods instead of typedefs
// So we won't face any errors, but I don't like that way much
TdJSONBindings jsonBindings = TdJSONBindings();
BindingsImpl bindingsImpl = jsonBindings.bindings;

Future<void> _receiveUpdates(Pointer client, SendPort port) async {
  final event = await Future(() => bindingsImpl.clientReceive(client, 1.0));
  if (event.address != 0) {
    final resString = Utf8.fromUtf8(event);
    port.send(resString);
  }

  Future(() => _receiveUpdates(client, port));
}

void _clientIsolate(SendPort port) async {
  var isolateReceivePort = ReceivePort();
  Pointer client = bindingsImpl.clientCreate();
  port.send({'port': isolateReceivePort.sendPort});

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

          final result = bindingsImpl.clientExecute(
              client, Utf8.toUtf8(json.encode(tdlibRequest)));
          tmpSendPort.send(json.decode(Utf8.fromUtf8(result)));
          break;
        case 'send':
          var tdlibRequest = message;
          tdlibRequest.remove('_requestType');
          bindingsImpl.clientSend(
              client, Utf8.toUtf8(json.encode(tdlibRequest)));
          break;
        case 'destroy':
          bindingsImpl.clientDestroy(client);
          tmpSendPort.send(true);
      }
    }
  });

  _receiveUpdates(client, port);
}

class TdlibFFIWrapper {
  Isolate _isolate;
  SendPort _sendPort;
  ReceivePort _receivePort;
  StreamController<TdObject> updates = StreamController<TdObject>();

  Future<void> initClient() async {
    if (bindingsImpl == null)
      throw PlatformException(
          code: "TDLib", message: "Platform is unsupported");
    _receivePort = ReceivePort();
    Completer _completer = new Completer();
    _isolate = await Isolate.spawn(_clientIsolate, _receivePort.sendPort);
    _receivePort.listen((message) {
      if (message is Map && message.containsKey('port')) {
        _sendPort = message['port'];
        _completer.complete();
      } else
        updates.add(convertToObject(message));
    });

    return _completer.future;
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
