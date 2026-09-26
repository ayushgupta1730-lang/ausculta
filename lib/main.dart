import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ThemeController.instance.initialize();

  runApp(const AuscultaApp());
}

class AuscultaApp extends StatelessWidget {
  const AuscultaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.instance;

    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Ausculta',
          debugShowCheckedModeBanner: false,

          theme: themeController.themeData,

          home: const HomeScreen(),
        );
      },
    );
  }
}