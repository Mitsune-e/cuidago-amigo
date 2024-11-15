class Cliente {
  final String id;
  final String name;
  final String imagem;
  final String email;
  final String cpf;
  final String telefone;
  final String senha;
  final String cep;
  final String estado;
  final String cidade;
  final String endereco;
  final String numero;
  final String complemento;
  List<String>? servicos;

  Cliente({
    required this.id,
    required this.name,
    required this.imagem,
    required this.cpf,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.cep,
    required this.estado,
    required this.cidade,
    required this.endereco,
    required this.numero,
    required this.complemento,
    List<String>? servicos,
  }) : this.servicos = servicos ?? [];

  Cliente.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        imagem = map["imagem"],
        email = map["email"],
        telefone = map["telefone"],
        senha = map["senha"],
        cpf = map["cpf"],
        endereco = map["endereco"],
        cep = map["cep"],
        estado = map['estado'],
        cidade = map['cidade'],
        numero = map['numero'],
        complemento = map['complemento'],
        servicos = List<String>.from(map["servicos"] ?? []);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "cpf": cpf,
      "imagem": imagem,
      "email": email,
      "telefone": telefone,
      "senha": senha,
      "servicos": servicos,
      "cep": cep,
      "endereco": endereco,
      'estado': estado,
      'cidade': cidade,
      'numero': numero,
      'complemento': complemento,
    };
  }
}
