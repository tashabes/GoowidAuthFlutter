import 'package:goowid_auth/app/core/endpoints/endpoints.dart';
import 'package:goowid_auth/app/core/failure/failure.dart';
import 'package:goowid_auth/utils/app_logger.dart';
import 'package:dio/dio.dart';

class HttpClient {
  static String baseUrl = Endpoints.baseUrl;
  static BaseOptions opts = BaseOptions(
    baseUrl: baseUrl,
    responseType: ResponseType.json,
    connectTimeout: 30000,
    receiveTimeout: 30000,
    contentType: 'application/json',
  );


  static Dio createDio() => Dio(opts);
  static final dio = createDio();

  Future<Response?> get(String url, {Map<String, String>? headers}) async {
    AppLogger.log("url ==> $url");
    AppLogger.log("header ==> $headers");

    try {
      Response response = await dio.get(url, options: Options(headers: headers));
      return response;
    } on DioError catch (e) {
      AppLogger.log("This is the las =====================> $e");
      if (e.response != null && e.response?.data != null && e.response?.data['message'] != null) {
        throw Failure(e.response?.data['message']);
      } else {
        throw Failure("Something went wrong please try again later");
      }
    } catch (e) {
      throw Failure("Something went wrong please try again later");
    }
  }

  Future post(String url, dynamic data, {Map<String, String>? headers}) async {
    AppLogger.log('url ============> $url');
    AppLogger.log(' data: ============> $data');
    AppLogger.log(' header: ============> $headers');
    try {
      Response? response = await dio.post(url, data: data, options: Options(headers: headers));
      AppLogger.log("Response $response");

      return response;
    } on DioError catch (e) {
      AppLogger.log("============> response data ${e.response?.data}");
      AppLogger.log("============> message ${e.message}");
      AppLogger.log("============> error ${e.error}");
      AppLogger.log("============> type ${e.type}");

      if (e.response != null && e.response?.data != null ) {
        throw Failure(e.response?.data['message']);
      } else {
        AppLogger.log("Error ================> $e");
        throw Failure("Something went wrong, please try again later");
      }
    } catch (e) {
      AppLogger.log("catch Error ================> $e");
      throw Failure("Something went wrong, please try again later");
    }
  }
}
