part of 'tdapi.dart';

TdObject convertToObject(Map query) {
  if (query != null) {
    final object = allObjects[query['@type']](query);
    return object;
  } else {
    return null;
  }
}
