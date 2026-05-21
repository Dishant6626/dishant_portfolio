import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/constants/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Firebase using the generated options.
  // Run `flutterfire configure` to populate firebase_options.dart.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const DishantPortfolioApp());
}

class DishantPortfolioApp extends StatelessWidget {
  const DishantPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dishant Patel | Flutter & Android Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
      scrollBehavior: _PortfolioScrollBehavior(),
    );
  }
}

/// Enables smooth drag-scroll on web with mouse + trackpad.
class _PortfolioScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
