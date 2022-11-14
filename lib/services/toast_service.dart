import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
    final typesMap = {
        'success': {
            'backgroundColor': Colors.green,
            'webBgColor': 'rgba(76, 175, 80, 255)',
            'textColor': Colors.white
        },
        'error': {
            'backgroundColor': Colors.red,
            'webBgColor': 'rgba(244, 67, 54, 255)',
            'textColor': Colors.white
        },
        'info': {
            'backgroundColor': Colors.yellow,
            'webBgColor': 'rgba(255, 235, 59, 255)',
            'textColor': Colors.black
        }
    };

    Future<bool?> displayToast(String message, String type) {
        return Fluttertoast.showToast(
            msg: message,
            gravity: ToastGravity.BOTTOM,
            webPosition: 'center',
            timeInSecForIosWeb: 5,
            toastLength: Toast.LENGTH_LONG,
            webBgColor: typesMap[type]?['webBgColor'] as dynamic,
            backgroundColor: typesMap[type]?['backgroundColor'] as Color,
            textColor: typesMap[type]?['textColor'] as Color,
        );
    }
}
