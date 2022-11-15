import 'dart:convert';
import 'package:listly/shared/models/user.dart';
import 'package:listly/storage.dart';

class StorageService {
    Future<String?> getToken() async {
        String? token = await storage.read(key: 'token');
        return token;
    }

    Future<void> setToken(String token) async {
        await storage.write(key: 'token', value: token);
    }

    Future<User?> getUser() async {
        String? userString = await storage.read(key: 'user');

        if(userString != null) {
            return User.fromJson(json.decode(userString));
        }

        return null;
    }

    Future<void> setUser(dynamic user) async {
        await storage.write(key: 'user', value: user);
    }
}
