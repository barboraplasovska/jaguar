import 'dart:io';

Future<void> writeOutput(String output, String rootPath) async {
  Directory directory = Directory("$rootPath/.jaguar");

  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
  var file = File("$rootPath/.jaguar/output");

  // Create the file if it doesn't exist
  if (!await file.exists()) {
    file = await file.create();
  }

  var sink = file.openWrite();
  sink.write(output);
  sink.close();
}
