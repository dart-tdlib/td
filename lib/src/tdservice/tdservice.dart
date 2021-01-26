import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:td/bindings.dart';
import 'package:td/src/tdclient/ffi/tdclient.dart';
import 'package:td/src/tdclient/platform_channels/platform_channels.dart';
import 'package:td/td_api.dart';

int _random() => Random().nextInt(10000000);

enum Backend { PLATFORM_CHANNELS, FFI }

/// Helper class which can be used for Flutter applications
class TelegramService extends ChangeNotifier {
  dynamic client;

  /// Tdlib events stream, can be listened multiple times
  BehaviorSubject<TdObject> events = BehaviorSubject<TdObject>();
  Stream<TdObject> _clientEvents;
  StreamSubscription _clientsEventsSubs;

  Map results = <int, Completer>{};
  Map callbackResults = <int, Future<void>>{};

  Future<void> initClient([Backend backend, BindingsImpl bindingsImpl]) async {
    Backend _backend;
    if (backend == null) {
      if (Platform.isAndroid)
        backend = Backend.PLATFORM_CHANNELS;
      else
        backend = Backend.FFI;
    } else
      _backend = backend;

    if (_backend == Backend.PLATFORM_CHANNELS) {
      client = await TdlibPlatformWrapper.createClient();
      if (client == 0)
        throw PlatformException(
            code: "Tdlib", message: "Error while launching");
      _clientEvents = TdlibPlatformWrapper.clientEvents();
    } else {
      client = TdlibFFIWrapper();
      client.initClient(bindingsImpl);
      _clientEvents = client.updates.stream;
    }

    _clientsEventsSubs = _clientEvents.listen(_eventsResolver);
  }

  void _eventsResolver(TdObject newEvent) async {
    if (newEvent != null) {
      if (newEvent is Updates) {
        newEvent.updates.forEach((Update event) => events.add(event));
      } else {
        events.add(newEvent);
      }
      await _resolveEvent(newEvent);
    }
  }

  Future _resolveEvent(event) async {
    final int extraId = event.extra;
    if (results.containsKey(extraId)) {
      results.remove(extraId).complete(event);
    } else if (callbackResults.containsKey(extraId)) {
      await callbackResults.remove(extraId);
    }
  }

  void destroyClient() async {
    if (client is int) {
      // Platform channels impl
      await TdlibPlatformWrapper.destroyClient();
    } else {
      // FFI impl
      client.destroy();
    }
  }

  /// Sends request to the TDLib client. May be called from any thread.
  Future<TdObject> send(event, {Future<void> callback}) async {
    // ignore: missing_return
    final rndId = _random();
    event.extra = rndId;
    if (callback != null) {
      callbackResults[rndId] = callback;
      try {
        if (client is int)
          await TdlibPlatformWrapper.clientSend(event);
        else
          await (client as TdlibFFIWrapper).send(event);
      } catch (e) {
        print(e);
      }
    } else {
      final completer = Completer<TdObject>();
      results[rndId] = completer;
      if (client is int)
        await TdlibPlatformWrapper.clientSend(event);
      else
        await (client as TdlibFFIWrapper).send(event);
      return completer.future;
    }

    return null;
  }

  /// Synchronously executes TDLib request. May be called from any thread.
  /// Only a few requests can be executed synchronously.
  /// Returned pointer will be deallocated by TDLib during next call to clientReceive or clientExecute in the same thread, so it can't be used after that.
  Future<TdObject> execute(TdFunction event) async {
    if (client is int)
      return await TdlibPlatformWrapper.clientExecute(event);
    else
      return await (client as TdlibFFIWrapper).execute(event);
  }

  @override
  void dispose() {
    _clientsEventsSubs.cancel();
    events.close();
    super.dispose();
  }
}
