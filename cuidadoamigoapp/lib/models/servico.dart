class Servico {
  final String id;
  final String data;
  final String horaInicio;
  final String horaFim;
  final String usuario;
  final String prestador;
  final String endereco;
  final String numero;
  final String complemento;
  final String cidade;
  final String estado ;

  Servico({
    required this.id,
    required this.data,
    required this.horaInicio,
    required this.horaFim,
    required this.endereco,
    required this.usuario,
    required this.prestador,
    required this.numero,
    required this.complemento,
    required this.cidade,
    required this.estado,
  });
  Servico.fromMap(Map<String, dynamic> map)
        : id = map["id"] ?? "",
        data = map["data"] ?? "",
        horaInicio = map["horaInicio"] ?? "",
        horaFim = map["horaFim"] ?? "",
        endereco = map["endereco"] ?? "",
        usuario = map["usuario"] ?? "",
        prestador = map["prestador"] ?? "",
        numero = map['numero'] ?? "",
        complemento = map['complemento'] ?? "",
        estado = map['estado'] ?? "",
        cidade = map['cidade'] ?? "";

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
      "Complemento":complemento,
      "cidade" : cidade,
      "estado": estado,
    };
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