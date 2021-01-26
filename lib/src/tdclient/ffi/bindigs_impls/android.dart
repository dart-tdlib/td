import 'dart:ffi' as ffi;

import '../bindings.dart';
import 'base.dart';

class AndroidBindings implements BindingsImpl {
  @override
  ffi.DynamicLibrary get libtdjson =>
      ffi.DynamicLibrary.open('libtdjsonandroid.so');

  @override
  get clientCreate => libtdjson
      .lookup<ffi.NativeFunction<td_json_client_create_t>>(
          '_td_json_client_create')
      .asFunction();

  @override
  get clientDestroy => libtdjson
      .lookup<ffi.NativeFunction<td_json_client_destroy_t>>(
          '_td_json_client_destroy')
      .asFunction();

  @override
  get clientExecute => libtdjson
      .lookup<ffi.NativeFunction<td_json_client_execute_t>>(
          '_td_json_client_execute')
      .asFunction();

  @override
  get clientReceive => libtdjson
      .lookup<ffi.NativeFunction<td_json_client_receive_t>>(
          '_td_json_client_receive')
      .asFunction();

  @override
  get clientSend => libtdjson
      .lookup<ffi.NativeFunction<td_json_client_send_t>>('_td_json_client_send')
      .asFunction();
}
