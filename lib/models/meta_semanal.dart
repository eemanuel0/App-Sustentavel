import 'descarte.dart';

class MetaSemanal {
  const MetaSemanal._({
    required this.inicio,
    required this.fim,
    required this.entregas,
  });

  static const objetivo = 5;

  final DateTime inicio;
  final DateTime fim;
  final int entregas;

  double get progresso => (entregas / objetivo).clamp(0.0, 1.0);

  factory MetaSemanal.calcular(Iterable<Descarte> descartes, DateTime hoje) {
    final data = hoje.toLocal();
    // Usamos o calendário local para a semana ir de segunda até domingo.
    final segunda = DateTime(
      data.year,
      data.month,
      data.day - (data.weekday - DateTime.monday),
    );
    final domingo = DateTime(segunda.year, segunda.month, segunda.day + 6);
    final proximaSegunda = DateTime(
      segunda.year,
      segunda.month,
      segunda.day + 7,
    );
    final entregas = descartes.where((descarte) {
      final conclusao = descarte.dataConclusao;
      return conclusao != null &&
          !conclusao.isBefore(segunda) &&
          conclusao.isBefore(proximaSegunda);
    }).length;

    return MetaSemanal._(inicio: segunda, fim: domingo, entregas: entregas);
  }
}
