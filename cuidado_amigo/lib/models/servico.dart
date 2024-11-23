class Servico {
  final String id;
  final String data;
  final String horaInicio;
  final String horaFim;
  final String usuario;
  final String prestador;
  final String endereco;
  final String cep;
  final String numero;
  final String complemento;
  final String cidade;
  final String estado;
  final String valor;
  double avaliacao; // Novo campo
  bool finalizada;
  bool avaliado;
  bool destaque;

  Servico({
    required this.id,
    required this.data,
    required this.horaInicio,
    required this.horaFim,
    required this.endereco,
    required this.usuario,
    required this.prestador,
    required this.cep,
    required this.numero,
    required this.complemento,
    required this.cidade,
    required this.estado,
    required this.valor,
    this.avaliacao = 0.0, // Valor padrão
    this.finalizada = false,
    this.avaliado = false,
    this.destaque = false,
  });

  Servico.fromMap(Map<String, dynamic> map)
      : id = map["id"] ?? "",
        data = map["data"] ?? "",
        horaInicio = map["horaInicio"] ?? "",
        horaFim = map["horaFim"] ?? "",
        endereco = map["endereco"] ?? "",
        usuario = map["usuario"] ?? "",
        prestador = map["prestador"] ?? "",
        cep = map["cep"] ?? "",
        numero = map['numero'] ?? "",
        complemento = map['complemento'] ?? "",
        estado = map['estado'] ?? "",
        cidade = map['cidade'] ?? "",
        valor = map['valor'] ?? "",
        avaliacao =
            (map['avaliacao'] ?? 0.0).toDouble(), // Convertido para double
        finalizada = map['finalizada'] ?? false,
        avaliado = map['avaliado'] ?? false,
        destaque = map['destaque'] ?? false;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "data": data,
      "horaInicio": horaInicio,
      "horaFim": horaFim,
      "endereco": endereco,
      "usuario": usuario,
      "prestador": prestador,
      "numero": numero,
      "cep": cep,
      "Complemento": complemento,
      "cidade": cidade,
      "estado": estado,
      "valor": valor,
      "avaliacao": avaliacao, // Adicionado campo avaliacao
      "finalizada": finalizada,
      "avaliado": avaliado,
      "destaque": destaque,
    };
  }

  Servico copyWith({
    double? avaliacao, // Adicionado parâmetro avaliacao
    bool? finalizada,
    bool? avaliado,
    bool? destaque,
  }) {
    return Servico(
      id: id,
      data: data,
      horaInicio: horaInicio,
      horaFim: horaFim,
      endereco: endereco,
      usuario: usuario,
      prestador: prestador,
      cep: cep,
      numero: numero,
      complemento: complemento,
      cidade: cidade,
      estado: estado,
      valor: valor,
      avaliacao: avaliacao ?? this.avaliacao, // Atualizado campo avaliacao
      finalizada: finalizada ?? this.finalizada,
      avaliado: avaliado ?? this.avaliado,
      destaque: destaque ?? this.destaque,
    );
  }

  bool get isEmAberto {
    final now = DateTime.now();
    final servicoDateTime = parseDateAndTime(data, horaFim);
    return servicoDateTime.isAfter(now);
  }

  DateTime parseDateAndTime(String date, String hour) {
    final dateParts = date.split('/');
    final timeParts = hour.split(':');
    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = int.parse(dateParts[2]);
    final hourOfDay = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    return DateTime(year, month, day, hourOfDay, minute);
  }

  bool get isFinalizado {
    // Substitua esta lógica pela condição que define se o serviço está finalizado
    // Neste exemplo, estamos considerando que um serviço está finalizado se a data/hora atual for após a data/hora de fim do serviço.
    final now = DateTime.now();
    final servicoDateTime = parseDateAndTime(data, horaFim);
    return now.isAfter(servicoDateTime);
  }
}
