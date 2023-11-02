class Cliente {
  final String id;
  final String name;
  final String imagem;
  final String email;
  final String cpf;
  final String telefone;
  final String senha;
  

  const Cliente({
    required this.id,
    required this.name,
    required this.imagem,
    required this.cpf,
    required this.email,
    required this.senha,
    required this.telefone,
  
  });

  Cliente.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        imagem = map["imagem"],
        email = map["email"],
        telefone = map["telefone"],
<<<<<<< HEAD
        senha = map["senha"],
        cpf = map["cpf"],
        enderecos = List<String>.from(map["enderecos"] ?? []),
        servicos = List<String>.from(map["servicos"] ?? []);
=======
        senha = map["senha"];
        
>>>>>>> parent of 996035b (image)

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "cpf":cpf,
      "imagem": imagem,
      "email": email,
      "telefone": telefone,
      "senha": senha,
    };
  }
}
