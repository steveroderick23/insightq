import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insightq/src/common/common.dart';
import 'package:insightq/src/common/custom_dialog.dart';
import 'package:insightq/src/models/prwe_model.dart';
import 'package:insightq/src/models/screen_info.dart';
import 'package:insightq/src/ui/forms/dass/dass_form.dart';
import 'package:insightq/src/ui/forms/prwe/prwe_form.dart';
import 'package:insightq/src/ui/insightq_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({this.pinCode});

  final String pinCode;

  @override
  HomeState createState() => new HomeState(pinCode);
}

class HomeState extends State<Home> {
  HomeState(this._pinCode);

  final String _pinCode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _formSelection;
  String _pinEntered;
  String _subjectId;

  String _val1 = "-";
  String _val2 = "-";
  String _val3 = "-";
  String _val4 = "-";

  AppBar appBar = AppBar(
    title: Text('InsightQ'),
  );

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _formSelection = "PRWE";
    _pinEntered = _pinCode != null ? _pinCode : "";
    _subjectId = "";

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    ScreenInfo screenInfo = new ScreenInfo(media.orientation, media.size.width, media.size.height, media.devicePixelRatio, 9 * calculateBlockSizeVertical(MediaQuery.of(context)));

    var routes = <String, WidgetBuilder>{
      PrweForm.routeName: (BuildContext context) => PrweForm(PrweModel(_subjectId)),
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      routes: routes,
      home: Scaffold(
        appBar: _pinEntered.length > 0 ? appBar : null,
        drawer: new InsightQDrawer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: _pinEntered.length > 0 ? 50.0 : 100.0,
              ),
              _pinEntered.length > 0
                  ? Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 40.0),
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
                              "Select the desired form(s) and enter the subject's initials. \nThen click Go and pass the device to the subject to complete the form(s)",
                              style: TextStyle(color: Colors.black, fontSize: 18.0, fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 40.0),
                          DropdownButtonHideUnderline(
                            child: new DropdownButton(
                              value: _formSelection,
                              isDense: true,
                              items: formTypes.keys.map((String key) {
                                return new DropdownMenuItem(
                                  value: key,
                                  child: Text(formTypes[key]),
                                );
                              }).toList(),
                              onChanged: (value) {
                                _formSelection = value;
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 300.0,
                            child: Center(
                              child: TextFormField(
                                initialValue: _subjectId,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) => value.isEmpty ? 'Subject Id cannot be blank' : null,
                                onChanged: (String value) {
                                  _subjectId = value;
                                },
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  hintText: "Subject Id",
                                  labelText: "Enter Subject Id",
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 60.0),
                          FlatButton(
                            color: Colors.blue,
                            child: Text(
                              'Go',
                              semanticsLabel: 'GO',
                              style: new TextStyle(fontSize: 16.0, color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_subjectId == null || _subjectId.length == 0) {
                                await showDialog<DialogActions>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return CustomDialog(
                                          title: "Subject Id Required ...",
                                          description: "Please enter a subject Id.",
                                          okButtonText: "Ok",
                                          cancelButtonText: "",
                                          onOkButtonPressed: () {
                                            Navigator.of(context).pop();
                                          });
                                    });
                                return;
                              }

                              switch (_formSelection) {
                                case "PRWE":
                                  {
                                    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                      return PrweForm(PrweModel(_subjectId));
                                    }));
                                  }
                                  break;
                                case "DASS":
                                  {
                                    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                      return DassForm();
                                    }));
                                  }
                                  break;
                                default:
                                  {}
                                  break;
                              }

                              _pinEntered = "";
                              _val1 = "-";
                              _val2 = "-";
                              _val3 = "-";
                              _val4 = "-";
                              _subjectId = "";

                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.max,
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
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "Enter your PIN",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 2.5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                            right: 5 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                          ),
                          child: Form(
                            key: _formKey,
                            autovalidate: _autoValidate,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
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
                                      height: .8 * calculateVerticalScaleMultiplier(MediaQuery.of(context)),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 36 * calculateVerticalScaleMultiplier(MediaQuery.of(context)),
                                          width: 16 * calculateHorizontalScaleMultiplier(MediaQuery.of(context)),
                                          child: GridView.count(
                                            padding: EdgeInsets.all(1.0),
                                            mainAxisSpacing: 5.0,
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
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  updatePinDisplay(String value, int segmentLength) async {
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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String pinEntered = "$_val1$_val2$_val3$_val4";
      if (pinEntered != prefs.getString('pinCode')) {
        await showDialog<DialogActions>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomDialog(
                  title: "Incorrect PIN ...",
                  description: "Please enter the correct PIN.",
                  okButtonText: "Ok",
                  cancelButtonText: "",
                  onOkButtonPressed: () {
                    Navigator.of(context).pop();
                  });
            });
        _val1 = "-";
        _val2 = "-";
        _val3 = "-";
        _val4 = "-";

        setState(() {});

        return;
      } else {
        _pinEntered = pinEntered;
        setState(() {});
      }
    }

    setState(() {});
  }
}
