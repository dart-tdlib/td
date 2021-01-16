import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getPointers() async {
  SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
  List<String> pointers = [];
  pointers = _sharedPrefs.getStringList('clients');

  if (pointers == null) return [];
  return pointers;
}

Future<List<Pointer<NativeType>>> getExistingClients() async {
  List<String> pointers = await getPointers();
  List<Pointer> rawPointers = [];
  for (String pointer in pointers) {
    rawPointers.add(Pointer.fromAddress(int.tryParse(pointer)));
  }

  return rawPointers;
}

Future<void> addClient(int address) async {
  List<String> pointers = await getPointers();
  pointers.add(address.toString());
  await setClients(pointers);
}

Future<void> setClients(List<String> clients) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setStringList('clients', clients);
}
