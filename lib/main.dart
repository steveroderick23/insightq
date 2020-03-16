import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insightq/src/app.dart';
import 'package:insightq/src/ui/onboarding/onboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  bool seen = (prefs.getBool('seen') ?? false);
  if (seen) {
    runApp(
      new App(),
    );
  } else {
    runApp(
      new Onboard(prefs),
    );
  }
}

Future<bool> isInternetReachable() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else
      return false;
  } on SocketException catch (_) {
    return false;
  }
}
