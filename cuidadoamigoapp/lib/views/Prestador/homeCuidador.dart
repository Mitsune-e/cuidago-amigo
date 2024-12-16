import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/Servico.dart';
import 'package:cuidadoamigoapp/provider/Prestadores.dart';
import 'package:cuidadoamigoapp/views/Prestador/detalhamento2.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';
import 'package:cuidadoamigoapp/provider/servicos.dart';

class HomeCuidador extends StatefulWidget {
  const HomeCuidador({super.key});

  @override
  HomeCuidadorState createState() => HomeCuidadorState();
}

// ...
class HomeCuidadorState extends State<HomeCuidador> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Servico> servicosDoCliente = [];
  List<Servico> servicosEmAberto = [];
  List<Servico> servicosEmAndamento = [];
  List<Servico> servicosFinalizados = [];
  String exibirStatus = Servico.solicitado;
  String userId = "";

  @override
  void initState() {
    super.initState();

    final User? user = _auth.currentUser;

    initializeTimeZones();

    // Obter o fuso horário de Brasília
    final String brt = 'America/Sao_Paulo';
    final location = getLocation(brt);

    // Obter a data e hora atual no fuso horário de Brasília
    var now = DateTime.now().toLocal();
    now = tz.TZDateTime.from(now, location);

    if (user != null) {
      _reloadServicosDoCliente(user.uid, Servico.solicitado);
      userId = user.uid;
    }
  }

  void _reloadServicosDoCliente(String id, String aba) async {
    final firestore = FirebaseFirestore.instance;
    firestore
        .collection("Servicos")
        .where("prestador", isEqualTo: id)
        .get()
        .then((querySnapshot) async {
      servicosDoCliente.clear();
      servicosEmAberto.clear();
      servicosFinalizados.clear();
      servicosEmAndamento.clear();

      final prestadoresProvider = Prestadores();

      final prestadorId = _auth.currentUser!.uid;
      final prestador = await prestadoresProvider.carregarById(prestadorId);
      final servicoesId = prestador.servicos;

      for (var document in querySnapshot.docs) {
        final servico = Servico.fromMap(document.data());

        if (servicoesId!.any((id) => id == servico.id)) {
          if (servico.isEmAberto) {
            servicosEmAberto.add(servico);
          } else if (servico.isFinalizado) {
            servicosFinalizados.add(servico);
          } else if (servico.status == Servico.emAndamento) {
            servicosEmAndamento.add(servico);
          }
        }
      }

      setState(() {
        servicosDoCliente = switch (aba) {
          Servico.solicitado => servicosEmAberto,
          Servico.emAndamento => servicosEmAndamento,
          Servico.finalizado => servicosFinalizados,
          _ => []
        };
        exibirStatus = aba;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    Color buttonBackgroundColor = const Color(0xFF73C9C9).withOpacity(0.8);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C9C9),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
          icon: const Icon(Icons.exit_to_app),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/carteira');
            },
            icon: const Icon(Icons.wallet),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/perfilPrestador');
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  color: buttonBackgroundColor,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        exibirStatus = Servico.solicitado;
                        servicosDoCliente = servicosEmAberto;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: exibirStatus == Servico.solicitado
                          ? Colors.green
                          : Colors.black,
                    ),
                    child: Text('Em Aberto'),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.black, // Linha preta
              ),
              Expanded(
                child: Container(
                  height: 50,
                  color: buttonBackgroundColor,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        exibirStatus = Servico.emAndamento;
                        servicosDoCliente = servicosEmAndamento;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: exibirStatus == Servico.emAndamento
                          ? Colors.green
                          : Colors.black,
                    ),
                    child: Text('Em Andamento'),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.black, // Linha preta
              ),
              Expanded(
                child: Container(
                  height: 50,
                  color: buttonBackgroundColor,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        exibirStatus = Servico.finalizado;
                        servicosDoCliente = servicosFinalizados;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: exibirStatus == Servico.finalizado
                          ? Colors.green
                          : Colors.black,
                    ),
                    child: Text('Finalizadas'),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: servicosDoCliente.map((servico) {
                return _buildServiceItem(servico);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(Servico servico) {
    bool showPlayButton = isShowPlayButton(servico);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
          title: Text('Data: ${servico.data}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Horário: ${servico.horaInicio} - ${servico.horaFim}'),
              Text('Endereço: ${servico.endereco}'),
              Text('Status: ${servico.status}')
            ],
          ),
          onTap: servicosEmAberto.contains(servico)
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetalhesServico2(servico: servico),
                    ),
                  );
                }
              : null,
          trailing: _pickButtonToShow(servico)),
    );
  }

  _pickButtonToShow(Servico servico) {
    if (servico.status == Servico.solicitado) {
      return IconButton(
        icon: Icon(
          Icons.play_circle_fill,
          color: Colors.green,
          size: 32,
        ),
        onPressed: () {
          servico.status = Servico.emAndamento;

          Provider.of<Servicos>(context, listen: false).editar(servico);
          _reloadServicosDoCliente(userId, Servico.emAndamento);
        },
      );
    }
    if (servico.status == Servico.emAndamento) {
      return IconButton(
        icon: Icon(
          Icons.play_circle_fill,
          color: Colors.blue,
          size: 32,
        ),
        onPressed: () {
          servico.status = Servico.finalizado;

          Provider.of<Servicos>(context, listen: false).editar(servico);
          _reloadServicosDoCliente(userId, Servico.finalizado);
        },
      );
    }
    return null;
  }

  bool isShowPlayButton(Servico servico) {
    return servico.status == Servico.solicitado;
  }
}
