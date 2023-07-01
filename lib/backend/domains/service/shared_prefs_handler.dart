import 'package:shared_preferences/shared_preferences.dart';

Future<String> getTigerPath() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? path = prefs.getString('tigerPath');
  return path ?? "";
}

void setTigerPath(String path) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("tigerPath", path);
}

Future<String> getTigerCompilationOptions() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? path = prefs.getString('tigerCompilationOptions');
  return path ?? "";
}

void setTigerCompilationOptions(String path) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("tigerCompilationOptions", path);
}

Future<String> getJavaCompilationOptions() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? path = prefs.getString('javaCompilationOptions');
  return path ?? "";
}

void setJavaCompilationOptions(String path) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("javaCompilationOptions", path);
}
