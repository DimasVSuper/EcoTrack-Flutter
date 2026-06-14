class TransportType {
  final int id;
  final String name;
  final double emissionFactorPerKm;

  TransportType({
    required this.id,
    required this.name,
    required this.emissionFactorPerKm,
  });

  factory TransportType.fromJson(Map<String, dynamic> json) {
    return TransportType(
      id: json['id'],
      name: json['name'],
      emissionFactorPerKm: (json['emission_factor_per_km'] ?? 0).toDouble(),
    );
  }
}
