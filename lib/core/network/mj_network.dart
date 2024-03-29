import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';

class MJNetwork extends Network {
  final Dio _dio;
  final Uuid uuid = const Uuid();
  final bool _enableLogging;

  MJNetwork(
    this._dio, {
    bool enableLogging = true,
    List<Interceptor> interceptors = const [],
  }) : _enableLogging = enableLogging {
    _initInterceptors(interceptors);
  }

  _initInterceptors(List<Interceptor> interceptors) {
    _dio.interceptors.add(_interceptorsRequestWrapper());
    _dio.interceptors.add(_interceptorsErrorWrapper());
    for (var interceptor in interceptors) {
      _dio.interceptors.add(interceptor);
    }
    if (kDebugMode && _enableLogging) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  InterceptorsWrapper _interceptorsRequestWrapper() => InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers["Content-Type"] = "application/json";
          options.headers["Accept"] = "application/json";
          options.headers['Accept-Language'] = "en";

          return handler.next(options);
        },
      );

  InterceptorsWrapper _interceptorsErrorWrapper() => InterceptorsWrapper(
        onError: (e, handler) async {
          return handler.next(e);
        },
      );

  String _url(String path) {
    return _dio.options.baseUrl + path;
  }

  String getRequestId(headers) {
    String requestId = uuid.v4();
    if (headers != null) {
      if (headers['X-Request-ID'] == null) {
        headers['X-Request-ID'] = requestId;
      } else {
        requestId = headers['X-Request-ID'];
      }
    } else {
      headers = {'X-Request-ID': requestId};
    }
    return requestId;
  }

  Future<Response> _createOperation(
    String path, {
    required String method,
    data,
    headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response result = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method, headers: headers),
      );
      return result;
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response?.data;
        final message = data is String ? data : data["message"] ?? "";
        final String errorMessage =
            data is String ? data : data["error_message"] ?? "";
        String code = "";
        if (errorMessage.isEmpty) {
          code = data is String ? data : data["code"];
        }
        final ee = MJNetworkError(
          _url(path),
          message: message,
          statusCode: e.response?.statusCode ?? 400,
          internalStatusCode: code,
          internalErrorMessage: errorMessage,
        );
        throw ee;
      } else {
        throw MJNetworkError(
          _url(path),
          message: "Something went wrong",
          statusCode: e.response?.statusCode ?? 500,
          internalStatusCode: "Something went wrong",
        );
      }
    }
  }

  @override
  Future<Response> get(
    String path, {
    dynamic headers,
    dynamic query,
  }) async {
    return await _createOperation(
      path,
      method: "GET",
      headers: headers,
      queryParameters: query,
    );
  }

  @override
  Future<Response> post(
    String path, {
    dynamic headers,
    dynamic body,
  }) async {
    return await _createOperation(
      path,
      method: "POST",
      headers: headers,
      data: body,
    );
  }

  @override
  Future<Response> put(
    String path, {
    dynamic headers,
    dynamic body,
  }) async {
    return await _createOperation(
      path,
      method: "PUT",
      headers: headers,
      data: body,
    );
  }

  @override
  Future<Response> patch(
    String path, {
    dynamic headers,
    dynamic body,
  }) async {
    return await _createOperation(
      path,
      method: "PATCH",
      headers: headers,
      data: body,
    );
  }

  @override
  Future<Response> delete(
    String path, {
    dynamic headers,
    dynamic body,
  }) async {
    return await _createOperation(
      path,
      method: "DELETE",
      headers: headers,
      data: body,
    );
  }

  @override
  Future<Response> upload(
    String path, {
    required FormData formData,
    dynamic headers,
  }) async {
    return await _createOperation(
      path,
      method: "POST",
      headers: headers,
      data: formData,
    );
  }
}

class MJNetworkError extends Equatable implements Exception {
  const MJNetworkError(
    this._url, {
    required this.message,
    required this.statusCode,
    required this.internalStatusCode,
    this.internalErrorMessage,
  });

  final String _url;
  final String message;
  final int statusCode;
  final String internalStatusCode;
  final String? internalErrorMessage;

  @override
  String toString() {
    return 'url: $_url message: $message, statusCode: $statusCode, internalStatusCode: $internalStatusCode, internalErrorMessage: $internalErrorMessage';
  }

  @override
  List<Object?> get props => [
        _url,
        message,
        statusCode,
        internalStatusCode,
        internalErrorMessage,
      ];
}

abstract class Network {
  Future<Response> get(
    String path, {
    dynamic headers,
    dynamic query,
  });

  Future<Response> post(
    String path, {
    dynamic headers,
    dynamic body,
  });

  Future<Response> put(
    String path, {
    dynamic headers,
    dynamic body,
  });

  Future<Response> patch(
    String path, {
    dynamic headers,
    dynamic body,
  });

  Future<Response> delete(
    String path, {
    dynamic headers,
    dynamic body,
  });

  Future<Response> upload(
    String path, {
    required FormData formData,
    dynamic headers,
  });
}
