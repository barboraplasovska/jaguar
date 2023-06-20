enum AspectType {
  maven,
  tigrou,
}

abstract class IAspect {
  AspectType getType();

}