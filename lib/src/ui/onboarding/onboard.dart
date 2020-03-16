import 'package:flutter/material.dart';
import 'package:insightq/src/ui/onboarding/onboarding_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboard extends StatelessWidget {
  Onboard(this.prefs);

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Material(
        child: OnboardingPages(prefs),
      ),
    );
  }
}
