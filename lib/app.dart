import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/transport_provider.dart';
import 'providers/electricity_provider.dart';
import 'views/auth/login_view.dart';
import 'views/dashboard/dashboard_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),  
        ChangeNotifierProvider(create: (_) => TransportProvider()),  
        ChangeNotifierProvider(create: (_) => ElectricityProvider()),  
      ],
      child: MaterialApp(
        title: 'EcoTrack',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF10B981), // Emerald green primary color
            primary: const Color(0xFF10B981),
            secondary: const Color(0xFF059669),
          ),
          useMaterial3: true,
          fontFamily: 'FiraSans', // As specified in UI_UX.md
        ),
        home: const AuthCheck(),
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder<bool>(
      future: authProvider.tryAutoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
              ),
            ),
          );
        }
        
        return Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return auth.token != null 
                ? const DashboardView() 
                : const LoginView();
          },
        );
      },
    );
  }
}
