import 'package:pingfrontend/backend/domains/entity/project_interface.dart';

typedef ExecutionReport = bool Function();

enum MavenFeature implements FeatureType {
  clean,
  compile,
  exec,
  install,
  package,
  test,
  tree,
}

enum TigerFeature implements FeatureType {
  compile,
  exec,
}

abstract class FeatureType {}

abstract class Feature {

  late FeatureType type;

  FeatureType getType() {
    return type;
  }

  ExecutionReport execute(IProject project, Object params) {
    return () => false;
  }

}