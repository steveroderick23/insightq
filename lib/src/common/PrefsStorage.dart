import 'package:googleapis_auth/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsStorage
{

  Future saveCredentials(AccessToken accessToken, String refreshToken) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("data", accessToken.data);
    prefs.setString("type", accessToken.type);
    prefs.setString("expiry", accessToken.expiry.toIso8601String());
    prefs.setString("refreshToken", refreshToken);
  }

  Future<Map<String, dynamic>> getCredentials() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> creds = new Map<String, String>();
    if (prefs.getString("data") != null) creds["data"] = prefs.getString("data");
    if (prefs.getString("type") != null) creds["type"] = prefs.getString("type");
    if (prefs.getString("expiry") != null) creds["expiry"] = prefs.getString("expiry");
    if (prefs.getString("refreshToken") != null) creds["refreshToken"] = prefs.getString("refreshToken");

    return creds;
  }

  Future clear() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("data");
    prefs.remove("type");
    prefs.remove("expiry");
    prefs.remove("refreshToken");
  }
}