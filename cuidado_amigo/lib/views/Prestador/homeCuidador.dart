import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidado_amigo/models/Servico.dart';
import 'package:cuidado_amigo/views/Prestador/detalhamento2.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class HomePrestador extends StatefulWidget {
  const HomePrestador({super.key});

  @override
  HomePrestadorState createState() => HomePrestadorState();
}

// ...
class HomePrestadorState extends State<HomePrestador> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Servico> servicosDoCliente = [];
  List<Servico> servicosEmAberto = [];
  List<Servico> servicosFinalizados = [];
  bool exibirEmAberto =
      true; // Variável para controlar a exibição de serviços em aberto ou finalizados

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
      final firestore = FirebaseFirestore.instance;
      firestore
          .collection("Servicos")
          .where("prestador", isEqualTo: user.uid)
          .get()
          .then((querySnapshot) {
        servicosDoCliente.clear();
        for (var document in querySnapshot.docs) {
          final servico = Servico.fromMap(document.data());
          final servicoDateTime =
              parseDateAndTime(servico.data, servico.horaFim);

          // Verificar se o serviço é em aberto (data e horaFim após o momento atual)
          if (servicoDateTime.isAfter(now)) {
            servicosEmAberto.add(servico);
          }
          // Verificar se o serviço é finalizado (data e horaFim antes do momento atual)
          else if (servicoDateTime.isBefore(now)) {
            servicosFinalizados.add(servico);
          }
        }

        setState(() {
          servicosDoCliente = servicosEmAberto;
        });
      });
    }
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
                        exibirEmAberto = true;
                        servicosDoCliente = servicosEmAberto;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:
                          exibirEmAberto ? Colors.green : Colors.black,
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
                        exibirEmAberto = false;
                        servicosDoCliente = servicosFinalizados;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:
                          !exibirEmAberto ? Colors.green : Colors.black,
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
        trailing: showPlayButton
            ? IconButton(
                icon: Icon(
                  Icons.play_circle_fill,
                  color: Colors.green,
                  size: 32,
                ),
                onPressed: () {
                  // Adicione ação para iniciar o serviço aqui
                },
              )
            : null,
      ),
    );
  }

  bool isShowPlayButton(Servico servico) {
    DateTime now = DateTime.now();
    DateTime serviceStart = parseDateAndTime(servico.data, servico.horaInicio);
    DateTime serviceEnd = parseDateAndTime(servico.data, servico.horaFim);

    return (serviceStart.isAtSameMomentAs(now) || serviceStart.isBefore(now)) &&
        serviceEnd.isAfter(now) &&
        serviceStart.day == now.day;
  }
}
