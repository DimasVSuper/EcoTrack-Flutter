import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<AuthProvider>(context, listen: false).fetchUserProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final String name = authProvider.userName ?? 'Loading...';
    final String email = authProvider.userEmail ?? 'Loading...';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF0F172A)),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF0F172A)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur Pengaturan belum tersedia.')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Card Details
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    // Circle Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Color(0xFF2E7D32),
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Akun Group Title
              const Padding(
                padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                child: Text(
                  'Akun',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Akun Group Menu
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Ubah Profil',
                      onTap: () => _showComingSoon('Ubah Profil'),
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Ganti Password',
                      onTap: () => _showComingSoon('Ganti Password'),
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Pengaturan Notifikasi',
                      onTap: () => _showComingSoon('Pengaturan Notifikasi'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Aplikasi Group Title
              const Padding(
                padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                child: Text(
                  'Aplikasi',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Aplikasi Group Menu
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.info_outline_rounded,
                      title: 'Tentang EcoTrack',
                      onTap: () => _showComingSoon('Tentang EcoTrack'),
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Bantuan',
                      onTap: () => _showComingSoon('Bantuan'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Logout Button
              OutlinedButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Keluar Aplikasi'),
                      content: const Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Batal'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                          child: const Text('Keluar'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await authProvider.logout();
                  }
                },
                icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFF1F5F9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF475569), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
      onTap: onTap,
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Fitur $feature belum tersedia.')),
    );
  }
}
