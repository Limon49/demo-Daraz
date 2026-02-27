import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/dependency_injection.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/product_provider.dart';
import 'state/app_provider.dart';
import 'screens/login_screen.dart';

void main() {
  DependencyInjection.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(DependencyInjection.authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(DependencyInjection.productRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => AppProvider(
            authProvider: context.read<AuthProvider>(),
            productProvider: context.read<ProductProvider>(),
          ),
        ),
      ],
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
