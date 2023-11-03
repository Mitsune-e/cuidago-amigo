class Prestador {
  final String id;
  final String name;
  final String imagem;
  final String email;
  final String cpf;
  final String telefone;
  final String senha;
  final String endereco;
  List<String>? servicos;

  Prestador({
    required this.id,
    required this.name,
    required this.imagem,
    required this.cpf,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.endereco,
    List<String>? servicos,
  })   : this.servicos = servicos ?? [];

  Prestador.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        imagem = map["imagem"],
        email = map["email"],
        telefone = map["telefone"],
        senha = map["senha"],
        cpf = map["cpf"],
        endereco = map["endereco"],
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
      "endereco": endereco,
      "servicos": servicos,
    };
  }
}