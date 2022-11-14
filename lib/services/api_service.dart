import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:listly/services/toast_service.dart';

class ApiService {
    ToastService toast = ToastService();

    final Dio dio = Dio(BaseOptions(
        baseUrl: dotenv.env['API_URL']!,
        responseType: ResponseType.json,
        contentType: 'application/json',
    ));

    ApiService() {
        dio.interceptors.add(InterceptorsWrapper(
            onError: (e, handler) {
                toast.displayToast('Something wrong happened, try again', 'error');
                return handler.next(e);
            },
        ));
    }

    _optionsHandler(bool useAuth) {
        return Options(
            headers: {
                'Authorization': 'Bearer <DUMMY_VALUE>'
            }
        );
    }

    Future<Response> get(String url, {bool useAuth = true}) {
        return dio.get(
            url, 
            options: _optionsHandler(useAuth)
        );
    }

    Future<Response> post(String url, dynamic body, {bool useAuth = true}) {
        return dio.post(
            url, 
            data: body,
            options: _optionsHandler(useAuth)
        );
    }

    Future<Response> put(String url, dynamic body, {bool useAuth = true}) {
        return dio.put(
            url, 
            data: body,
            options: _optionsHandler(useAuth)
        );
    }

    Future<Response> delete(String url, dynamic body, {bool useAuth = true}) {
        return dio.delete(
            url, 
            data: body,
            options: _optionsHandler(useAuth)
        );
    }
}
