import 'package:flutter/material.dart';
import 'package:insightq/src/ui/home.dart';

const languages = const [
  const Language('English', 'en_US'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class App extends StatelessWidget {
  App({this.pinCode});

  final String pinCode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Material(
        child: Home(pinCode: pinCode),
      ),
    );
  }
}
