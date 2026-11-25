import 'package:flutter/material.dart';

import '../models/descarte.dart';
import 'formulario_descarte.dart';

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  // A lista começa vazia porque cada pessoa registra o que separou.
  final List<Descarte> _descartes = [];
  MaterialDescarte? _materialSelecionado;

  Future<void> _adicionarDescarte() async {
    final descarte = await showModalBottomSheet<Descarte>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) =>
          FormularioDescarte(materialInicial: _materialSelecionado),
    );
    if (!mounted || descarte == null) return;

    setState(() {
      _descartes.insert(0, descarte);
      // Ao salvar outro material, mostramos o registro que acabou de entrar.
      if (_materialSelecionado != descarte.material) {
        _materialSelecionado = null;
      }
    });
  }

  void _alternarConclusao(Descarte descarte) {
    final indice = _descartes.indexOf(descarte);
    if (indice == -1) return;

    setState(() {
      _descartes[indice] = descarte.alternarConclusao(DateTime.now());
    });
  }

  void _removerDescarte(Descarte descarte) {
    setState(() => _descartes.remove(descarte));
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    final descartesVisiveis = _materialSelecionado == null
        ? _descartes
        : _descartes.where(
            (descarte) => descarte.material == _materialSelecionado,
          );
    final pendentes = _descartes
        .where((descarte) => !descarte.concluido)
        .length;
    final textoPendentes = pendentes == 1
        ? '1 pendente'
        : '$pendentes pendentes';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                const _Cabecalho(),
                const SizedBox(height: 22),
                const _BannerReciclagem(),
                const SizedBox(height: 22),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: cores.surfaceContainer,
                    border: Border.all(color: cores.outlineVariant),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<MaterialDescarte>(
                        value: _materialSelecionado,
                        hint: const Text('Todos os materiais'),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isExpanded: true,
                        dropdownColor: cores.surfaceContainer,
                        borderRadius: BorderRadius.circular(14),
                        items: [
                          const DropdownMenuItem(
                            child: Text('Todos os materiais'),
                          ),
                          for (final material in MaterialDescarte.values)
                            DropdownMenuItem(
                              value: material,
                              child: Text(material.nome),
                            ),
                        ],
                        onChanged: (material) {
                          setState(() => _materialSelecionado = material);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Minha lista',
                          style: textos.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          textoPendentes,
                          style: textos.labelLarge?.copyWith(
                            color: cores.primary,
                          ),
                        ),
                      ],
                    ),
                    FilledButton.icon(
                      onPressed: _adicionarDescarte,
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (descartesVisiveis.isEmpty)
                  Card(
                    margin: EdgeInsets.zero,
                    color: cores.surfaceContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            color: cores.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _descartes.isEmpty
                                  ? 'Nenhum descarte registrado. Adicione o que você já separou.'
                                  : 'Nenhum descarte deste material.',
                              style: textos.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  for (final descarte in descartesVisiveis)
                    _CartaoDescarte(
                      key: ValueKey(descarte.id),
                      descarte: descarte,
                      aoAlternarConclusao: () => _alternarConclusao(descarte),
                      aoRemover: () => _removerDescarte(descarte),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Cabecalho extends StatelessWidget {
  const _Cabecalho();

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(Icons.location_on_outlined, color: cores.primary, size: 28),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SUA JORNADA DE DESCARTE',
                style: textos.labelSmall?.copyWith(
                  color: cores.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'EcoDescarte · ODS 12',
                style: textos.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        ExcludeSemantics(
          child: CircleAvatar(
            radius: 20,
            backgroundColor: cores.primary.withValues(alpha: 0.10),
            foregroundColor: cores.primary,
            child: const Icon(Icons.eco_outlined, size: 20),
          ),
        ),
      ],
    );
  }
}

class _BannerReciclagem extends StatelessWidget {
  const _BannerReciclagem();

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 176),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cores.secondary, cores.surface],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá!',
                  style: textos.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Vamos fazer a diferença hoje?',
                  style: textos.titleMedium?.copyWith(
                    color: cores.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 54,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cores.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: ExcludeSemantics(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 138),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: cores.primary.withValues(alpha: 0.18),
                        ),
                        gradient: RadialGradient(
                          colors: [
                            cores.primary.withValues(alpha: 0.23),
                            cores.primary.withValues(alpha: 0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Center(
                        child: FractionallySizedBox(
                          widthFactor: 0.58,
                          heightFactor: 0.58,
                          child: FittedBox(
                            child: Icon(Icons.recycling, color: cores.primary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartaoDescarte extends StatelessWidget {
  const _CartaoDescarte({
    super.key,
    required this.descarte,
    required this.aoAlternarConclusao,
    required this.aoRemover,
  });

  final Descarte descarte;
  final VoidCallback aoAlternarConclusao;
  final VoidCallback aoRemover;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final (icone, cor) = switch (descarte.material) {
      MaterialDescarte.papel => (Icons.description_outlined, Colors.blue),
      MaterialDescarte.plastico => (
        Icons.local_drink_outlined,
        Colors.redAccent,
      ),
      MaterialDescarte.vidro => (Icons.wine_bar, Colors.tealAccent),
      MaterialDescarte.metal => (Icons.build_outlined, Colors.amber),
      MaterialDescarte.pilhas => (
        Icons.battery_charging_full,
        Colors.purpleAccent,
      ),
      MaterialDescarte.oleo => (Icons.water_drop_outlined, Colors.orangeAccent),
      MaterialDescarte.eletronicos => (Icons.devices, Colors.cyanAccent),
      MaterialDescarte.outros => (Icons.delete_outline, cores.onSurfaceVariant),
    };
    final data = descarte.dataCadastro.toLocal();
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return Card(
      color: cores.surfaceContainer,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cor.withValues(alpha: 0.12),
          foregroundColor: cor,
          child: Icon(icone),
        ),
        title: Text(
          descarte.nome,
          style: descarte.concluido
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text(
          '${descarte.material.nome} · ${descarte.quantidade} un · Reg. $dia/$mes',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: aoAlternarConclusao,
              tooltip: descarte.concluido
                  ? 'Voltar para pendente'
                  : 'Marcar como entregue',
              icon: Icon(
                descarte.concluido ? Icons.check_circle : Icons.circle_outlined,
                color: descarte.concluido
                    ? cores.primary
                    : cores.onSurfaceVariant,
              ),
            ),
            MenuAnchor(
              builder: (context, controlador, child) => IconButton(
                onPressed: controlador.open,
                tooltip: 'Opções do descarte',
                icon: const Icon(Icons.more_vert),
              ),
              menuChildren: [
                MenuItemButton(
                  onPressed: aoRemover,
                  leadingIcon: const Icon(Icons.delete_outline),
                  child: const Text('Remover'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
