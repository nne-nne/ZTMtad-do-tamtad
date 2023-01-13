import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ztmtad_do_tamtad/stop.dart';
import 'package:ztmtad_do_tamtad/webservice.dart';

class ZTMRepository extends ChangeNotifier {
  String? stopsResponse;
  String? homeResponse;
  List<Stop> stops = [];

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
}
