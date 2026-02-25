// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_provider.dart';
import 'screens/login_screen.dart';
import 'debug_network_test.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const DarazApp(),
    ),
  );
}

class DarazApp extends StatelessWidget {
  const DarazApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daraz Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE2231A)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}