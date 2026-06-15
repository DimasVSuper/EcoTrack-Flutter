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
      usageKwh: _toDouble(json['usage_kwh']),
      periodMonth: json['period_month'],
      emissionKg: _toDouble(json['emission_kg']),
      recordDate: json['record_date'],
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
