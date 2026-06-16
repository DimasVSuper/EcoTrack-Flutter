import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/transport/providers/transport_provider.dart';
import 'features/electricity/providers/electricity_provider.dart';
import 'features/auth/views/login_view.dart';
import 'features/main_view.dart';

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
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32), // EcoTrack green primary color
            primary: const Color(0xFF2E7D32),
            secondary: const Color(0xFF1B5E20),
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
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
              ),
            ),
          );
        }
        
        return Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return auth.token != null 
                ? const MainView() 
                : const LoginView();
          },
        );
      },
    );
  }
}
