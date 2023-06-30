import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/starter/starter_page.dart';
import 'themes/theme_switcher.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeSwitcher(),
      child: const MyApp(),
    ),
  );
}

// ROOT
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ping',
      theme: Provider.of<ThemeSwitcher>(context).currentTheme,
      home: const StarterPage(),
    );
  }
}
