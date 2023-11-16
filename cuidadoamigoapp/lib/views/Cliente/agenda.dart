import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/servico.dart';
import 'package:cuidadoamigoapp/views/Cliente/detalhamento.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  bool exibirEmAberto = true; // Variável para controlar a exibição de serviços em aberto ou finalizados

  @override
  void initState() {
    super.initState();

    final User? user = _auth.currentUser;

    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      firestore
          .collection("Servicos")
          .where("usuario", isEqualTo: user.uid)
          .get()
          .then((querySnapshot) {
        servicosDoCliente.clear();
        final now = DateTime.now();
        querySnapshot.docs.forEach((document) {
          final servico = Servico.fromMap(document.data() as Map<String, dynamic>);
          final servicoDateTime = parseDateAndTime(servico.data, servico.horaInicio);

          // Verificar se o serviço é em aberto (data e horaFim após o momento atual)
          if (servicoDateTime.isAfter(now)) {
            servicosEmAberto.add(servico);
          }
          // Verificar se o serviço é finalizado (data e horaFim antes do momento atual)
          else if (servicoDateTime.isBefore(now)) {
            servicosFinalizados.add(servico);
          }
        });

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C9C9),
        title: const Text('Minha Agenda'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ícone de seta voltar
          onPressed: () {
            Navigator.of(context).pushNamed("/homeIdoso"); // Navega de volta à tela anterior
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
                return _buildServiceItem(servico);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildServiceItem(Servico servico) {
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
      onTap: servicosEmAberto.contains(servico) ? () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetalhesServico(servico: servico),
          ),
        );
      } : null, // Define onTap como nulo se não estiver em "Em Aberto"
    ),
  );
}
}