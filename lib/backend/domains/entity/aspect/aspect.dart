import 'package:pingfrontend/backend/domains/entity/aspect_interface.dart';
import 'package:pingfrontend/backend/domains/entity/feature/compiler/maven/clean_feature.dart';
import 'package:pingfrontend/backend/domains/entity/feature/compiler/maven/compile_feature.dart';
import 'package:pingfrontend/backend/domains/entity/feature/compiler/maven/exec_feature.dart';
import 'package:pingfrontend/backend/domains/entity/feature/compiler/maven/install_feature.dart';
import 'package:pingfrontend/backend/domains/entity/feature/compiler/maven/package_feature.dart';
import 'package:pingfrontend/backend/domains/entity/feature/compiler/maven/test_feature.dart';
import 'package:pingfrontend/backend/domains/entity/feature/compiler/maven/tree_feature.dart';
import 'package:pingfrontend/backend/domains/entity/feature/compiler/tigrou/tigrou_compile_feature.dart';
import 'package:pingfrontend/backend/domains/entity/feature/compiler/tigrou/tigrou_execute_feature.dart';
import 'package:pingfrontend/backend/domains/entity/feature/feature.dart';

class Aspect implements IAspect {
  late AspectType type;
  late List<Feature> features;

  static final List<Feature> mavenFeatures = [
    CleanFeature(),
    CompileFeature(),
    ExecFeature(),
    InstallFeature(),
    PackageFeature(),
    TestFeature(),
    TreeFeature(),
  ];

  static final List<Feature> tigrouFeatures = [
    TigrouCompile(),
    TigrouExecute(),
  ];

  Aspect(this.type) {
    switch (type) {
      case AspectType.maven:
        features = mavenFeatures;
        break;
      case AspectType.tigrou:
        features = tigrouFeatures;
        break;
    }
  }

  List<Feature> getFeatures() {
    return features;
  }

  @override
  AspectType getType() {
    return type;
  }
}
