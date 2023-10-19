class Evento {
  final String id;
  final String name;
  final String imagem;
  final String local;
  final String cidade;
  final String uf;
  final String valor;
  final String data;
  final String horarioInicio;
  final String horarioFim;
  final String descricao;

  const Evento({
    required this.id,
    required this.name,
    required this.imagem,
    required this.local,
    required this.valor,
    required this.data,
    required this.uf,
    required this.cidade,
    required this.horarioFim,
    required this.horarioInicio,
    required this.descricao,
  });

  Evento.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        imagem = map["imagem"],
        local = map["local"],
        valor = map["valor"],
        data = map["data"],
        cidade = map["cidade"],
        uf = map["uf"],
        horarioInicio = map["horarioInicio"],
        horarioFim = map["horarioFim"],
        descricao = map["descricao"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "local": local,
      "imagem": imagem,
      "valor": valor,
      "data": data,
      "cidade": cidade,
      "uf": uf,
      "horarioInicio": horarioInicio,
      "horarioFim": horarioFim,
      "descricao": descricao,
    };
  }
}
