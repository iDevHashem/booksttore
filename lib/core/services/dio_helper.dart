import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper {
  static Dio? dio;

 static const String activeHost= "project.ahdafweb.com/public";

  // static const String baseUrl = "http://$activeHost:8000/api/v1/";
  static const String baseUrl = "https://$activeHost/api/v1/";
  static String? token;
    static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio!.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

   static void _setHeaders({String? customToken, bool isFormData = false}) {
    dio!.options.headers = {
      'Accept': 'application/json',
      if (!isFormData) 'Content-Type': 'application/json',
      if ((customToken ?? token) != null)
        'Authorization': 'Bearer ${customToken ?? token}',
    };
  }


  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query, String? token,
  }) async {
    _setHeaders();
    return await dio!.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
     dynamic data, // <-- Now dynamic to support FormData
    String? token,
    bool isFormData = false, // <-- New flag
  }) async {
    _setHeaders(customToken: token, isFormData: isFormData);
    return await dio!.post(url, data: data);
  }

  static Future<Response> searchData({
    required String query,
  }) async {
    _setHeaders();
    return await dio!.get(
      'search',
      queryParameters: {
        'query': query,
      },
    );
  }

 
  static Future<Response> filterData({
    required Map<String, dynamic> filters,
  }) async {
    _setHeaders();
    return await dio!.get(
      'filter', //      
      queryParameters: filters,
    );
  }
}
