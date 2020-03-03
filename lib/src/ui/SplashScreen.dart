import 'package:flutter/material.dart';

Widget splashScreen() {
  return new MaterialApp(
    debugShowCheckedModeBanner: false,
    home:  new Scaffold(
        backgroundColor: Colors.white,
        body: new Container(
          padding: const EdgeInsets.only(
            right: 20.0,
            left: 0.0,
            top: 75.0,
          ),
          child: new Center(
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: new AssetImage(
                            'assets/insightqlogo.png'
                        ),
                        width: 64.0,
                        height: 64.0,
                        fit: BoxFit.scaleDown,
                        alignment: FractionalOffset.center
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0,),
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
                new Container(
                  padding: EdgeInsets.only(
                    right: 20.0,
                    left: 20.0,
                    top: 10.0,
                  ),
                  child: Center(

                    child: new Text(
                      "Loading ...",
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    ),
  );
}