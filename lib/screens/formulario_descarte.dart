import 'package:flutter/material.dart';

import '../models/descarte.dart';

class FormularioDescarte extends StatefulWidget {
  const FormularioDescarte({super.key, this.materialInicial});

  final MaterialDescarte? materialInicial;

  @override
  State<FormularioDescarte> createState() => _FormularioDescarteState();
}

class _FormularioDescarteState extends State<FormularioDescarte> {
  final _formulario = GlobalKey<FormState>();
  late String _nome;
  late int _quantidade;
  MaterialDescarte? _material;

  @override
  void initState() {
    super.initState();
    _material = widget.materialInicial;
  }

  void _salvar() {
    final formulario = _formulario.currentState!;
    if (!formulario.validate()) return;

    formulario.save();
    final agora = DateTime.now();

    // O Início recebe o descarte pronto quando o formulário fecha.
    Navigator.pop(
      context,
      Descarte(
        id: agora.microsecondsSinceEpoch.toString(),
        nome: _nome,
        material: _material!,
        quantidade: _quantidade,
        dataCadastro: agora,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Form(
            key: _formulario,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Adicionar descarte', style: tema.textTheme.titleLarge),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nome do descarte',
                    hintText: 'Ex.: Garrafas PET',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  validator: (texto) => (texto?.trim().isEmpty ?? true)
                      ? 'Informe o nome do descarte.'
                      : null,
                  onSaved: (texto) => _nome = texto!.trim(),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<MaterialDescarte>(
                  initialValue: _material,
                  isExpanded: true,
                  dropdownColor: tema.colorScheme.surfaceContainer,
                  decoration: const InputDecoration(labelText: 'Material'),
                  items: [
                    for (final material in MaterialDescarte.values)
                      DropdownMenuItem(
                        value: material,
                        child: Text(material.nome),
                      ),
                  ],
                  onChanged: (material) => _material = material,
                  validator: (material) =>
                      material == null ? 'Escolha um material.' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Quantidade (unidades)',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (texto) {
                    final quantidade = int.tryParse(
                      texto?.trim() ?? '',
                      radix: 10,
                    );
                    if (quantidade == null || quantidade < 1) {
                      return 'Informe um número inteiro maior que zero.';
                    }
                    return null;
                  },
                  onSaved: (texto) =>
                      _quantidade = int.parse(texto!.trim(), radix: 10),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _salvar,
                  child: const Text('Salvar descarte'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
