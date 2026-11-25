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

  factory Descarte.deJson(Map<String, Object?> dados) {
    final conclusao = dados['dataConclusao'] as String?;
    return Descarte(
      id: dados['id'] as String,
      nome: dados['nome'] as String,
      material: MaterialDescarte.values.byName(dados['material'] as String),
      quantidade: dados['quantidade'] as int,
      dataCadastro: DateTime.parse(dados['dataCadastro'] as String),
      dataConclusao: conclusao == null ? null : DateTime.parse(conclusao),
    );
  }

  Map<String, Object?> paraJson() {
    return {
      'id': id,
      'nome': nome,
      'material': material.name,
      'quantidade': quantidade,
      'dataCadastro': dataCadastro.toUtc().toIso8601String(),
      'dataConclusao': dataConclusao?.toUtc().toIso8601String(),
    };
  }

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
