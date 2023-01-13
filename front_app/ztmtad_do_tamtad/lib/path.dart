class Path {
  Path({
    required this.segments,
    required this.totalMinutesLenght,
    required this.arrivalTime,
  });

  final List<PathSegment> segments;
  final int totalMinutesLenght;
  final DateTime arrivalTime;
}

class PathSegment {
  PathSegment({
    required this.route,
    required this.departureTime,
    required this.minutesLength,
    required this.routeType,
    required this.stopDesc,
  });

  final String route;
  final DateTime departureTime;
  final int minutesLength;
  final RouteTypes routeType;
  final String stopDesc;
}

enum RouteTypes {
  bus,
  tram,
  ferry,
  train,
}

RouteTypes routeTypeFromString(String str) {
  switch (str) {
    case "BUS":
      return RouteTypes.bus;
    case "TRAM":
      return RouteTypes.tram;
    case "FERRY":
      return RouteTypes.ferry;
    case "TRAIN":
      return RouteTypes.train;
    default:
      return RouteTypes.tram;
  }
}
