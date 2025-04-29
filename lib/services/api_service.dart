import 'package:bhukk1/services/api_url.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl, // Replace with your base API URL
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  )..interceptors.add(PrettyDioLogger());

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParameters);
    } on DioException catch (e) {
      return handleResponse(e);
    }
  }

  Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } on DioException catch (e) {
      return handleResponse(e);
    }
  }

  Future<Response> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } on DioException catch (e) {
      return handleResponse(e);
    }
  }

  Future<Response> patch(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.patch(endpoint, data: data);
    } on DioException catch (e) {
      return handleResponse(e);
    }
  }

  Future<Response> delete(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.delete(endpoint, data: data);
    } on DioException catch (e) {
      return handleResponse(e);
    }
  }

  Response handleResponse(DioException e) {
    if (e.response?.statusCode == 422) {
      // Return the response for HTTP 422 without throwing an error
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 422,
            data: e.response?.data ?? {'detail': 'Validation error'},
          );
    } else if (e.response?.statusCode == 404) {
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 404,
            data: {'detail': 'Resource not found'},
          );
    } else if (e.response?.statusCode == 500) {
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 500,
            data: {'detail': 'Internal server error'},
          );
    } else if (e.response?.statusCode == 401) {
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 401,
            data: {'detail': 'Unauthorized'},
          );
    } else if (e.response?.statusCode == 403) {
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 403,
            data: {'detail': 'Forbidden'},
          );
    } else if (e.response?.statusCode == 400) {
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 400,
            data: {'detail': 'Bad request'},
          );
    } else if (e.response?.statusCode == 408) {
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 408,
            data: {'detail': 'Request timeout'},
          );
    } else if (e.response?.statusCode == 429) {
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 429,
            data: {'detail': 'Too many requests'},
          );
    }
    throw e;
  }
}