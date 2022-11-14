import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
    final Dio dio = Dio(BaseOptions(
        baseUrl: dotenv.env['API_URL']!,
        responseType: ResponseType.json,
        contentType: 'application/json',
    ));

    _optionsHandler(bool useAuth) {
        return Options(
            headers: {
                'Authorization': 'Bearer <DUMMY_VALUE>'
            }
        );
    }

    get(String url, {bool useAuth = true}) {
        return dio.get(
            url, 
            options: _optionsHandler(useAuth)
        );
    }

    post(String url, dynamic body, {bool useAuth = true}) {
        return dio.post(
            url, 
            data: body,
            options: _optionsHandler(useAuth)
        );
    }

    put(String url, dynamic body, {bool useAuth = true}) {
        return dio.put(
            url, 
            data: body,
            options: _optionsHandler(useAuth)
        );
    }

    delete(String url, dynamic body, {bool useAuth = true}) {
        return dio.delete(
            url, 
            data: body,
            options: _optionsHandler(useAuth)
        );
    }
}
