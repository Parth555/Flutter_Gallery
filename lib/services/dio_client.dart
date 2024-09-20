import 'dart:async';
import 'dart:convert';

import '../services/end_point.dart';
import '../utils/constant.dart';
import '../utils/debug.dart';
import '../utils/params.dart';
import '../utils/preference.dart';
import 'package:dio/dio.dart';

/// A callback that returns a Dio response, presumably from a Dio method
/// it has called which performs an HTTP request, such as `services.get()`,
/// `services.post()`, etc.

typedef HttpClientRequest<T> = Future<Response<T>> Function();

abstract class IApiClient {
  Future<Response<dynamic>> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
  });

  Future<Response<dynamic>> getRow(
    String uri, {
    Map<String, dynamic>? queryParameters,
    dynamic extra,
  });

  Future<Response<dynamic>> post(
    String uri, {
    dynamic data,
    bool? formRequest,
  });

  Future<Response<dynamic>> delete(
    String uri, {
    dynamic data,
  });

  Future<Response<dynamic>> put(String uri, {dynamic data});

  void updateAuthorizationHeader();

  void updateBaseUrl({String? baseUrl});

  void updateContentTypeHeader({bool isMultiPart = false});
}

class DioClient implements IApiClient {
  static final DioClient _dioClient = DioClient._internal();

  factory DioClient() {
    return _dioClient;
  }

  DioClient._internal();

  static DioClient get shared => _dioClient;

  static Dio? _dio;

  Future<Dio?> instance() async {
    if (_dio != null) return _dio!;
    _dio = Dio();
    _dio!
      ..options.baseUrl = EndPoint.getBaseURL()
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.contentType = 'application/json'
      ..options.headers = {
        Params.contentTypeHeader: 'application/x-www-form-urlencoded',
        Params.acceptHeader: 'application/json',
      };

    _dio!.interceptors.add(
      LogInterceptor(
        request: false,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (object) {
          //Debug.printLog("DIO INTERCEPTORS", object.toString());
        },
      ),
    );

    updateAuthorizationHeader();
    return _dio;
  }

  @override
  void updateContentTypeHeader({bool isMultiPart = false}) {
    _dio!.options.headers[Params.contentTypeHeader] = (isMultiPart) ? 'multipart/form-data' : 'application/json';
  }

  @override
  void updateBaseUrl({String? baseUrl}) {
    if (baseUrl != null) {
      _dio!.options.baseUrl = baseUrl;
    } else {
      _dio!.options.baseUrl = EndPoint.getBaseURL();
    }
  }

  @override
  void updateAuthorizationHeader() {
    // final accessToken = Preference.shared.getString(Preference.accessToken);
    // Debug.printLog("accessToken ==> $accessToken");
    // if (accessToken != null) {
    //   _dio!.options.headers[Params.authorizationHeader] = accessToken;
    // } else {
    //   _dio!.options.headers.remove(Params.authorizationHeader);
    // }
  }

  @override
  Future<Response<dynamic>> post(
    String uri, {
    dynamic data,
    bool? formRequest,
  }) async {
    return _mapException(
      () => _dio!.post(uri, data: data),
    );
  }

  @override
  Future<Response<dynamic>> put(String uri, {dynamic data}) async {
    return _mapException(
      () => _dio!.put(uri, data: data),
    );
  }

  @override
  Future<Response<dynamic>> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _mapException(
      () => _dio!.get(uri, queryParameters: queryParameters),
    );
  }

  Future<Response<T>> _mapException<T>(HttpClientRequest<T> request) async {
    try {
      return await request();
    } on DioException catch (e) {
      Debug.printLog("DioError -->> ${e.toString()}");
      if (e.response?.statusCode == Constant.responseFailureCode) {}
      if (e.response?.statusCode == Constant.responseUnauthorizedCode) {
      }

      if (e.response != null && e.response?.data is Map) {
        final response = e.response!.data as Map;
        throw AppException(
          (response[Params.message] as String?) ?? (e.message ?? ""),
          (response[Params.statusCode] != null) ? (response[Params.statusCode] as int) : e.response!.statusCode!,
        );
      }
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> getRow(String uri, {Map<String, dynamic>? queryParameters, dynamic extra}) {
    return _mapException(
      () => _dio!.request<Map<String, dynamic>>(uri,
          options: Options(method: 'GET', headers: _dio!.options.headers, extra: extra),
          data: jsonEncode(queryParameters),
          queryParameters: queryParameters),
    );
  }

  @override
  Future<Response> delete(String uri, {data}) {
    return _mapException(
      () => _dio!.delete(uri, data: data),
    );
  }
}


class AppException implements Exception {
  AppException([
    this.message = '',
    this.responseCode = 200,
  ]);

  final String message;
  final int responseCode;
}
