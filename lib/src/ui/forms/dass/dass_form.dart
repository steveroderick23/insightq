import 'package:flutter/material.dart';

class DassForm extends StatefulWidget {
  DassForm();

  static String routeName = "dassForm";

  @override
  DassFormState createState() => new DassFormState();
}

class DassFormState extends State<DassForm> with AutomaticKeepAliveClientMixin<DassForm>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

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
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('DASS Form'),
          ),
          backgroundColor: Colors.white,
          body: _buildLayout(context),
        ),
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    return Text("DASS");
  }
}
