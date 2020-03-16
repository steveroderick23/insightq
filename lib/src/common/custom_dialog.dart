import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 44.0;
}

class CustomDialog extends StatelessWidget {
  final String title, description, okButtonText, cancelButtonText;
  final Image image;
  final VoidCallback onOkButtonPressed, onCancelButtonPressed;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.okButtonText,
    @required this.onOkButtonPressed,
    this.cancelButtonText,
    this.onCancelButtonPressed,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildBottomCard(context),
        _buildCircularImage(),
      ],
    );
  }

  Widget _buildBottomCard(BuildContext context) {
    return Container(
      width: 500.0,
      padding: EdgeInsets.only(
        top: Consts.avatarRadius + Consts.padding,
        bottom: Consts.padding,
        left: Consts.padding,
        right: Consts.padding,
      ),
      margin: EdgeInsets.only(top: Consts.avatarRadius),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Consts.padding),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                color: Colors.blue,
                child: Text(
                  okButtonText,
                  style: new TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                onPressed: onOkButtonPressed,
              ),
              SizedBox(width: 20.0),
              FlatButton(
                color: Colors.blue,
                child: Text(
                  cancelButtonText,
                  style: new TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                onPressed: onCancelButtonPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularImage() {
    return Positioned(
      left: Consts.padding,
      right: Consts.padding,
      child: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        radius: Consts.avatarRadius,
        child: Image.asset(
          'assets/insightqlogo.png',
        ),
      ),
    );
  }
}
