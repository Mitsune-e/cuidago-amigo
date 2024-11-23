class Prestador {
  final String id;
  final String name;
  final String imagem;
  final String email;
  final String cpf;
  final String telefone;
  final String cep;
  final String senha;
  final String estado;
  final String cidade;
  final String endereco;
  final String numero;
  final String complemento;
  final String descricao;
  final bool carro;
  double avaliacao;
  double saldo;
  List<String>? servicos;
  List<String>? Datas;

  Prestador({
    required this.id,
    required this.name,
    required this.imagem,
    required this.cpf,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.cep,
    required this.estado,
    required this.endereco,
    required this.cidade,
    required this.complemento,
    required this.numero,
    required this.descricao,
    required this.carro,
    double saldo = 0.0,
    double avaliacao = 5.0,
    List<String>? servicos,
  })  : this.servicos = servicos ?? [],
        this.Datas = servicos ?? [],
        this.avaliacao = avaliacao,
        this.saldo = saldo; // Corrigido aqui

  Prestador.fromMap(Map<String, dynamic> map)
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
        carro = map['carro'],
        descricao = map['descricao'],
        saldo = (map['saldo'] as num?)?.toDouble() ?? 0.0,
        avaliacao = (map['avaliacao'] as num?)?.toDouble() ?? 5.0,
        Datas = List<String>.from(map["Datas"] ?? []),
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
      "cep": cep,
      'estado': estado,
      'cidade': cidade,
      'numero': numero,
      'complemento': complemento,
      "servicos": servicos,
      "carro": carro,
      'saldo': saldo,
      'avaliacao': avaliacao,
      "descricao": descricao,
      "Datas": Datas,
    };
  }
}
