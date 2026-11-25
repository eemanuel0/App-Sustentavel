import 'package:flutter/material.dart';

import '../models/descarte.dart';
import '../services/armazenamento.dart';
import 'formulario_descarte.dart';

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  final _armazenamento = Armazenamento();
  List<Descarte> _descartes = [];
  MaterialDescarte? _materialSelecionado;
  bool _carregando = true;
  bool _erroAoCarregar = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _carregarDescartes();
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

    // Uma alteração por vez evita que uma gravação antiga substitua a última.
    setState(() => _salvando = true);
    try {
      await _armazenamento.salvar(descartes);
      if (!mounted) return false;

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

    final salvou = await _salvarDescartes([descarte, ..._descartes]);
    // Se o filtro escondesse o novo registro, voltamos para todos os materiais.
    if (mounted && salvou && _materialSelecionado != descarte.material) {
      setState(() => _materialSelecionado = null);
    }
  }

  Future<void> _alternarConclusao(Descarte descarte) async {
    final indice = _descartes.indexOf(descarte);
    if (indice == -1) return;

    final descartes = [..._descartes];
    descartes[indice] = descarte.alternarConclusao(DateTime.now());
    await _salvarDescartes(descartes);
  }

  Future<void> _removerDescarte(Descarte descarte) async {
    final descartes = [..._descartes]..remove(descarte);
    await _salvarDescartes(descartes);
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    final podeEditar = !_carregando && !_erroAoCarregar && !_salvando;
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

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          primary: false,
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
                      const DropdownMenuItem(child: Text('Todos os materiais')),
                      for (final material in MaterialDescarte.values)
                        DropdownMenuItem(
                          value: material,
                          child: Text(material.nome),
                        ),
                    ],
                    onChanged: _carregando || _erroAoCarregar
                        ? null
                        : (material) {
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
                    if (!_carregando && !_erroAoCarregar)
                      Text(
                        _salvando ? 'Salvando alterações…' : textoPendentes,
                        style: textos.labelLarge?.copyWith(
                          color: cores.primary,
                        ),
                      ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: podeEditar ? _adicionarDescarte : null,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_carregando)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: 'Carregando descartes',
                  ),
                ),
              )
            else if (_erroAoCarregar)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Não foi possível carregar seus descartes.'),
                  TextButton(
                    onPressed: _carregarDescartes,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              )
            else if (descartesVisiveis.isEmpty)
              Card(
                margin: EdgeInsets.zero,
                color: cores.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Icon(Icons.inventory_2_outlined, color: cores.primary),
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
                  aoAlternarConclusao: podeEditar
                      ? () => _alternarConclusao(descarte)
                      : null,
                  aoRemover: podeEditar
                      ? () => _removerDescarte(descarte)
                      : null,
                ),
          ],
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
  final VoidCallback? aoAlternarConclusao;
  final VoidCallback? aoRemover;

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
                onPressed: aoRemover == null ? null : controlador.open,
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
