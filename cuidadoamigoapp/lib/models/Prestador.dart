import 'package:cloud_firestore/cloud_firestore.dart';

class Prestador {
  final String id;
  final String name;
  final String imagem;
  final String email;
  final String cpf;
  final String telefone;
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
  final String chavePix;


  Prestador({
    required this.id,
    required this.name,
    required this.imagem,
    required this.cpf,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.estado,
    required this.endereco,
    required this.cidade,
    required this.complemento,
    required this.numero,
    required this.descricao,
    required this.carro,
    double saldo = 0.0,
    double avaliacao = 5.0, 
    required this.chavePix,
    List<String>? servicos,
  })   : this.servicos = servicos ?? [], // Corrigido aqui
        this.Datas = servicos ?? [], // Corrigido aqui
        this.avaliacao = (avaliacao >= 0 && avaliacao <= 5) ? avaliacao : 5.0, // Corrigido aqui
        this.saldo = (saldo >= 0) ? saldo : 0.0; // Corrigido aqui

  Prestador.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        imagem = map["imagem"],
        email = map["email"],
        telefone = map["telefone"],
        senha = map["senha"],
        cpf = map["cpf"],
        endereco = map["endereco"],
        estado = map['estado'],
        cidade =map['cidade'],
        numero = map['numero'],
        complemento = map['complemento'],
        carro = map['carro'],
        descricao = map['descricao'],
        saldo = (map['saldo'] as num?)?.toDouble() ?? 0.0,
        avaliacao = (map['avaliacao'] as num?)?.toDouble() ?? 5.0,
        chavePix = map["chavePix"],
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
      'estado': estado,
      'cidade': cidade,
      'numero': numero,
      'complemento': complemento,
      "servicos": servicos,
      "carro" : carro,
      'saldo': saldo,
      'avaliacao':avaliacao,
      "descricao": descricao,
      "Datas": Datas,
      "chavepix": chavePix,
    };
  }

factory Prestador.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Prestador(
      id: doc.id,
      name: data['name'],
      cpf: data['cpf'],
      imagem: data['imagem'],
      email: data['email'],
      telefone: data['telefone'],
      senha: data['senha'],
      endereco: data['endereco'],
      estado: data['estado'],
      cidade: data['cidade'],
      numero: data['numero'],
      complemento: data['complemento'],
      servicos: data['servicos'],
      carro: data['carro'],
      saldo: data['saldo'],
      avaliacao: data['avaliacao'],
      descricao: data['descricao'],
      chavePix: data['chavepix'],
    );
  }
}