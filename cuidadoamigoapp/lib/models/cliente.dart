import 'dart:io';

class Cliente {
  final String id;
  final String name;
  final String imagem;
  final String email;
  final String telefone;
  final String senha;
  final List<String> enderecos;
  final List<String> servicos;

  const Cliente({
    required this.id,
    required this.name,
    required this.imagem,
    required this.email,
    required this.senha,
    required this.telefone,
    List<String> enderecos = const [],
    List<String> servicos = const [],
  }) : this.enderecos = enderecos,
       this.servicos = servicos;

  Cliente.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        imagem = map["imagem"],
        email = map["email"],
        telefone = map["telefone"],
        senha = map["senha"],
        enderecos = List<String>.from(map["enderecos"] ?? []),
        servicos = List<String>.from(map["servicos"] ?? []);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "imagem": imagem,
      "email": email,
      "telefone": telefone,
      "senha": senha,
      "enderecos": enderecos,
      "servicos": servicos,
    };
  }
}
