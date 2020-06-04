import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'Bloc/tab_bar_bloc.dart';
import 'DataLayer/User.dart';
import 'DataLayer/product.dart';

final mainColor = Color(0xFF44bd32);
final tabsColor = Color(0xFF7f8c8d);
final textColor = Color(0xFFecf0f1);
String aboutUs = "";

int pointsPerRial = 0;
String callNum = "";
String firetoken = "";
User user;
TabController tabBarController;
final tabBloc = TabsBloc();
String token;
isRegistered() {
  if (token != null) {
    return true;
  } else {
    return false;
  }
}

List<String> sliders = [];
final redColor = Colors.red;
final sql_cart_query =
    'CREATE TABLE user_cart(id INT PRIMARY KEY ,quantity INT)';
List<Product> products = [];
int counter = 0;
LocationData locationData;
Future<void> getUserLocation() async {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  locationData = await location.getLocation();
}
