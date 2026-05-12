import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const TerriConnect());
}

class TerriConnect extends StatelessWidget {
  const TerriConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TerriConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}