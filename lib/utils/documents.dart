import 'package:nebula_id/utils/storage.dart';

class FilterDocument {
  final shared = new Storage();

  Future<List<Map>> getList() async {
    return [
      {
        'country': 'Mexico',
        'documents': ['INE'],
        'back': true
      },
      {
        'country': 'EUA',
        'documents': ['Passport'],
        'back': false
      },
      {
        'country': 'Colombia',
        'documents': ['Passport'],
        'back': false
      }
    ];
  }
}
