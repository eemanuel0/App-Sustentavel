enum MaterialDescarte {
  papel('Papel'),
  plastico('Plástico'),
  vidro('Vidro'),
  metal('Metal'),
  pilhas('Pilhas'),
  oleo('Óleo'),
  eletronicos('Eletrônicos'),
  outros('Outros');

  const MaterialDescarte(this.nome);

  final String nome;
}

class Descarte {
  const Descarte({
    required this.id,
    required this.nome,
    required this.material,
    required this.quantidade,
    required this.dataCadastro,
    this.dataConclusao,
  });

  final String id;
  final String nome;
  final MaterialDescarte material;
  final int quantidade;
  final DateTime dataCadastro;

  // A data serve para saber se o descarte foi entregue e em qual semana.
  final DateTime? dataConclusao;

  bool get concluido => dataConclusao != null;

  Descarte alternarConclusao(DateTime agora) {
    return Descarte(
      id: id,
      nome: nome,
      material: material,
      quantidade: quantidade,
      dataCadastro: dataCadastro,
      dataConclusao: concluido ? null : agora,
    );
  }
}
