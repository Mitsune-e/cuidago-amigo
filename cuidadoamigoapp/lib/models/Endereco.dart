class Endereco {
  final String id;
  final String cep;
  final String endereco;
  final String numero;
  final String complemento;

  const Endereco({
    required this.id,
    required this.cep,
    required this.endereco,
    required this.numero,
    required this.complemento
  });

  Endereco.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        cep = map["cep"],
        endereco = map["endereco"],
        numero = map["numero"],
        complemento = map["complemento"];


  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "cep": cep,
      "endereco": endereco,
      "numero": numero,
      "complemento": complemento,
  };
}
}