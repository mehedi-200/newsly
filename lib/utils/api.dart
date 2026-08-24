import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:newsly/utils/constants.dart';
import 'package:newsly/utils/labelKeys.dart';

class ApiException implements Exception {
  String errorMessage;

  ApiException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}

class Api {
  //Endpoints. Every URL the app talks to is declared here, never inline.
  static String search = "${baseUrl}search";
  static String searchByDate = "${baseUrl}search_by_date";
  static String item = "${baseUrl}items"; // items/<objectID>

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  static Future<Map<String, dynamic>> get({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint("GET $url $queryParameters");
      }

      final response = await _dio.get(url, queryParameters: queryParameters);

      if (response.data is! Map) {
        throw ApiException(defaultErrorMessageKey);
      }

      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint("DioException: ${e.type} ${e.message}");
      }
      throw _errorFromDio(e);
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(defaultErrorMessageKey);
    }
  }

  static ApiException _errorFromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(requestTimeoutErrorMessageKey);
      case DioExceptionType.connectionError:
        return ApiException(noInternetErrorMessageKey);
      default:
        return ApiException(defaultErrorMessageKey);
    }
  }
}
