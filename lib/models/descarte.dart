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
    required this.registradoEm,
    this.entregueEm,
  });

  final String id;
  final String nome;
  final MaterialDescarte material;
  final int quantidade;
  final DateTime registradoEm;

  // A data de entrega é a que vai contar para a meta da semana.
  final DateTime? entregueEm;

  bool get entregue => entregueEm != null;
}
