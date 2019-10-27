import 'package:dio/dio.dart';
import 'package:nebula_id/presenter/presenter.dart';

typedef OnFinish();
typedef OnDocument(Map document);

class AnaliseDocument implements APIResult {
  final OnFinish finish;
  final OnDocument document;
  AnaliseDocument({this.document, this.finish});

  processDocument(List<String> images, String type, String country) {
    ApiPresenter.face(this,
            new Map.from({'type': type, 'country': country, 'images': images}))
        .analiseDocument();
  }

  getDocument() {
    ApiPresenter.document(this, null).getDocument();
  }

  @override
  void onError(DioError err) {
    print(err.message);
  }

  @override
  void onResult(value) {
    print(value);
    if (value == 'analise')
      finish();
    else
      document(value);
  }
}
