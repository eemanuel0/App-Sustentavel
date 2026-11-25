import 'package:ecodescarte/models/descarte.dart';
import 'package:ecodescarte/models/meta_semanal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Conta registros de segunda a domingo pelo calendário local', () {
    final hoje = DateTime(2026, 12, 2);
    const quantidadeDeUnidades = 12;

    Descarte descarte(DateTime? conclusao) {
      return Descarte(
        id: conclusao.toString(),
        nome: 'Latinhas',
        material: MaterialDescarte.metal,
        quantidade: quantidadeDeUnidades,
        dataCadastro: DateTime(2026, 11, 27),
        dataConclusao: conclusao?.toUtc(),
      );
    }

    final meta = MetaSemanal.calcular([
      descarte(null),
      descarte(DateTime(2026, 11, 29, 23, 59)),
      descarte(DateTime(2026, 11, 30)),
      descarte(DateTime(2026, 12, 6, 23, 59)),
      descarte(DateTime(2026, 12, 7)),
    ], hoje);

    expect(meta.inicio, DateTime(2026, 11, 30));
    expect(meta.fim, DateTime(2026, 12, 6));
    expect(meta.entregas, 2);
    expect(meta.progresso, 0.4);

    final metaSuperada = MetaSemanal.calcular([
      for (var hora = 0; hora < 6; hora++)
        descarte(DateTime(2026, 12, 1, hora)),
    ], hoje);
    expect(metaSuperada.entregas, 6);
    expect(metaSuperada.progresso, 1.0);
  });
}
