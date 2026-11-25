import 'package:flutter/material.dart';

import '../data/pontos_coleta.dart';
import '../models/descarte.dart';
import '../models/ponto_coleta.dart';

class TelaPontos extends StatefulWidget {
  const TelaPontos({super.key});

  @override
  State<TelaPontos> createState() => _TelaPontosState();
}

class _TelaPontosState extends State<TelaPontos> {
  MaterialDescarte? _materialSelecionado;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final pontosVisiveis = _materialSelecionado == null
        ? pontosColeta
        : pontosColeta
              .where(
                (ponto) => ponto.materiais.containsKey(_materialSelecionado),
              )
              .toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          primary: false,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
          children: [
            Text(
              'Pontos de coleta',
              style: tema.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: cores.primary,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Vitória da Conquista · BA',
                    style: tema.textTheme.bodyLarge?.copyWith(
                      color: cores.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _filtro(null, cores),
                for (final material in MaterialDescarte.values)
                  _filtro(material, cores),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              pontosVisiveis.length == 1
                  ? '1 ponto de coleta'
                  : '${pontosVisiveis.length} pontos de coleta',
              style: tema.textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            if (pontosVisiveis.isEmpty)
              const Text('Nenhum ponto listado para este material.')
            else
              for (final ponto in pontosVisiveis) _CartaoPonto(ponto: ponto),
          ],
        ),
      ),
    );
  }

  ChoiceChip _filtro(MaterialDescarte? material, ColorScheme cores) {
    final selecionado = _materialSelecionado == material;
    return ChoiceChip(
      label: Text(material?.nome ?? 'Todos'),
      selected: selecionado,
      showCheckmark: false,
      selectedColor: cores.primary,
      labelStyle: TextStyle(
        color: selecionado ? cores.onPrimary : cores.onSurface,
      ),
      shape: const StadiumBorder(),
      onSelected: (marcado) {
        setState(() => _materialSelecionado = marcado ? material : null);
      },
    );
  }
}

class _CartaoPonto extends StatelessWidget {
  const _CartaoPonto({required this.ponto});

  final PontoColeta ponto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final referencia = ponto.referencia;
    final estiloDetalhes = tema.textTheme.bodyMedium?.copyWith(
      color: cores.onSurfaceVariant,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cores.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: cores.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ponto.nome,
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: cores.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    referencia == null
                        ? ponto.endereco
                        : '${ponto.endereco}\n$referencia',
                    style: estiloDetalhes,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(ponto.horario, style: estiloDetalhes),
            const SizedBox(height: 10),
            if (ponto.materiais.isEmpty)
              Text(
                'Consulte o local sobre os materiais aceitos.',
                style: estiloDetalhes,
              )
            else
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final material in ponto.materiais.values)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cores.outlineVariant),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        child: Text(
                          material,
                          style: tema.textTheme.labelMedium,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
