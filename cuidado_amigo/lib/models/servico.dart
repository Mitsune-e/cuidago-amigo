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
  final String movimentacao;
  final String alimentacao;
  final String doencaCronica;
  double avaliacao; // Novo campo
  bool avaliado;
  bool destaque;
  String status;

  Servico(
      {required this.id,
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
      required this.movimentacao,
      required this.alimentacao,
      required this.doencaCronica,
      this.avaliacao = 0.0, // Valor padrão
      this.avaliado = false,
      this.destaque = false,
      this.status = ''});

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
        movimentacao = map['movimentacao'],
        alimentacao = map['alimentacao'],
        doencaCronica = map['doencaCronica'],
        avaliacao =
            (map['avaliacao'] ?? 0.0).toDouble(), // Convertido para double
        avaliado = map['avaliado'] ?? false,
        destaque = map['destaque'] ?? false,
        status = map['status'] ?? '';

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
      "avaliado": avaliado,
      "destaque": destaque,
      "status": status,
      'movimentacao': movimentacao,
      'alimentacao': alimentacao,
      'doencaCronica': doencaCronica
    };
  }

  Servico copyWith({
    double? avaliacao, // Adicionado parâmetro avaliacao
    bool? avaliado,
    bool? destaque,
    String? status,
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
        movimentacao: movimentacao,
        alimentacao: alimentacao,
        doencaCronica: doencaCronica,
        avaliacao: avaliacao ?? this.avaliacao, // Atualizado campo avaliacao
        avaliado: avaliado ?? this.avaliado,
        destaque: destaque ?? this.destaque,
        status: status ?? this.status);
  }

  static const String solicitado = "Solicitado";

  static const String emAndamento = "Em Andamento";

  static const String cancelado = "Cancelado";

  static const String finalizado = "Finalizado";

  static List<String> get statusFinalizado {
    return [cancelado, finalizado];
  }

  bool get isEmAberto {
    return status == solicitado;
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
    return statusFinalizado.any((statusItem) => statusItem == status);
  }
}
