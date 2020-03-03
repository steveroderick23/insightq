
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:insightq/src/blocs/ApplicationBloc.dart';
import 'package:insightq/src/blocs/BlocProvider.dart';
import 'package:insightq/src/models/InsightQState.dart';
import 'package:pdf/pdf.dart' as pdflib;
import 'package:pdf/widgets.dart' as pdfwidgetslib;

import 'PdfWriter.dart';

class PwreForm extends StatefulWidget {

  PwreForm();

  static String routeName = "pwreForm";

  @override
  PwreFormState createState() => new PwreFormState();

}

class PwreFormState extends State<PwreForm> with AutomaticKeepAliveClientMixin<PwreForm>, TickerProviderStateMixin {

  ApplicationBloc _appBloc;
  Map<int, double> questionAnswers = {1: 1.0, 2: 5.0, 3: 8.0};
  CarouselSlider _carousel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _appBloc = BlocProvider.of<ApplicationBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('PWRE Form'),
          ),
          backgroundColor: Colors.white,
          body: _buildLayout(context),
        ),
      ),
    );

  }

  Widget _buildLayout(BuildContext context) {

    _carousel = _buildCarousel();

    return StreamBuilder<InsightQState>(

      stream: _appBloc.state,
      builder: (BuildContext context, AsyncSnapshot<InsightQState> appBlocStream){

        if (appBlocStream.hasData) {

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IntrinsicWidth(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: _carousel,
                  ),
                ),
              ]
            ),
          );

          }
          else if (appBlocStream.hasError) {
            return Text(appBlocStream.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }

  Widget _buildCarousel() {

    return CarouselSlider(
      height: MediaQuery.of(context).size.height,
      viewportFraction: 0.9,
      onPageChanged: (newPage) {  },
      items: [
        Container(
          padding: EdgeInsets.all(20.0),
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.blue,
            width: MediaQuery.of(context).size.width*.9,
            child: Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              width: MediaQuery.of(context).size.width*.9,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20.0),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width*.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Question 1 of 3",
                          style: TextStyle(color: Colors.blue, fontSize: 18.0),
                        ),
                        SizedBox(height: 20.0,),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut "
                                "labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco "
                                "laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in "
                                "voluptate velit esse cillum dolore eu fugiat nulla pariatur. E"
                                "xcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                            style: TextStyle(color: Colors.blue, fontSize: 14.0),
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(11, (index) => Text(
                                    index.toString(),
                                    style: TextStyle(color: Colors.blue, fontSize: 14.0),
                                  ),
                                  ),
                                ),
                              ),
                              Slider(
                                value: questionAnswers[1],
                                divisions: 10,
                                max: 10,
                                min: 0,
                                onChanged: (newAnswerValue) {
                                  questionAnswers[1] = newAnswerValue;
                                  setState(() {

                                  });
                                },
                                label: questionAnswers[1].toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.0,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(width: 1.0,),
                        FlatButton(
                          color: Colors.blue,
                          child: Text(
                            'Next',
                            semanticsLabel: 'NEXT',
                            style: new TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                          onPressed: () async {
                            _carousel.nextPage(duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
                            setState(() {

                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20.0),
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.blue,
            width: MediaQuery.of(context).size.width*.9,
            child: Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              width: MediaQuery.of(context).size.width*.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20.0),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width*.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Question 2 of 3",
                          style: TextStyle(color: Colors.blue, fontSize: 18.0),
                        ),
                        SizedBox(height: 20.0,),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut "
                                "labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco "
                                "laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in "
                                "voluptate velit esse cillum dolore eu fugiat nulla pariatur. E"
                                "xcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                            style: TextStyle(color: Colors.blue, fontSize: 14.0),
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(11, (index) => Text(
                                    index.toString(),
                                    style: TextStyle(color: Colors.blue, fontSize: 14.0),
                                  ),
                                  ),
                                ),
                              ),
                              Slider(
                                value: questionAnswers[2],
                                divisions: 10,
                                max: 10,
                                min: 0,
                                onChanged: (newAnswerValue) {
                                  questionAnswers[2] = newAnswerValue;
                                  setState(() {

                                  });
                                },
                                label: questionAnswers[2].toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.0,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.blue,
                          child: Text(
                            'Previous',
                            semanticsLabel: 'Previous',
                            style: new TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                          onPressed: () async {
                            _carousel.previousPage(duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
                            setState(() {

                            });
                          },
                        ),
                        FlatButton(
                          color: Colors.blue,
                          child: Text(
                            'Next',
                            semanticsLabel: 'NEXT',
                            style: new TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                          onPressed: () async {
                            _carousel.nextPage(duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
                            setState(() {

                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20.0),
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.blue,
            width: MediaQuery.of(context).size.width*.9,
            child: Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              width: MediaQuery.of(context).size.width*.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20.0),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width*.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Question 3 of 3",
                          style: TextStyle(color: Colors.blue, fontSize: 18.0),
                        ),
                        SizedBox(height: 20.0,),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut "
                                "labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco "
                                "laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in "
                                "voluptate velit esse cillum dolore eu fugiat nulla pariatur. E"
                                "xcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                            style: TextStyle(color: Colors.blue, fontSize: 14.0),
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(11, (index) => Text(
                                    index.toString(),
                                    style: TextStyle(color: Colors.blue, fontSize: 14.0),
                                  ),
                                  ),
                                ),
                              ),
                              Slider(
                                value: questionAnswers[3],
                                divisions: 10,
                                max: 10,
                                min: 0,
                                onChanged: (newAnswerValue) {
                                  questionAnswers[3] = newAnswerValue;
                                  setState(() {

                                  });
                                },
                                label: questionAnswers[3].toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.0,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.blue,
                          child: Text(
                            'Previous',
                            semanticsLabel: 'Previous',
                            style: new TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                          onPressed: () async {
                            _carousel.previousPage(duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
                            setState(() {

                            });
                          },
                        ),
                        FlatButton(
                          color: Colors.blue,
                          child: Text(
                            'Finish',
                            semanticsLabel: 'FINISH',
                            style: new TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                          onPressed: () async {
                            await writeToPdf(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      initialPage: 0,
      enableInfiniteScroll: false,
      reverse: false,
      autoPlay: false,
    );
  }

}