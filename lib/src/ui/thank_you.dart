import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insightq/src/ui/home.dart';

class ThankYou extends StatefulWidget {
  ThankYou();

  @override
  ThankYouState createState() => new ThankYouState();
}

class ThankYouState extends State<ThankYou> {
  AppBar appBar = AppBar(
    title: Text('Thank You'),
  );

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
            return Home();
          }));
          return;
        },
        child: _buildBody());
  }

  Widget _buildBody() {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Thank You!'),
          ),
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(image: new AssetImage('assets/insightqlogo.png'), width: 64.0, height: 64.0, fit: BoxFit.scaleDown, alignment: FractionalOffset.center),
                  Container(
                    padding: EdgeInsets.only(
                      left: 10.0,
                    ),
                  ),
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
              SizedBox(height: 40.0),
              Center(
                child: Text(
                  "Thank You for completing the form.",
                  style: TextStyle(color: Colors.black, fontSize: 20.0, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  "Please return the tablet to a staff member.",
                  style: TextStyle(color: Colors.black, fontSize: 18.0, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
