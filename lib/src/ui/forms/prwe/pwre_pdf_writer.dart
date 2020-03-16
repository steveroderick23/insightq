import 'dart:io';

import 'package:flutter/material.dart' as mat;
import 'package:insightq/src/models/prwe_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File> writeToPdf(mat.BuildContext context, PrweModel prweModel) async {
  File file;

  var dateString = new DateFormat("y-M-d").format(new DateTime.now());
  var printedTimestamp = new DateFormat("y-M-d hh:mm:ss").format(new DateTime.now());

  Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  if (permissions.containsKey(PermissionGroup.storage) && permissions[PermissionGroup.storage] == PermissionStatus.granted) {
    final Document pdf = Document();

    List<Widget> widgetList = List<Widget>();
    widgetList.add(Header(level: 0, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[Text('Patient-Rated Wrist Evaluation', textScaleFactor: 2)])));
    widgetList.add(Paragraph(
      text: 'Subject: ${prweModel.subjectId}',
      style: TextStyle(
        fontSize: 9.0,
      ),
    ));
    widgetList.add(Paragraph(
      text: 'Date: $dateString',
      style: TextStyle(
        fontSize: 9.0,
      ),
    ));
    widgetList.add(Header(level: 1, text: 'Responses'));

    prweModel.questions.asMap().forEach((i, prweQuestion) {
      widgetList.add(Paragraph(
        text: 'Question ${i + 1}: ${prweQuestion.questionText}, Response: ${prweQuestion.answerValue}',
        style: TextStyle(
          fontSize: 9.0,
        ),
      ));
    });

    widgetList.add(Header(level: 1, text: 'Score'));
    widgetList.add(
      Paragraph(
        text: '${prweModel.calculateScore()}',
        style: TextStyle(
          fontSize: 9.0,
        ),
      ),
    );

    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return Container(alignment: Alignment.centerRight, margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm), padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm), decoration: const BoxDecoration(border: BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)), child: Text('Portable Document Format', style: Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey)));
        },
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Printed $printedTimestamp',
                  style: TextStyle(
                    fontSize: 8.0,
                  )));
        },
        build: (Context context) => widgetList));

    Directory directory = await getApplicationDocumentsDirectory();

    // file name is formType_subjectId_date.pdf
    String subjectIdForFilename = prweModel.subjectId.replaceAll("", "").trim();
    file = File("${directory.path}/pwre_${subjectIdForFilename}_$dateString.pdf");
    file.writeAsBytesSync(pdf.save());
  }

  return file;
}
