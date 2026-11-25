import 'descarte.dart';

class PontoColeta {
  const PontoColeta({
    required this.nome,
    required this.endereco,
    this.referencia,
    required this.horario,
    required this.materiais,
  });

  final String nome;
  final String endereco;
  final String? referencia;
  final String horario;
  final Map<MaterialDescarte, String> materiais;
}
