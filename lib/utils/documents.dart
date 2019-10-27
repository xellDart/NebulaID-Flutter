import 'package:nebula_id/utils/storage.dart';

class FilterDocument {

  final shared = new Storage();

  Future<List<Map>> getList(String currentDocument, String country) async {
    List<Map> data = new List();
    final documents = [
      {
        'country': 'Mexico',
        'documents': ['INE'],
        'back': true
      },
      {
        'country': 'EUA',
        'documents': ['Passport'],
        'back': false
      }
    ];
    if (country == null && currentDocument == null) return documents;
    documents.forEach((item) {
      var temp = item;
      if (temp['country'] == country)
        (temp['documents'] as List)
            .removeWhere((item) => item == currentDocument);
      data.add(temp);
    });
    return data;
  }
}
