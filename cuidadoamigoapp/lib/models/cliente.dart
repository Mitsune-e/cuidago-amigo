class Cliente {
  final String id;
  final String name;
  final String imagem;
  final String email;
  final String cpf;
  final String telefone;
  final String senha;
  List<String>? enderecos;
  List<String>? servicos;

  Cliente({
    required this.id,
    required this.name,
    required this.imagem,
    required this.cpf,
    required this.email,
    required this.senha,
    required this.telefone,
    List<String>? enderecos,
    List<String>? servicos,
  })   : this.enderecos = enderecos ?? [],
        this.servicos = servicos ?? [];

  Cliente.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        imagem = map["imagem"],
        email = map["email"],
        telefone = map["telefone"],
        senha = map["senha"],
        cpf = map["cpf"],
        enderecos = List<String>.from(map["enderecos"] ?? []),
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
      "enderecos": enderecos,
      "servicos": servicos,
    };
  }
}