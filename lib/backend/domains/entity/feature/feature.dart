import 'package:jaguar/backend/domains/entity/project_interface.dart';

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
  remote,
}

abstract class FeatureType {}

abstract class Feature {
  late final FeatureType _type;

  FeatureType getType() {
    return _type;
  }

  Feature(this._type);

  Future<ExecutionReport> execute(IProject project,
      {List<String> additionalArguments = const []});
}
