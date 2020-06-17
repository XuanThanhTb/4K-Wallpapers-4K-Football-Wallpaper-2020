import 'dart:async';

import 'package:dio/dio.dart';

import '../baseUrl.dart';

class ApiClient {
  final _dio = Dio();
  static final _defaultTimeout = 30000;
  ApiClient() {
    var options = _dio.options;
    options.responseType = ResponseType.json;
    options.baseUrl = ApiConst.uri;
    options.connectTimeout = _defaultTimeout;
    options.receiveTimeout = _defaultTimeout;
    options.sendTimeout = _defaultTimeout;
    _dio.options = options;
    _dio.interceptors.add(LogByMethodInterceptor(disabledLogMethods: []));
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) {
          return options;
        },
        onResponse: (Response response) {},
        onError: (DioError error) {}));
  }
  Future<Response<T>> get<T>(String uri,
      {Map<String, dynamic> params, CancelToken cancelToken}) async {
    return await _dio.get<T>(uri,
        queryParameters: params, cancelToken: cancelToken);
  }
}

class LogByMethodInterceptor extends LogInterceptor {
  LogByMethodInterceptor({this.disabledLogMethods = const ["GET"]}) {
    this.requestHeader = false;
    this.requestBody = false;
    this.responseHeader = false;
    this.responseBody = true;
  }

  List<String> disabledLogMethods;

  @override
  Future<FutureOr> onResponse(Response response) async {
    if (disabledLogMethods.contains(response.request.method.toUpperCase())) {
      return null;
    }

    return super.onResponse(response);
  }
}
