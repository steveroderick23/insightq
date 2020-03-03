import 'package:flutter/material.dart';
import 'package:insightq/src/blocs/ApplicationBloc.dart';
import 'package:insightq/src/blocs/BlocProvider.dart';
import 'package:insightq/src/ui/InsightQMain.dart';

const languages = const [
  const Language('English', 'en_US'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class App extends StatelessWidget {

  App ();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Material(
          child: BlocProvider<ApplicationBloc>(
            bloc: ApplicationBloc(),
            child: InsightQMain(),
          )
      ),
    );
  }
}
