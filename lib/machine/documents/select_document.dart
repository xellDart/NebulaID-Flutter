import 'package:dio/dio.dart';
import 'package:nebula_id/presenter/presenter.dart';
import 'package:nebula_id/utils/storage.dart';

typedef OnFinish();
typedef OnDocument(Map document);

class AnaliseDocument implements APIResult {
  final OnFinish finish;
  final OnDocument document;
  AnaliseDocument({this.document, this.finish});

  processDocument(List<String> images, String type, String country) {
    ApiPresenter.document(this,
            new Map.from({'type': type, 'country': country, 'images': images}))
        .analiseDocument();
  }

  getDocument() async {
    if(await Storage().getString('uuid_nebula') != null)
      ApiPresenter.document(this, null).getDocument();
    else document(null);
  }

  @override
  void onError(DioError err) {
    document(null);
  }

  @override
  void onResult(value) {
    if (value == 'analise')
      finish();
    else
      document(value);
  }
}
