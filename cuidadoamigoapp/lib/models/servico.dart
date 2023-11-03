class Servico {
  final String id;
  final String data;
  final String horaInicio;
  final String horaFim;
  final String endereco;
  final String usuario;
  final String prestador;

  Servico({
    required this.id,
    required this.data,
    required this.horaInicio,
    required this.horaFim,
    required this.endereco,
    required this.usuario,
    required this.prestador,
  });

  Servico.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        data = map["data"],
        horaInicio = map["horaInicio"],
        horaFim = map["horaFim"],
        endereco = map["endereco"],
        usuario = map["usuario"] ,
        prestador = map["prestador"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "data": data,
      "horaInicio": horaInicio,
      "horaFim": horaFim,
      "endereco": endereco,
      "usuario": usuario,
      "prestador": prestador,
    };
  }
}