import 'dart:io';

import 'package:insightq/src/App.dart';
import 'package:flutter/material.dart';
import 'package:insightq/src/ui/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  runApp(
    new App(),
  );

}

Future<bool> isInternetReachable() async
{
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    else
      return false;
  } on SocketException catch (_) {
    return false;
  }
}


