class Stop {
  Stop({
    required this.stopId,
    this.stopCode,
    this.stopName,
    this.stopShortName,
    this.stopDesc,
    this.subName,
    this.date,
    this.zoneId,
    this.zoneName,
    this.virtual,
    this.nonpassenger,
    this.depot,
    this.ticketZoneBorder,
    this.onDemand,
    this.activationDate,
    this.stopLat,
    this.stopLon,
    this.stopUrl,
    this.locationType,
    this.parentStation,
    this.stopTimezone,
    this.wheelchairBoarding,
  });

  final int stopId;
  final String? stopCode;
  final String? stopName;
  final String? stopShortName;
  final String? stopDesc;
  final String? subName;
  final String? date;
  final int? zoneId;
  final String? zoneName;
  final int? virtual;
  final int? nonpassenger;
  final int? depot;
  final int? ticketZoneBorder;
  final int? onDemand;
  final String? activationDate;
  final double? stopLat;
  final double? stopLon;
  final String? stopUrl;
  final String? locationType;
  final String? parentStation;
  final String? stopTimezone;
  final int? wheelchairBoarding;
}
