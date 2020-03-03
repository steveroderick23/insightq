import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insightq/src/blocs/ApplicationBloc.dart';
import 'package:insightq/src/blocs/BlocProvider.dart';
import 'package:insightq/src/common/common.dart';
import 'package:insightq/src/models/InsightQState.dart';
import 'package:insightq/src/models/ScreenInfo.dart';
import 'package:insightq/src/ui/InsightQDrawer.dart';
import 'package:insightq/src/ui/forms/DassForm.dart';
import 'package:insightq/src/ui/forms/PwreForm.dart';

class InsightQMain extends StatefulWidget {

  InsightQMain();

  @override
  InsightQMainMainState createState() => new InsightQMainMainState();

}

class InsightQMainMainState extends State<InsightQMain> {

  InsightQMainMainState();

  ApplicationBloc _appBloc;
  String _formSelection;

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

    _appBloc = BlocProvider.of<ApplicationBloc>(context);

    _formSelection = "PWRE";

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
    _appBloc.setMediaData(screenInfo);

    var routes = <String, WidgetBuilder>
    {

      PwreForm.routeName: (BuildContext context) => BlocProvider<ApplicationBloc>(
        bloc: ApplicationBloc(),
        child: PwreForm(),
      ),

    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      routes: routes,
      home: Scaffold(
          appBar: appBar,
          drawer: new InsightQDrawer(),
          body: StreamBuilder<InsightQState>(
            stream: _appBloc.state,
            builder: (BuildContext context, AsyncSnapshot<InsightQState> stream){
              if (stream.hasData) {
                return OrientationBuilder(builder: (context, orientation) {
                  return Column(
                    children: <Widget>[
                      SizedBox(height: 50.0,),
                      Center(child:
                        Column(
                          children: <Widget>[
                            Text(
                              "Select Form",
                              style: TextStyle(color: Colors.blue, fontSize: 18.0),
                            ),
                            SizedBox(height: 10.0),
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
                                  setState(() {

                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 20.0),
                            FlatButton(
                              color: Colors.blue,
                              child: Text(
                                'Go',
                                semanticsLabel: 'GO',
                                style: new TextStyle(fontSize: 16.0, color: Colors.white),
                              ),
                              onPressed: () async {
                                switch(_formSelection) {
                                  case "PWRE": {
                                      await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return PwreForm();
                                              }
                                          )
                                      );
                                  }
                                  break;
                                  case "DASS": {
                                      await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return DassForm();
                                              }
                                          )
                                      );
                                  }
                                  break;
                                  default: {

                                  }
                                  break;
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                });
              }
              else if (stream.hasError) {
                return Text(stream.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            }
          ),
      ),
    );

  }

}