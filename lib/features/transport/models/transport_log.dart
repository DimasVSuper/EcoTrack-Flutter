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
      distanceKm: (json['distance_km'] ?? 0).toDouble(),
      emissionKg: (json['emission_kg'] ?? 0).toDouble(),
      activityDate: json['activity_date'],
      transportTypeName: json['transport_type'] != null ? json['transport_type']['name'] : 'Unknown',
    );
  }
}
