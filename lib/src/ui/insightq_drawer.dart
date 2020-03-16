import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:insightq/src/ui/onboarding/onboarding_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, String url, String text}) : super(style: style, text: text ?? url, recognizer: new TapGestureRecognizer()..onTap = () {});
}

class InsightQDrawer extends StatelessWidget {
  InsightQDrawer();

  @override
  Widget build(BuildContext context) {
    final List<Widget> allDrawerItems = buildWidgetList(context);

    return new Drawer(child: new ListView(primary: false, children: allDrawerItems));
  }

  List<Widget> buildWidgetList(BuildContext context) {
    List<Widget> widgetList = new List<Widget>();

    widgetList.add(
      Container(
        padding: EdgeInsets.only(
          right: 10.0,
          left: 10.0,
          top: 10.0,
          bottom: 0.0,
        ),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image(image: AssetImage('assets/insightqlogo.png'), width: 64.0, height: 64.0, fit: BoxFit.scaleDown, alignment: FractionalOffset.center),
              SizedBox(width: 10.0),
              Text(
                "InsightQ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "Kalam",
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
        ]),
      ),
    );

    widgetList.add(const Divider());

    widgetList.add(new ListTile(
      leading: new Icon(
        Icons.help,
        color: Colors.green,
      ),
      title: new Text('Initial Setup'),
      onTap: () async {
        var prefs = await SharedPreferences.getInstance();
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return OnboardingPages(prefs);
        }));
      },
    ));

    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.bodyText1;

    widgetList.add(
      new AboutListTile(icon: new Image(image: new AssetImage('assets/insightqlogo.png'), width: 24.0, height: 24.0, fit: BoxFit.scaleDown, alignment: FractionalOffset.center), applicationVersion: '1.0.2', applicationIcon: new Image(image: new AssetImage('assets/insightqlogo.png'), width: 96.0, height: 96.0, fit: BoxFit.scaleDown, alignment: FractionalOffset.center), applicationLegalese: '© 2020 Spring Breeze Solutions', aboutBoxChildren: <Widget>[
        new Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: new RichText(
                text: new TextSpan(children: <TextSpan>[
              new TextSpan(style: aboutTextStyle, text: "InsightQ ... insightful, no?"),
            ])))
      ]),
    );

    return widgetList;
  }
}
