import 'dart:convert';

import 'package:ping/backend/domains/entity/feature/feature.dart';
import 'package:ping/backend/domains/entity/project_interface.dart';
import 'package:http/http.dart' as http;
import 'package:ping/backend/utils/files/file_utils.dart';

class ServerResponse {
  final String content;

  ServerResponse({required this.content});

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    return ServerResponse(
      content: json['output'],
    );
  }
}

class TigrouRemote extends Feature {
  TigrouRemote() : super(TigerFeature.remote);

  Future<ServerResponse> remoteCompile(String content) async {
    var data = {
      'content': content,
    };
    final response =  await http.post(
      Uri.parse('https://tigrou.celian.cloud/compile'),
      body: data,
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return ServerResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Error remote: ${response.body}');
    }
  }


  @override
  Future<ExecutionReport> execute(IProject project, {List<String> additionalArguments = const []}) async {

    ServerResponse response = await remoteCompile('print("Hello World")');
    await writeOutput(response.content, project.getRootNode().getPath());
    ExecutionReport report = () => true;

    return Future.value(report);
  }

}