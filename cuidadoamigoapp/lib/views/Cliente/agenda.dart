import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/cliente.dart';
import 'package:cuidadoamigoapp/models/servico.dart';
import 'package:cuidadoamigoapp/provider/clientes.dart';
import 'package:cuidadoamigoapp/provider/servicos.dart';
import 'package:cuidadoamigoapp/views/cliente/detalhamento.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Agenda extends StatefulWidget {
  const Agenda({Key? key});

  @override
  _AgendaState createState() => _AgendaState();
}

// ...

class _AgendaState extends State<Agenda> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool exibirEmAberto = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = _auth.currentUser;
    final servicosProvider = Provider.of<Servicos>(context, listen: false);

    if (user == null) {
      return;
    }

    try {
      await servicosProvider.loadServicosFromFirestore();
    } catch (e) {
      print('Erro ao carregar serviços: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicosProvider = Provider.of<Servicos>(context);
    final servicosDoCliente = servicosProvider.listEvento;

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
            child: servicosProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: servicosDoCliente
                        .where((servico) =>
                            exibirEmAberto
                                ? servico.isEmAberto
                                : servico.isFinalizado)
                        .map((servico) {
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
        onTap: servico.isEmAberto
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetalhesServico(servico: servico),
                  ),
                );
              }
            : null,
      ),
    );
  }
}
