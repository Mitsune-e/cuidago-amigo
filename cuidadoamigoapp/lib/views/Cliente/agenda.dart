import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/Prestador.dart';
import 'package:cuidadoamigoapp/models/Servico.dart';
import 'package:cuidadoamigoapp/views/Cliente/detalhamento.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class Agenda extends StatefulWidget {
  const Agenda({Key? key});

  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Servico> servicosDoCliente = [];
  List<Servico> servicosEmAberto = [];
  List<Servico> servicosFinalizados = [];
  bool exibirEmAberto = true;
  TextEditingController nomePrestador = TextEditingController();
  double novaAvaliacao = 0.0;

  @override
  void initState() {
    super.initState();
    initializeTimeZones();
    final String brt = 'America/Sao_Paulo';
    final location = getLocation(brt);
    var now = DateTime.now().toLocal();
    now = tz.TZDateTime.from(now, location);

    final User? user = _auth.currentUser;
    print(user);
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      firestore
          .collection("Servicos")
          .where("usuario", isEqualTo: user.uid)
          .get()
          .then((querySnapshot) async {
        servicosDoCliente.clear();
        servicosEmAberto.clear();
        servicosFinalizados.clear();

        for (var document in querySnapshot.docs) {
          final servico = Servico.fromMap(document.data() as Map<String, dynamic>);
          
          final prestador = await loadPrestadorById(servico.prestador);

          if (prestador != null) {
            nomePrestador.text = prestador.name;
          }

          final servicoDateTime = parseDateAndTime(servico.data, servico.horaFim);

          if (!servico.finalizada) {
            servicosEmAberto.add(servico.copyWith(destaque: true));
          } else if (servico.finalizada) {
            servicosFinalizados.add(servico.copyWith(destaque: true));
          }
        }

        setState(() {
          servicosDoCliente = exibirEmAberto ? servicosEmAberto : servicosFinalizados;
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

  Future<Prestador?> loadPrestadorById(String prestadorId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('Prestadores').doc(prestadorId).get();

      if (snapshot.exists) {
        return Prestador.fromMap(snapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao carregar prestador: $e');
      return null;
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xFF73C9C9),
      title: const Text('Minha Agenda'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pushNamed("/homeIdoso");
        },
      ),
    ),
    body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  exibirEmAberto = true;
                  servicosDoCliente = servicosEmAberto;
                  novaAvaliacao = 0.0; // Reinicialize novaAvaliacao
                });
              },
              style: ElevatedButton.styleFrom(
                primary: exibirEmAberto ? Colors.blue : Colors.grey,
              ),
              child: Text('Em Aberto'),
            ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  exibirEmAberto = false;
                  servicosDoCliente = servicosFinalizados;
                  novaAvaliacao = 0.0; // Reinicialize novaAvaliacao
                });
              },
              style: ElevatedButton.styleFrom(
                primary: !exibirEmAberto ? Colors.blue : Colors.grey,
              ),
              child: Text('Finalizadas'),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: servicosDoCliente.map((servico) {
              return FutureBuilder<Prestador?>(
              key: Key(servico.id), // Adicione esta linha para definir uma chave única
              future: loadPrestadorById(servico.prestador),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Prestador? prestador = snapshot.data;
                  return _buildServiceItem(servico, prestador);
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar prestador');
                } else {
                  return CircularProgressIndicator();
                }
                },
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}
Widget _buildServiceItem(Servico servico, [Prestador? prestador]) {
    // Obtém a data e hora atual
    final DateTime now = DateTime.now();

     return Card(
      elevation: servico.destaque ? 8 : 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: _showRedBorderAndStars(servico, now) ? Colors.red : Colors.transparent,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Data: ${servico.data}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Horário: ${servico.horaInicio} - ${servico.horaFim}'),
                Text('Endereço: ${servico.endereco}'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesServico(servico: servico),
                ),
              );
            },
          ),
          if (_showRedBorderAndStars(servico, now) && !servico.avaliado)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prestador: ${nomePrestador.text}'),
                 RatingBar.builder(
                  initialRating: servico.avaliacao, // Usar a avaliação do serviço
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 30,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    // Atualizar a avaliação do serviço ao interagir com o RatingBar
                    setState(() {
                      servico.avaliacao = rating;
                    });
                  },
                ),
                 ElevatedButton(
                  onPressed: () async {
                    // Calcular a média ponderada
                    double avaliacaoAtual = prestador!.avaliacao;
                    double pesoAvaliacaoAtual = 0.8;
                    double pesoNovaAvaliacao = 0.2;
                    double novaAvaliacaoPonderada =
                        (avaliacaoAtual * pesoAvaliacaoAtual +
                            novaAvaliacao * pesoNovaAvaliacao);

                    // Restringir a mudança máxima
                    double limiteMudancaMaxima = 0.5;
                    double diferenca =
                        (novaAvaliacaoPonderada - avaliacaoAtual).abs();
                    if (diferenca > limiteMudancaMaxima) {
                      novaAvaliacaoPonderada = avaliacaoAtual +
                          (novaAvaliacaoPonderada > avaliacaoAtual
                              ? limiteMudancaMaxima
                              : -limiteMudancaMaxima);
                    }

                    // Atualizar a avaliação do prestador no Firestore
                    await FirebaseFirestore.instance
                        .collection('Prestadores')
                        .doc(servico.prestador)
                        .update({
                      'avaliacao': novaAvaliacaoPonderada,
                    });

                    // Alterar o atributo finalizada para true e avaliado para true
                    servico.finalizada = true;
                    servico.avaliado = true;

                    // Atualizar o documento no Firestore
                    await FirebaseFirestore.instance
                        .collection('Servicos')
                        .doc(servico.id)
                        .update({
                      'finalizada': servico.finalizada,
                      'avaliado': servico.avaliado,
                    });

                    // Atualizar a lista servicosEmAberto
                   if (exibirEmAberto) {
                    setState(() {
                      servicosEmAberto = servicosEmAberto.where((s) => !s.finalizada).toList();
                      servicosDoCliente = servicosEmAberto.map((servico) {
                        return servico.copyWith(destaque: false);
                      }).toList();
                    });
                  } else {
                    // Atualizar a lista servicosFinalizados
                    setState(() {
                      servicosFinalizados = servicosFinalizados.where((s) => !s.finalizada).toList();
                      servicosDoCliente = servicosFinalizados.map((servico) {
                        return servico.copyWith(destaque: false);
                      }).toList();
                    });
                  }
                  },
                  
                  child: Text('Concluir Avaliação'),
                ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  bool _showRedBorderAndStars(Servico servico, DateTime now) {
    return !servico.finalizada && parseDateAndTime(servico.data, servico.horaFim).isBefore(now);
  }
}