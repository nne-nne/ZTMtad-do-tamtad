import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ztmtad_do_tamtad/stop.dart';
import 'package:ztmtad_do_tamtad/path.dart';
import 'package:ztmtad_do_tamtad/webservice.dart';

class ZTMRepository extends ChangeNotifier {
  String? stopsResponse;
  String? homeResponse;
  List<Stop> stops = [];
  List<Path> paths = [];

  Future<void> getStops() async {
    stopsResponse = await WebService.stopsRequest();
    var stopsJson = jsonDecode(stopsResponse!);
    var todaysStops = stopsJson['2023-01-13']['stops'];
    for (Map<String, dynamic> stop in todaysStops) {
      stops.add(
        Stop(
          stopId: stop['stopId'],
          stopName: stop['stopName'],
          stopDesc: stop['stopDesc'],
          nonpassenger: stop['nonpassenger'],
        ),
      );
    }

    notifyListeners();
  }

  Future<void> getHome() async {
    homeResponse = await WebService.homeRequest();
    notifyListeners();
  }

  void clearPaths() {
    paths = [];
  }

  Future<void> collectPaths(String stop1, String stop2) async {
    var response = await WebService.pathsRequest(stop1, stop2);
    var jsonResponse = jsonDecode(response);
    for (dynamic path in jsonResponse) {
      List<PathSegment> segments = [];
      for (dynamic pathSegment in path['path_segments'][0]) {
        segments.add(
          PathSegment(
            route: pathSegment['route'][0],
            routeType: routeTypeFromString(pathSegment['routeType'][0]),
            minutesLength: pathSegment['minutes'][0],
            departureTime: DateTime.parse(pathSegment['departureTime'][0]),
            stopDesc: pathSegment['stop_desc'][0],
          ),
        );
      }
      paths.add(
        Path(
          totalMinutesLenght: path['total_time'][0],
          segments: segments,
          arrivalTime: DateTime.parse(path['arrival_time'][0]),
        ),
      );
    }
    notifyListeners();
  }

  // Future<void> getExamplePaths() async {
  //   //await WebService.pathsRequest();
  //   paths = [
  //     Path(
  //       segments: [
  //         PathSegment(
  //             route: "6",
  //             routeType: RouteTypes.tram,
  //             departureTime: DateTime.now(),
  //             minutesLength: 12),
  //       ],
  //       totalMinutesLenght: 12,
  //     ),
  //     Path(
  //       segments: [
  //         PathSegment(
  //             route: "6",
  //             routeType: RouteTypes.tram,
  //             departureTime: DateTime.now(),
  //             minutesLength: 12),
  //         PathSegment(
  //             route: "154",
  //             routeType: RouteTypes.bus,
  //             departureTime: DateTime.now(),
  //             minutesLength: 23),
  //       ],
  //       totalMinutesLenght: 37,
  //     ),
  //     Path(
  //       segments: [
  //         PathSegment(
  //             route: "6",
  //             routeType: RouteTypes.tram,
  //             departureTime: DateTime.now(),
  //             minutesLength: 12),
  //         PathSegment(
  //             route: "154",
  //             routeType: RouteTypes.bus,
  //             departureTime: DateTime.now(),
  //             minutesLength: 23),
  //         PathSegment(
  //             route: "6",
  //             routeType: RouteTypes.tram,
  //             departureTime: DateTime.now(),
  //             minutesLength: 12),
  //         PathSegment(
  //             route: "154",
  //             routeType: RouteTypes.bus,
  //             departureTime: DateTime.now(),
  //             minutesLength: 23),
  //       ],
  //       totalMinutesLenght: 74,
  //     ),
  //   ];
  //   notifyListeners();
  // }
}
