class ElectricityLog {
  final int id;
  final double usageKwh;
  final String periodMonth;
  final double emissionKg;
  final String recordDate;

  ElectricityLog({
    required this.id,
    required this.usageKwh,
    required this.periodMonth,
    required this.emissionKg,
    required this.recordDate,
  });

  factory ElectricityLog.fromJson(Map<String, dynamic> json) {
    return ElectricityLog(
      id: json['id'],
      usageKwh: (json['usage_kwh'] ?? 0).toDouble(),
      periodMonth: json['period_month'],
      emissionKg: (json['emission_kg'] ?? 0).toDouble(),
      recordDate: json['record_date'],
    );
  }
}
