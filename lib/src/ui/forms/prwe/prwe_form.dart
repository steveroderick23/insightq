import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:insightq/src/common/common.dart';
import 'package:insightq/src/common/custom_dialog.dart';
import 'package:insightq/src/common/google_drive.dart';
import 'package:insightq/src/models/prwe_model.dart';
import 'package:insightq/src/ui/forms/prwe/pwre_pdf_writer.dart';
import 'package:insightq/src/ui/thank_you.dart';

class PrweForm extends StatefulWidget {
  PrweForm(this.prweModel);

  final PrweModel prweModel;
  static String routeName = "prweForm";

  @override
  PrweFormState createState() => new PrweFormState(prweModel);
}

class PrweFormState extends State<PrweForm> with AutomaticKeepAliveClientMixin<PrweForm>, TickerProviderStateMixin {
  PrweFormState(this._prweModel);

  final PrweModel _prweModel;

  CarouselSlider _carousel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _prweModel.initializeQuestions();
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
            title: Text('PRWE Form'),
          ),
          backgroundColor: Colors.white,
          body: _buildLayout(context),
        ),
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    _carousel = _buildCarousel(_prweModel);

    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        IntrinsicWidth(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: _carousel,
          ),
        ),
      ]),
    );
  }

  Widget _buildCarousel(PrweModel prweModel) {
    List<Widget> carouselPanels = List<Widget>();
    prweModel.questions.forEach((question) {
      carouselPanels.add(Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: EdgeInsets.all(5.0),
          color: Colors.blue,
          width: MediaQuery.of(context).size.width * .9,
          child: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.white,
            width: MediaQuery.of(context).size.width * .9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * .9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Question ${question.order} of ${prweModel.questionList.length}",
                        style: TextStyle(color: Colors.blue, fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          question.sectionDescriptorKey,
                          style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          question.sectionDescriptorValue,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          question.questionText,
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 70.0, right: 70.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  11,
                                  (index) => Text(
                                    index.toString(),
                                    style: TextStyle(color: Colors.blue, fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: 50.0,
                                right: 50.0,
                              ),
                              child: Slider(
                                value: question.answerValue,
                                divisions: 10,
                                max: 10,
                                min: 0,
                                onChanged: (newAnswerValue) {
                                  question.answerValue = newAnswerValue;
                                  setState(() {});
                                },
                                label: question.answerValue.toString(),
                              ),
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
                      question.order > 1
                          ? FlatButton(
                              color: Colors.blue,
                              child: Text(
                                'Previous',
                                semanticsLabel: 'Previous',
                                style: new TextStyle(fontSize: 16.0, color: Colors.white),
                              ),
                              onPressed: () async {
                                _carousel.previousPage(duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
                                setState(() {});
                              },
                            )
                          : SizedBox(
                              width: 1.0,
                            ),
                      question.order < prweModel.questions.length
                          ? FlatButton(
                              color: Colors.blue,
                              child: Text(
                                'Next',
                                semanticsLabel: 'NEXT',
                                style: new TextStyle(fontSize: 16.0, color: Colors.white),
                              ),
                              onPressed: () async {
                                _carousel.nextPage(duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
                                setState(() {});
                              },
                            )
                          : FlatButton(
                              color: Colors.blue,
                              child: Text(
                                'Finish',
                                semanticsLabel: 'FINISH',
                                style: new TextStyle(fontSize: 16.0, color: Colors.white),
                              ),
                              onPressed: () async {
                                try {
                                  var file = await writeToPdf(context, prweModel);
                                  // grey out the screen and show a spinner
                                  await GoogleDriveClient(context).upload(file);
                                  // remove the spinner
                                  await file.delete();
                                  await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                    return ThankYou();
                                  }));
                                } catch (ex) {
                                  await showDialog<DialogActions>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return CustomDialog(
                                            title: "Error generating pdf and uploading to Google Drive ...",
                                            description: "You may need to re-authenticate this App with google. This can be done by tapping 'Initial Setup' in the main menu.",
                                            okButtonText: "Ok",
                                            cancelButtonText: "",
                                            onOkButtonPressed: () {
                                              Navigator.of(context).pop();
                                            });
                                      });
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    });

    return CarouselSlider(
      height: MediaQuery.of(context).size.height,
      viewportFraction: 0.9,
      onPageChanged: (newPage) {},
      items: carouselPanels,
      initialPage: 0,
      enableInfiniteScroll: false,
      reverse: false,
      autoPlay: false,
    );
  }
}
