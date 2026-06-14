import 'package:flutter/material.dart';

class TreeEquivalencyCard extends StatelessWidget {
  final double totalEmissionKg;

  const TreeEquivalencyCard({
    super.key,
    required this.totalEmissionKg,
  });

  static const double _monthlyAbsorptionPerTreeKg = 1.83;

  Widget _miniChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF047857),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final treeEquivalent = totalEmissionKg / _monthlyAbsorptionPerTreeKg;
    final roundedTrees = treeEquivalent.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.park, color: Color(0xFF10B981), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dampak Terhadap Alam',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Jejak karbon Anda bulan ini setara dengan beban kerja $roundedTrees pohon dewasa yang harus menyerap polusi Anda selama satu bulan penuh.',
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _miniChip(context, '🌱 Edukasi karbon'),
                    const SizedBox(width: 8),
                    _miniChip(context, '📉 Hitung client-side'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
