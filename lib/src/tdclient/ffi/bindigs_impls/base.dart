import 'dart:ffi';

import 'package:ffi/ffi.dart';

abstract class BindingsImpl {
  final DynamicLibrary libtdjson;

  BindingsImpl(this.libtdjson);

  Pointer Function() get clientCreate;
  Pointer<Utf8> Function(Pointer, double) get clientReceive;
  void Function(Pointer, Pointer<Utf8>) get clientSend;
  Pointer<Utf8> Function(Pointer, Pointer<Utf8>) get clientExecute;
  void Function(Pointer) get clientDestroy;
}
