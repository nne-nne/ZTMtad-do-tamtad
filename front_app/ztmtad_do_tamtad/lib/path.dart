class Path {
  Path({
    required this.segments,
    required this.totalMinutesLenght,
  });

  final List<PathSegment> segments;
  final int totalMinutesLenght;
}

class PathSegment {
  PathSegment({
    required this.route,
    required this.departureTime,
    required this.minutesLength,
    required this.routeType,
  });

  final String route;
  final DateTime departureTime;
  final int minutesLength;
  final RouteTypes routeType;
}

enum RouteTypes {
  bus,
  tram,
  ferry,
  train,
}
