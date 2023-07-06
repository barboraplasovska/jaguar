import 'dart:convert';
import 'dart:io';

import 'package:jaguar/backend/domains/entity/feature/feature.dart';
import 'package:jaguar/backend/domains/entity/project_interface.dart';
import 'package:http/http.dart' as http;
import 'package:jaguar/backend/utils/files/file_utils.dart';

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
    final response = await http.post(
      Uri.parse('https://tigrou.celian.cloud/compile'),
      body: data,
    );

    if (response.statusCode == 200) {
      return ServerResponse.fromJson(jsonDecode(response.body));
    } else {
      return ServerResponse.fromJson(jsonDecode(response.body));
    }
  }

  @override
  Future<ExecutionReport> execute(IProject project,
      {List<String> additionalArguments = const []}) async {
    String input = await File(additionalArguments[0]).readAsString();

    ServerResponse response = await remoteCompile(input);
    await writeOutput(response.content, project.getRootNode().getPath());
    ExecutionReport report = () => true;

    return Future.value(report);
  }
}
