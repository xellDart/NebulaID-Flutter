import 'package:dio/dio.dart';
import 'package:nebula_id/model/nebula.dart';
import 'package:nebula_id/presenter/presenter.dart';


class AnaliseDocument implements APIResult {
  final Nebula nebula;
  AnaliseDocument({this.nebula});

  processDocument(List<String> images, String type, String country) {
    ApiPresenter.document(this,
            new Map.from({'type': type, 'country': country, 'images': images}))
        .analiseDocument();
  }

  getDocument() => ApiPresenter.document(this, null).getDocument();

  @override
  void onError(DioError err) => nebula.onError(err.message);

  @override
  void onResult(value) =>  nebula.onResult(value);
}
