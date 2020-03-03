
import 'package:flutter/material.dart';
import 'package:insightq/src/blocs/ApplicationBloc.dart';
import 'package:insightq/src/blocs/BlocProvider.dart';
import 'package:insightq/src/models/InsightQState.dart';

class DassForm extends StatefulWidget {

  DassForm();

  static String routeName = "dassForm";

  @override
  DassFormState createState() => new DassFormState();

}

class DassFormState extends State<DassForm> with AutomaticKeepAliveClientMixin<DassForm>, TickerProviderStateMixin {

  ApplicationBloc _appBloc;

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
            title: Text('DASS Form'),
          ),
          backgroundColor: Colors.white,
          body: _buildLayout(context),
        ),
      ),
    );

  }

  Widget _buildLayout(BuildContext context) {

    return StreamBuilder<InsightQState>(

      stream: _appBloc.state,
      builder: (BuildContext context, AsyncSnapshot<InsightQState> appBlocStream){

        if (appBlocStream.hasData) {

            return Text("DASS");

          }
          else if (appBlocStream.hasError) {
            return Text(appBlocStream.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }


}