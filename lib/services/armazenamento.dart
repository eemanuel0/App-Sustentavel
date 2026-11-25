import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/descarte.dart';

class Armazenamento {
  static const _chaveDescartes = 'descartes';

  Future<List<Descarte>> carregar() async {
    final preferencias = await SharedPreferences.getInstance();
    await preferencias.reload();
    final texto = preferencias.getString(_chaveDescartes);

    // Na primeira abertura ainda não existe uma lista salva.
    if (texto == null) return [];

    final registros = jsonDecode(texto) as List<Object?>;
    return [
      for (final registro in registros)
        Descarte.deJson(registro as Map<String, Object?>),
    ];
  }

  Future<void> salvar(List<Descarte> descartes) async {
    final preferencias = await SharedPreferences.getInstance();

    // Guardamos a lista inteira como texto JSON, com as datas de cada descarte.
    final texto = jsonEncode([
      for (final descarte in descartes) descarte.paraJson(),
    ]);
    final gravou = await preferencias.setString(_chaveDescartes, texto);
    if (!gravou) {
      throw StateError('Não foi possível gravar os descartes.');
    }
  }
}
