class IMCModel {
  String nome = '';
  double peso = 0.0;
  double altura = 0.0;

  IMCModel({
    required this.nome,
    required this.peso,
    required this.altura,
  });

  IMCModel copyWith({
    String? nome,
    double? peso,
    double? altura,
  }) {
    return IMCModel(
      nome: nome ?? this.nome,
      peso: peso ?? this.peso,
      altura: altura ?? this.altura,
    );
  }

  @override
  String toString() => 'IMCModel(nome: $nome, peso: $peso, altura: $altura)';
}
