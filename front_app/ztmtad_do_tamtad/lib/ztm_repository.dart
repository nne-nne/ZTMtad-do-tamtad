import 'package:flutter/material.dart';
import 'package:ztmtad_do_tamtad/webservice.dart';

class ZTMRepository extends ChangeNotifier {
  String? stopsResponse;
  String? homeResponse;

  Future<void> getStops() async {
    stopsResponse = await WebService.stopsRequest();
    notifyListeners();
  }

  Future<void> getHome() async {
    homeResponse = await WebService.homeRequest();
    notifyListeners();
  }
}
