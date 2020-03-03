import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:insightq/src/common/PrefsStorage.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _clientId = "625584040905-n5a0ohogaj818h7iuq73ohepu3old8ov.apps.googleusercontent.com";
final _callbackUrlScheme = 'com.googleusercontent.apps.625584040905-n5a0ohogaj818h7iuq73ohepu3old8ov';
const _clientSecret = "bwzAULqG6zS02uRt4velrt--";
const _scopes = [ga.DriveApi.DriveScope];

class GoogleDrive {

  GoogleDrive(this._context);

  final BuildContext _context;
  String _authCode;

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  PrefsStorage prefsStorage = PrefsStorage();

  Future<http.Client> getHttpClient() async
  {
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.startsWith('com.googleusercontent.apps.625584040905-n5a0ohogaj818h7iuq73ohepu3old8ov')) {
        Navigator.of(_context).pop(url);
        flutterWebviewPlugin.close();
      }
    });

    // get creds from shared prefs
    var creds = await prefsStorage.getCredentials();
    if (creds.isEmpty) // auth needed
    {

      final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
        'response_type': 'code',
        'client_id': _clientId,
        'redirect_uri': '$_callbackUrlScheme:/',
        'scope': ga.DriveApi.DriveScope,
      });

      final Completer<WebViewController> _controller = Completer<WebViewController>();
      _authCode = await Navigator.of(_context).push(
          MaterialPageRoute(
              builder: (BuildContext context) {
                return Container(
                    margin: const EdgeInsets.only(top: 100.0),
                    child: SafeArea(
                      top: false,
                      child: new WebviewScaffold(
                        userAgent: "random",
                        url: url.toString(),
                        withZoom: true,
                        withLocalStorage: true,
                        hidden: true,
                        initialChild: Container(
                          color: Colors.white,
                          child: const Center(
                            child: Text('Waiting.....'),
                          ),
                        ),
                      ),
                    ),
                );
              }
          )
      );

      flutterWebviewPlugin.dispose();

      // Extract code from resulting url
      final code = Uri.parse(_authCode).queryParameters['code'];

      // Use this code to get an access token
      final response = await http.post("https://oauth2.googleapis.com/token", body: {
        'client_id': _clientId,
        'client_secret': _clientSecret,
        'redirect_uri': '$_callbackUrlScheme:/',
        'grant_type': 'authorization_code',
        'code': code,
      });

      // Get the access token from the response
      final accessToken = jsonDecode(response.body)['access_token'] as String;
      final refreshToken = jsonDecode(response.body)['refresh_token'] as String;
      final expiry = DateTime.now().toUtc().add(Duration(milliseconds: jsonDecode(response.body)['expires_in'] as int));
      final type = jsonDecode(response.body)['token_type'] as String;
      await prefsStorage.saveCredentials(AccessToken(type, accessToken, expiry), refreshToken);
      return authenticatedClient(
          http.Client(),
          AccessCredentials(AccessToken(
              type,
              accessToken,
              expiry),
              refreshToken,
              _scopes));
    }
    else // already auth'd
    {
      return authenticatedClient(
          http.Client(),
          AccessCredentials(AccessToken(
            creds["type"],
            creds["data"],
            DateTime.parse(creds["expiry"])),
            creds["refreshToken"],
            _scopes));
    }

  }

  Future upload(File file) async
  {
    var client = await getHttpClient();

    var drive = ga.DriveApi(client);

    var response = await drive.files.create(ga.File()..name = p.basename(file.absolute.path),
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()));

    print(response.toJson());
  }
}