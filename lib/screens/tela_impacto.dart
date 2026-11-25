import 'package:flutter/material.dart';

import '../models/descarte.dart';
import '../models/meta_semanal.dart';

class TelaImpacto extends StatelessWidget {
  const TelaImpacto({
    super.key,
    required this.descartes,
    required this.carregando,
    required this.erroAoCarregar,
    required this.aoRecarregar,
  });

  final List<Descarte> descartes;
  final bool carregando;
  final bool erroAoCarregar;
  final VoidCallback aoRecarregar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final meta = MetaSemanal.calcular(descartes, DateTime.now());

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          primary: false,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
          children: [
            Text(
              'Seu impacto',
              style: tema.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Meta semanal · ${_diaEMes(meta.inicio)} a ${_diaEMes(meta.fim)}',
              style: tema.textTheme.bodyLarge?.copyWith(
                color: cores.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            if (carregando)
              const Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Carregando descartes',
                ),
              )
            else if (erroAoCarregar)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Não foi possível carregar seus descartes.'),
                  TextButton(
                    onPressed: aoRecarregar,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              )
            else
              _CartaoProgresso(meta: meta),
          ],
        ),
      ),
    );
  }

  String _diaEMes(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes';
  }
}

class _CartaoProgresso extends StatelessWidget {
  const _CartaoProgresso({required this.meta});

  final MetaSemanal meta;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final progresso = '${meta.entregas} de ${MetaSemanal.objetivo} entregas';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cores.secondary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cores.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.eco_outlined, color: cores.primary),
            const SizedBox(height: 12),
            Text(
              '${meta.entregas}',
              style: tema.textTheme.displayMedium?.copyWith(
                color: cores.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Entregas registradas', style: tema.textTheme.titleMedium),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: meta.progresso,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: cores.outlineVariant,
              semanticsLabel: 'Progresso da meta semanal',
            ),
            const SizedBox(height: 10),
            Text(progresso, style: tema.textTheme.labelLarge),
            if (meta.entregas >= MetaSemanal.objetivo) ...[
              const SizedBox(height: 8),
              Text('Meta atingida!', style: TextStyle(color: cores.primary)),
            ],
            const SizedBox(height: 12),
            Text(
              'Cada descarte marcado como entregue nesta semana conta uma vez.',
              style: tema.textTheme.bodyMedium?.copyWith(
                color: cores.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
