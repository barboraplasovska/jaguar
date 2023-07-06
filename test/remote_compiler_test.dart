import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jaguar/backend/domains/entity/feature/compiler/tigrou/tigrou_compile_feature.dart';
import 'package:jaguar/backend/domains/entity/feature/compiler/tigrou/tigrou_remote.dart';

void main() {
  group('Remote Tiger Compiler', () {
    test('Hello World', () async {
      String input = await File('test/tiger_input/hello.tig').readAsString();

      TigrouRemote tigrouRemote = TigrouRemote();

      var response = await tigrouRemote.remoteCompile(input);
      expect(response.content, equals("Hello World\n"));
    });

    test('If', () async {
      String input = await File('test/tiger_input/if.tig').readAsString();

      TigrouRemote tigrouRemote = TigrouRemote();

      var response = await tigrouRemote.remoteCompile(input);
      expect(response.content, equals("40"));
    });

    test('Fact', () async {
      String input = await File('test/tiger_input/fact.tig').readAsString();

      TigrouRemote tigrouRemote = TigrouRemote();

      var response = await tigrouRemote.remoteCompile(input);
      expect(response.content, equals("3628800\n"));
    });

    test('Record', () async {
      String input = await File('test/tiger_input/record.tig').readAsString();

      TigrouRemote tigrouRemote = TigrouRemote();

      var response = await tigrouRemote.remoteCompile(input);
      expect(response.content, equals("Somebody\n1000"));
    });
  });
}
