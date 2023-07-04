import 'dart:io';

String getAbsolutePath(String path) {
  String? homeDirectory = Platform.environment['HOME'];

  if (homeDirectory != null && path.contains(homeDirectory)) {
    int homeIndex = path.indexOf(homeDirectory);
    String precedingPath = path.substring(0, homeIndex);
    String tildePath = '~${path.substring(homeIndex + homeDirectory.length)}';
    return tildePath.replaceFirst(precedingPath, '');
  } else {
    return path;
  }
}

String? getHomeDirectory() {
  if (Platform.isWindows) {
    return Platform.environment['UserProfile'];
  } else {
    return Platform.environment['HOME'];
  }
}
