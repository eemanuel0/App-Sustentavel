import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/descarte.dart';

class Armazenamento {
  static const _chaveDescartes = 'descartes';

  Future<List<Descarte>> carregar() async {
    final preferencias = await SharedPreferences.getInstance();
    await preferencias.reload();
    final texto = preferencias.getString(_chaveDescartes);

    // Se ainda não houver uma lista salva, começamos com a lista vazia.
    if (texto == null) return [];

    // Lemos o texto salvo e montamos de novo cada descarte.
    final registros = jsonDecode(texto) as List<Object?>;
    return [
      for (final registro in registros)
        Descarte.deJson(registro as Map<String, Object?>),
    ];
  }

  Future<void> salvar(List<Descarte> descartes) async {
    final preferencias = await SharedPreferences.getInstance();

    // Salvamos a lista toda como texto JSON para manter os dados de cada item.
    final texto = jsonEncode([
      for (final descarte in descartes) descarte.paraJson(),
    ]);
    final gravou = await preferencias.setString(_chaveDescartes, texto);
    if (!gravou) {
      throw StateError('Não foi possível gravar os descartes.');
    }
  }
}
