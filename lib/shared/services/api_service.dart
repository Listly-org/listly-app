import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:listly/shared/services/storage_service.dart';
import 'package:listly/shared/services/toast_service.dart';

class ApiService {
    StorageService storage = StorageService();
    ToastService toast = ToastService();

    final Dio dio = Dio(BaseOptions(
        baseUrl: dotenv.env['API_URL']!,
        responseType: ResponseType.json,
        contentType: 'application/json',
    ));

    ApiService() {
        dio.interceptors.add(InterceptorsWrapper(
            onError: (e, handler) {
                debugPrint(e.response.toString());
                toast.displayToast('Something wrong happened, try again', 'error');
                return handler.next(e);
            },
        ));
    }

    _optionsHandler(bool useAuth) async {
        String? token = await storage.getToken();
        return useAuth
            ? Options(headers: { 'Authorization': 'Bearer $token' })
            : Options();
    }

    Future<Response<dynamic>> get(String url, {bool useAuth = true}) async {
        return dio.get<dynamic>(
            url, 
            options: await _optionsHandler(useAuth)
        );
    }

    Future<Response<dynamic>> post(String url, dynamic body, {bool useAuth = true}) async {
        return dio.post<dynamic>(
            url, 
            data: body,
            options: await _optionsHandler(useAuth)
        );
    }

    Future<Response<dynamic>> put(String url, dynamic body, {bool useAuth = true}) async {
        return dio.put<dynamic>(
            url, 
            data: body,
            options: await _optionsHandler(useAuth)
        );
    }

    Future<Response<dynamic>> delete(String url, dynamic body, {bool useAuth = true}) async {
        return dio.delete<dynamic>(
            url, 
            data: body,
            options: await _optionsHandler(useAuth)
        );
    }
}
