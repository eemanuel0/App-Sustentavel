import 'package:flutter/material.dart';

import '../models/descarte.dart';
import '../services/armazenamento.dart';
import 'tela_impacto.dart';
import 'tela_inicio.dart';
import 'tela_pontos.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _abaSelecionada = 0;
  late final AppLifecycleListener _cicloDoApp;
  // Início e Impacto usam a mesma lista já carregada do aparelho.
  final _armazenamento = Armazenamento();
  List<Descarte> _descartes = [];
  bool _carregando = true;
  bool _erroAoCarregar = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    // Ao voltar para o app, a semana pode ter mudado.
    _cicloDoApp = AppLifecycleListener(onResume: () => setState(() {}));
    // Buscamos os descartes salvos assim que o app abre.
    _carregarDescartes();
  }

  @override
  void dispose() {
    _cicloDoApp.dispose();
    super.dispose();
  }

  Future<void> _carregarDescartes() async {
    setState(() {
      _carregando = true;
      _erroAoCarregar = false;
    });

    try {
      final descartes = await _armazenamento.carregar();
      if (!mounted) return;

      setState(() => _descartes = descartes);
    } catch (_) {
      if (!mounted) return;
      setState(() => _erroAoCarregar = true);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<bool> _salvarDescartes(List<Descarte> descartes) async {
    if (_carregando || _erroAoCarregar || _salvando) return false;

    // Esperamos uma gravação terminar antes de aceitar outra.
    setState(() => _salvando = true);
    try {
      await _armazenamento.salvar(descartes);
      if (!mounted) return false;

      // A tela só mostra a mudança depois que a lista é salva.
      setState(() => _descartes = descartes);
      return true;
    } catch (_) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível salvar a alteração. Tente novamente.',
          ),
        ),
      );
      return false;
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

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
            children: [
              TelaInicio(
                descartes: _descartes,
                carregando: _carregando,
                erroAoCarregar: _erroAoCarregar,
                salvando: _salvando,
                aoRecarregar: _carregarDescartes,
                aoSalvar: _salvarDescartes,
              ),
              const TelaPontos(),
              TelaImpacto(
                descartes: _descartes,
                carregando: _carregando,
                erroAoCarregar: _erroAoCarregar,
                aoRecarregar: _carregarDescartes,
              ),
            ],
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
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights),
              label: 'Impacto',
            ),
          ],
        ),
      ),
    );
  }
}
