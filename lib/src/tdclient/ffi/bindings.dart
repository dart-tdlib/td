import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:td/src/tdclient/ffi/bindigs_impls/android.dart';

import 'bindigs_impls/base.dart';
import 'bindigs_impls/ios.dart';

typedef td_json_client_create_t = ffi.Pointer Function();
typedef td_json_client_receive_t = ffi.Pointer<Utf8> Function(
    ffi.Pointer, ffi.Double);
typedef td_json_client_send_t = ffi.Void Function(
    ffi.Pointer, ffi.Pointer<Utf8>);
typedef td_json_client_execute_t = ffi.Pointer<Utf8> Function(
    ffi.Pointer, ffi.Pointer<Utf8>);
typedef td_json_client_destroy_t = ffi.Void Function(ffi.Pointer);

class TdJSONBindings {
  BindingsImpl bindings;

  TdJSONBindings([BindingsImpl bindingsImpl]) {
    if (bindingsImpl != null)
      bindings = bindingsImpl;
    else if (Platform.isAndroid)
      bindings = AndroidBindings();
    else if (Platform.isIOS) bindings = IOSBindings();
  }
}
