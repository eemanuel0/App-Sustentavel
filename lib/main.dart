import 'package:flutter/material.dart';

import 'screens/tela_inicio.dart';

void main() {
  runApp(const EcoDescarteApp());
}

// As cores ficam juntas para o Início e o formulário usarem a mesma paleta.
class CoresApp {
  static const Color fundo = Color(0xFF0B100E);
  static const Color card = Color(0xFF171C19);
  static const Color verdePrincipal = Color(0xFFA8EB70);
  static const Color verdeEscuro = Color(0xFF172219);
  static const Color textoPrincipal = Color(0xFFF1F4F2);
  static const Color textoSecundario = Color(0xFFAAB5AE);
  static const Color borda = Color(0xFF303B34);
  static const Color erro = Color(0xFFE36268);
  static const Color navegacao = Color(0xFF101512);
}

class EcoDescarteApp extends StatelessWidget {
  const EcoDescarteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cores =
        ColorScheme.fromSeed(
          seedColor: CoresApp.verdePrincipal,
          brightness: Brightness.dark,
        ).copyWith(
          primary: CoresApp.verdePrincipal,
          onPrimary: CoresApp.fundo,
          secondary: CoresApp.verdeEscuro,
          onSecondary: CoresApp.textoPrincipal,
          surface: CoresApp.fundo,
          surfaceContainer: CoresApp.card,
          onSurface: CoresApp.textoPrincipal,
          onSurfaceVariant: CoresApp.textoSecundario,
          outline: CoresApp.borda,
          outlineVariant: CoresApp.borda,
          error: CoresApp.erro,
          onError: CoresApp.fundo,
        );
    final bordaCampo = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: CoresApp.borda),
    );

    return MaterialApp(
      title: 'EcoDescarte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: cores,
        appBarTheme: const AppBarThemeData(
          backgroundColor: CoresApp.fundo,
          foregroundColor: CoresApp.textoPrincipal,
          elevation: 0,
          centerTitle: false,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationThemeData(
          filled: true,
          fillColor: CoresApp.card,
          labelStyle: const TextStyle(color: CoresApp.textoSecundario),
          border: bordaCampo,
          enabledBorder: bordaCampo,
          focusedBorder: bordaCampo.copyWith(
            borderSide: const BorderSide(
              color: CoresApp.verdePrincipal,
              width: 2,
            ),
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: CoresApp.navegacao,
          indicatorColor: CoresApp.verdeEscuro,
          elevation: 0,
          height: 70,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: CoresApp.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
      ),
      home: const TelaInicio(),
    );
  }
}
