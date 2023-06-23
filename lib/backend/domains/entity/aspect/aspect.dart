import 'package:pingfrontend/backend/domains/entity/aspect_interface.dart';
import 'package:pingfrontend/backend/domains/entity/feature/feature.dart';

class Aspect implements IAspect {
  late AspectType type;
  late List<Feature> features;

  static final List<Feature> mavenFeatures = [
    MavenFeature.clean,
    MavenFeature.compile,
    MavenFeature.exec,
    MavenFeature.install,
    MavenFeature.package,
    MavenFeature.test,
    MavenFeature.tree,
  ];

  static final List<Feature> tigrouFeatures = [
    TigerFeature.compile,
    TigerFeature.exec,
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
