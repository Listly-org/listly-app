import 'package:flutter/material.dart';
import 'package:listly/shared/models/option.dart';

final Map<String, Option> options = {
    'shopping': Option(
        Text('Shopping'), 
        Icon(Icons.shopping_cart), 
        'shopping'
    ),
    'grocery': Option(
        Text('Grocery'), 
        Icon(Icons.shopping_basket), 
        'grocery'
    ),
    'to_do': Option(
        Text('To do'), 
        Icon(Icons.checklist), 
        'to_do'
    ),
    'trip': Option(
        Text('Trip'), 
        Icon(Icons.airplanemode_active), 
        'trip'
    ),
    'other': Option(
        Text('Other'), 
        Icon(Icons.more_horiz), 
        'other'
    )
};
