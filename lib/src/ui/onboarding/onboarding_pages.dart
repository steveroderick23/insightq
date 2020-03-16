import 'package:flutter/material.dart';
import 'package:insightq/src/app.dart';
import 'package:insightq/src/common/common.dart';
import 'package:insightq/src/common/custom_dialog.dart';
import 'package:insightq/src/common/google_drive.dart';
import 'package:insightq/src/common/prefs_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPages extends StatefulWidget {
  OnboardingPages(this.prefs);

  final SharedPreferences prefs;

  @override
  OnboardingPagesState createState() => new OnboardingPagesState(prefs);
}

class OnboardingPagesState extends State<OnboardingPages> {
  OnboardingPagesState(this._prefs);

  final SharedPreferences _prefs;
  final _introKey = GlobalKey<IntroductionScreenState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String _val1 = "-";
  String _val2 = "-";
  String _val3 = "-";
  String _val4 = "-";
  String _enableAccessButtonText = "Enable Access";
  IntroductionScreen _introductionScreen;
  PrefsStorage _prefsStorage = PrefsStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _introductionScreen = _buildIntroductionScreen();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        body: _introductionScreen,
      ),
    );
  }

  IntroductionScreen _buildIntroductionScreen() {
    return IntroductionScreen(
      key: _introKey,
      pages: _buildPages(context),
      onDone: () async {
        if (_val1 == "-" || _val2 == "-" || _val3 == "-" || _val4 == "-") {
          await showDialog<DialogActions>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CustomDialog(
                    title: "Pin Invalid...",
                    description: "Please enter a 4 digit PIN.",
                    okButtonText: "Ok",
                    cancelButtonText: "",
                    onOkButtonPressed: () {
                      Navigator.of(context).pop();
                    });
              });
          return;
        }

        _prefs.setString('pinCode', "$_val1$_val2$_val3$_val4");

        if (_prefs.getBool('seen') == true) {
          Navigator.pop(context);
        } else {
          _prefs.setBool('seen', true);
          runApp(
            App(
              pinCode: "$_val1$_val2$_val3$_val4",
            ),
          );
        }
      },
      onChange: (pageNum) async {
        var creds = await _prefsStorage.getCredentials();
        if (creds.length > 0) {
          _enableAccessButtonText = "Acccess Enabled. Click To Change";
          setState(() {});
        }

        if (pageNum == 2) {
          if (_enableAccessButtonText == "Enable Access") {
            await showDialog<DialogActions>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomDialog(
                      title: "Access Not Granted...",
                      description: "You must enable Google Drive access before proceeding.",
                      okButtonText: "Ok",
                      cancelButtonText: "",
                      onOkButtonPressed: () {
                        Navigator.of(context).pop();
                      });
                });
            _introKey.currentState?.animateScroll(1);
          }
        }
      },
      onSkip: () async {
        if (_prefs.getBool('seen') == true) {
          Navigator.pop(context);
        } else {
          _prefs.setBool('seen', true);
          runApp(
            new App(),
          );
        }
      },
      globalBackgroundColor: Color.fromRGBO(212, 20, 15, 1.0),
      showSkipButton: _prefs.getBool('seen') == true ? true : false,
      next: Icon(
        Icons.arrow_right,
        size: 3 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)),
      ),
      done: Text(
        "Done",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 1.4 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)),
        ),
      ),
      skip: Text(
        "Skip",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 1.4 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)),
        ),
      ),
      dotsFlex: 2,
    );
  }

  List<PageViewModel> _buildPages(BuildContext context) {
    return [
      PageViewModel(
        titleWidget: Container(
          padding: EdgeInsets.all(
            0.0,
          ),
          child: Text(
            "Welcome to InsightQ",
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 2.0 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)),
              color: Colors.white,
            ),
          ),
        ),
        bodyWidget: Container(
          padding: EdgeInsets.only(
            left: 5 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)),
            right: 5 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)),
          ),
          child: Text(
            "Before we get to the real work, there are a few things that need to be setup. Tap the forward or back arrows to move between screens and tap Done when finished.",
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 1.5 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)),
              color: Colors.white,
            ),
          ),
        ),
        image: Center(child: Image.asset("assets/insightqlogo.png", height: 8 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)))),
        decoration: const PageDecoration(
          pageColor: Colors.blue,
          imageFlex: 2,
          bodyFlex: 4,
          bodyTextStyle: TextStyle(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      PageViewModel(
        titleWidget: Container(
          padding: EdgeInsets.all(
            0.0,
          ),
          child: Text(
            "Give access permissions to your Google Drive folder",
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 2.0 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)),
              color: Colors.white,
            ),
          ),
        ),
        bodyWidget: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  left: 5 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)),
                  right: 5 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)),
                ),
                child: Text(
                  "All forms will be uploaded as PDF's to a google drive folder. In order for this to work, you must give the app access to a Google Drive account of your choosing. Click below to start the process.",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 1.5 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                color: Colors.black,
                child: Text(
                  _enableAccessButtonText,
                  semanticsLabel: 'ENABLEACCESS',
                  style: new TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                onPressed: () async {
                  var result = await GoogleDriveClient(context).kickOffOAuthHandshake();
                  if (result)
                    _enableAccessButtonText = "Acccess Enabled. Click To Change";
                  else {
                    await showDialog<DialogActions>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return CustomDialog(
                              title: "Access Not Granted ...",
                              description: "Access was not sucessfully granted. Please Try again.",
                              okButtonText: "Ok",
                              cancelButtonText: "",
                              onOkButtonPressed: () {
                                Navigator.of(context).pop();
                              });
                        });
                    _enableAccessButtonText = "Enable Access";
                  }

                  setState(() {});
                },
              )
            ],
          ),
        ),
        image: Center(child: Image.asset("assets/insightqlogo.png", height: 8 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)))),
        decoration: const PageDecoration(
          pageColor: Colors.blue,
          imageFlex: 2,
          bodyFlex: 4,
          bodyTextStyle: TextStyle(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      PageViewModel(
        titleWidget: Container(
          padding: EdgeInsets.all(
            0.0,
          ),
          child: Text(
            "Enter a PIN",
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 2.0 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)),
              color: Colors.white,
            ),
          ),
        ),
        bodyWidget: Container(
          padding: EdgeInsets.only(
            left: 5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
            right: 5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
          ),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Center(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "To ensure privacy and security, please provide a PIN that will be used to access the app.",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        fontSize: 1.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 2.0 * calculateVerticalScaleMultiplier(MediaQuery.of(context)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          color: Colors.black,
                          height: 6.0 * calculateVerticalScaleMultiplier(MediaQuery.of(context)),
                          width: 16.0 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 6.0 * calculateVerticalScaleMultiplier(MediaQuery.of(context)),
                                width: 4.0 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(),
                                ),
                                child: Center(
                                  child: Text(
                                    _val4 != "-" ? "*" : "-",
                                    style: TextStyle(
                                      fontSize: 2 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 6.0 * calculateVerticalScaleMultiplier(MediaQuery.of(context)),
                                width: 4.0 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(),
                                ),
                                child: Center(
                                  child: Text(
                                    _val3 != "-" ? "*" : "-",
                                    style: TextStyle(
                                      fontSize: 2 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 6.0 * calculateVerticalScaleMultiplier(MediaQuery.of(context)),
                                width: 4.0 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(),
                                ),
                                child: Center(
                                  child: Text(
                                    _val2 != "-" ? "*" : "-",
                                    style: TextStyle(
                                      fontSize: 2 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 6.0 * calculateVerticalScaleMultiplier(MediaQuery.of(context)),
                                width: 4.0 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(),
                                ),
                                child: Center(
                                  child: Text(
                                    _val1 != "-" ? "*" : "-",
                                    style: TextStyle(
                                      fontSize: 2 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: .5 * calculateVerticalScaleMultiplier(MediaQuery.of(context)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 36 * calculateVerticalScaleMultiplier(MediaQuery.of(context)),
                          width: 16 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                          child: GridView.count(
                            padding: EdgeInsets.all(1.0),
                            mainAxisSpacing: 3.0,
                            crossAxisSpacing: 5.0,
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  updatePinDisplay("1", 1);
                                },
                                child: Container(
                                  color: Colors.black,
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      "1",
                                      style: TextStyle(
                                        fontSize: 2.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  updatePinDisplay("2", 2);
                                },
                                child: Container(
                                  color: Colors.black,
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      "2",
                                      style: TextStyle(
                                        fontSize: 2.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  updatePinDisplay("3", 3);
                                },
                                child: Container(
                                  color: Colors.black,
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      "3",
                                      style: TextStyle(
                                        fontSize: 2.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  updatePinDisplay("4", 4);
                                },
                                child: Container(
                                  color: Colors.black,
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      "4",
                                      style: TextStyle(
                                        fontSize: 2.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  updatePinDisplay("5", 5);
                                },
                                child: Container(
                                  color: Colors.black,
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      "5",
                                      style: TextStyle(
                                        fontSize: 2.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  updatePinDisplay("6", 6);
                                },
                                child: Container(
                                  color: Colors.black,
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      "6",
                                      style: TextStyle(
                                        fontSize: 2.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  updatePinDisplay("7", 7);
                                },
                                child: Container(
                                  color: Colors.black,
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      "7",
                                      style: TextStyle(
                                        fontSize: 2.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  updatePinDisplay("8", 8);
                                },
                                child: Container(
                                  color: Colors.black,
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      "8",
                                      style: TextStyle(
                                        fontSize: 2.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  updatePinDisplay("9", 9);
                                },
                                child: Container(
                                  color: Colors.black,
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      "9",
                                      style: TextStyle(
                                        fontSize: 2.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.black,
                                padding: EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                      fontSize: 2.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  updatePinDisplay("0", 0);
                                },
                                child: Container(
                                  color: Colors.black,
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      "0",
                                      style: TextStyle(
                                        fontSize: 2.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  updatePinDisplay("<", 1);
                                },
                                child: Container(
                                  color: Colors.black,
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      "<",
                                      style: TextStyle(
                                        fontSize: 2.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        image: Center(child: Image.asset("assets/insightqlogo.png", height: 8 * calculateStaggeredGridScaleMultiplier(MediaQuery.of(context)))),
        decoration: const PageDecoration(
          pageColor: Colors.blue,
          imageFlex: 5,
          bodyFlex: 10,
          bodyTextStyle: TextStyle(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      )
    ];
  }

  updatePinDisplay(String value, int segmentLength) {
    if (value == "<") {
      if (_val1 != "-") {
        _val1 = "-";
      } else if (_val2 != "-") {
        _val2 = "-";
      } else if (_val3 != "-") {
        _val3 = "-";
      } else if (_val4 != "-") {
        _val4 = "-";
      }
    } else if (_val4 == "-") {
      _val4 = value;
    } else if (_val3 == "-") {
      _val3 = value;
    } else if (_val2 == "-") {
      _val2 = value;
    } else if (_val1 == "-") {
      _val1 = value;
    }

    setState(() {});
  }
}
