import 'package:flutter/material.dart';

import 'tela_inicio.dart';
import 'tela_pontos.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _abaSelecionada = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _abaSelecionada == 0,
      onPopInvokedWithResult: (voltou, _) {
        if (!voltou && _abaSelecionada != 0) {
          setState(() => _abaSelecionada = 0);
        }
      },
      child: Scaffold(
        body: SafeArea(
          // Ao trocar de aba, o filtro e a lista do Início continuam na memória.
          child: IndexedStack(
            index: _abaSelecionada,
            children: const [TelaInicio(), TelaPontos()],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _abaSelecionada,
          onDestinationSelected: (aba) => setState(() => _abaSelecionada = aba),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Icon(Icons.location_on_outlined),
              selectedIcon: Icon(Icons.location_on),
              label: 'Pontos',
            ),
          ],
        ),
      ),
    );
  }
}
