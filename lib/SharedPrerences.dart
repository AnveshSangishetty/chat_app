import 'package:shared_preferences/shared_preferences.dart';

class Sprefs{

  static String LogInState='ISLOGGEDIN';
  static String UsernameKey='USERNAMEKEY';
  static String PhoneKey='PHONEKEY';

  static Future<void> setLoginState(bool IsUserLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(LogInState, IsUserLoggedIn);
  }

  static Future<void> setUsername(String Usename) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(UsernameKey, Usename);
  }

  static Future<void> setPhoneNo(String Phone) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(PhoneKey, Phone);
  }

  ////////////////////////////////

  static Future<bool> getLoginState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(LogInState);
  }

  static Future<String> getUsername() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(UsernameKey);
  }

  static Future<String> getPhoneNo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(PhoneKey);
  }
}