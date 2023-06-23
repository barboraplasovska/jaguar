import 'package:pingfrontend/backend/domains/entity/feature/feature.dart';

enum AspectType {
  maven,
  tigrou,
}

abstract class IAspect {
  AspectType getType();
  List<Feature> getFeatures();
}
