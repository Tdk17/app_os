import 'package:dio/dio.dart';

abstract class HttpMethod {
  static const String get = 'GET';
  static const String post = 'POST';
  static const String put = 'PUT';
  static const String delete = 'DELETE';
  static const String patch = 'PATCH';
}

class HttpManager {
  Future<Map> restRequest({
    required String url,
    required String method,
    Map? headers,
    Map? body,
  }) async {
    //Headers
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Parse-Application-Id': '2YpWSnOhna8dChGrUzOvJfbpGHpoFNbE8S3uMMOj',
        'X-Parse-REST-API-Key': 'OcbYILWl5PdoWiY9BsjkgpvfXUHsRdBG79H7bHx2',
      });

    Dio dio = Dio();

    try {
      Response response = await dio.request(
        url,
        options: Options(headers: defaultHeaders, method: method),
        data: body,
      );
      //Retorno do resultado do Server
      return response.data;
    } on DioException catch (error) {
      //Retorno do erro do dio
      return error.response?.data ?? {};
    } catch (error) {
      //Retorno de erro generalizado
      return {};
    }
  }
}
