import 'dart:ffi' as ffi;
import 'dart:ffi';

import 'package:ffi/ffi.dart';

typedef td_json_client_create_t = ffi.Pointer Function();
typedef td_json_client_receive_t = ffi.Pointer<Utf8> Function(
    ffi.Pointer, ffi.Double);
typedef td_json_client_send_t = ffi.Void Function(
    ffi.Pointer, ffi.Pointer<Utf8>);
typedef td_json_client_execute_t = ffi.Pointer<Utf8> Function(
    ffi.Pointer, ffi.Pointer<Utf8>);
typedef td_json_client_destroy_t = ffi.Void Function(ffi.Pointer);

class TdJSONBindings {
  ffi.Pointer Function() clientCreate;

  ffi.Pointer<Utf8> Function(ffi.Pointer, double) clientReceive;

  void Function(ffi.Pointer, ffi.Pointer<Utf8>) clientSend;

  ffi.Pointer<Utf8> Function(ffi.Pointer, ffi.Pointer<Utf8>) clientExecute;

  void Function(ffi.Pointer) clientDestroy;

  TdJSONBindings([String platform = 'android']) {
    ffi.DynamicLibrary libtdjson;

    if (platform == 'android') {
      libtdjson = DynamicLibrary.open('libtdjsonandroid.so');
    }

    clientCreate = libtdjson
        .lookup<ffi.NativeFunction<td_json_client_create_t>>(
            '_td_json_client_create')
        .asFunction();

    clientReceive = libtdjson
        .lookup<ffi.NativeFunction<td_json_client_receive_t>>(
            '_td_json_client_receive')
        .asFunction();

    clientSend = libtdjson
        .lookup<ffi.NativeFunction<td_json_client_send_t>>(
            '_td_json_client_send')
        .asFunction();

    clientExecute = libtdjson
        .lookup<ffi.NativeFunction<td_json_client_execute_t>>(
            '_td_json_client_execute')
        .asFunction();

    clientDestroy = libtdjson
        .lookup<ffi.NativeFunction<td_json_client_destroy_t>>(
            '_td_json_client_destroy')
        .asFunction();
  }
}
