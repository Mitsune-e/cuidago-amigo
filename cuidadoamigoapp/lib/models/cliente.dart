class Cliente {
  final String id;
  final String name;
  final String imagem;
  final String email;
  final String telefone;
  final String senha;
  

  const Cliente({
    required this.id,
    required this.name,
    required this.imagem,
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
        senha = map["senha"];
        

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "imagem": imagem,
      "email": email,
      "telefone": telefone,
      "senha": senha,
    };
  }
}
