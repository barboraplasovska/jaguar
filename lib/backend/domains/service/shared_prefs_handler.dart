import 'package:shared_preferences/shared_preferences.dart';

import '../entity/feature/compiler/tigrou/tigrou_compiler.dart';

Future<String> getTigerPath() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? path = prefs.getString('tigerPath');
  return path ?? "";
}

void setTigerPath(String path) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("tigerPath", path);
  TigrouCompiler.setCompiler(path);
}
