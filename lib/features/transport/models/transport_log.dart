class TransportLog {
  final int id;
  final int transportTypeId;
  final double distanceKm;
  final double emissionKg;
  final String activityDate;
  final String transportTypeName;

  TransportLog({
    required this.id,
    required this.transportTypeId,
    required this.distanceKm,
    required this.emissionKg,
    required this.activityDate,
    required this.transportTypeName,
  });

  factory TransportLog.fromJson(Map<String, dynamic> json) {
    return TransportLog(
      id: json['id'],
      transportTypeId: json['transport_type_id'],
      distanceKm: _toDouble(json['distance_km']),
      emissionKg: _toDouble(json['emission_kg']),
      activityDate: json['activity_date'],
      transportTypeName: json['transport_type'] != null ? json['transport_type']['name'] : 'Unknown',
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
