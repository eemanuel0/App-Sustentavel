import 'package:flutter/material.dart';

import 'screens/tela_inicio.dart';

void main() {
  runApp(const EcoDescarte());
}

class EcoDescarte extends StatelessWidget {
  const EcoDescarte({super.key});

  @override
  Widget build(BuildContext context) {
    final cores =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF9BE05B),
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFF9BE05B),
          onPrimary: const Color(0xFF122509),
          surface: const Color(0xFF0C100E),
          surfaceContainer: const Color(0xFF171C19),
          outlineVariant: const Color(0xFF343E36),
        );

    return MaterialApp(
      title: 'EcoDescarte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: cores),
      home: const TelaInicio(),
    );
  }
}
