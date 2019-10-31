import 'package:dio/dio.dart';
import 'package:nebula_id/model/nebula.dart';
import 'package:nebula_id/presenter/presenter.dart';

typedef OnDocumentSaved();
typedef OnDocumentGet(dynamic data);
typedef OnDocumentError(String error);

class AnaliseDocument implements APIResult {
  final Nebula nebula;
  final OnDocumentError error;
  final OnDocumentGet get;
  final OnDocumentSaved saved;
  bool isGet = false;
  AnaliseDocument({this.nebula, this.get, this.saved, this.error});

  processDocument(List<String> images, String type, String country) {
    isGet = false;
    ApiPresenter.document(this,
            new Map.from({'type': type, 'country': country, 'images': images}))
        .analiseDocument();
  }

  getDocument() {
    isGet = true;
    ApiPresenter.document(this, null).getDocument();
  }

  @override
  void onError(DioError err) => error(err.message);

  @override
  void onResult(value) {
    if(isGet) get(value);
    else saved();
  }
}
