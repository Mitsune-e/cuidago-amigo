import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidado_amigo/models/Prestador.dart';
import 'package:cuidado_amigo/provider/Prestadores.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Carteira extends StatefulWidget {
  const Carteira({Key? key}) : super(key: key);

  @override
  _CarteiraState createState() => _CarteiraState();
}

class _CarteiraState extends State<Carteira> {
  double saldo = 0.0;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadSaldo(); // Carregue o saldo ao iniciar o widget
  }

  Future<void> _loadSaldo() async {
    try {
      Prestadores prestadoresProvider =
          Provider.of<Prestadores>(context, listen: false);

      // Verifica se _auth.currentUser não é null antes de acessar uid
      if (_auth.currentUser != null) {
        String idDoUsuario = ""; //_auth.currentUser!.uid;
        Prestador? prestador =
            await prestadoresProvider.loadClienteById(idDoUsuario);
        print(prestador!.name);

        if (prestador != null) {
          setState(() {
            saldo = prestador.saldo;
          });
        } else {
          print('Cuidador não encontrado para o ID do usuário: $idDoUsuario');
        }
      } else {
        print('_auth.currentUser é null');
      }
    } catch (e) {
      print('Erro ao carregar saldo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C9C9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popAndPushNamed('/homePrestador');
          },
        ),
        title: const Text('Minha Carteira'),
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Saldo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF73C9C9),
              ),
            ),
            Text(
              'R\$ ${saldo.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Formas de Retirada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF73C9C9),
              ),
            ),
            const SizedBox(height: 16),
            _buildOpcoesRetirada(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcoesRetirada(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            _mostrarOpcaoPix(context);
          },
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF73C9C9),
              minimumSize: const Size(150, 50)),
          child: const Text('Pix'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Adicione ação para retirada via Boleto
          },
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey,
              minimumSize: const Size(150, 50)),
          child: const Text('Boleto'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Adicione ação para retirada via Conta corrente
          },
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey,
              minimumSize: const Size(150, 50)),
          child: const Text('Conta Corrente'),
        ),
      ],
    );
  }

  void _mostrarOpcaoPix(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double valorRetirada = 50.0; // Substitua pelo valor real retirado
        TextEditingController valorController = TextEditingController();

        return AlertDialog(
          title: const Text('Retirar via Pix'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                controller: valorController,
                decoration:
                    const InputDecoration(labelText: 'Valor a ser retirado'),
                onChanged: (value) {
                  // Você pode realizar validações adicionais aqui, se necessário
                  valorRetirada =
                      double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (valorRetirada > 0 && valorRetirada <= saldo) {
                    _pedirChavePix(context, valorRetirada);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Valor inválido!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF73C9C9),
                ),
                child: const Text('Continuar'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pedirChavePix(
      BuildContext context, double valorRetirada) async {
    Prestador? prestador =
        await Prestadores().loadClienteById(_auth.currentUser?.uid ?? '');
    double saldoAtual = prestador?.saldo ?? 0.0;
    valorRetirada =
        double.tryParse(valorRetirada.toString().replaceAll(',', '.')) ?? 0.0;

    // Armazene o contexto antes de entrar no código assíncrono
    BuildContext currentContext = context;

    showDialog(
      context: currentContext,
      builder: (BuildContext context) {
        String chavePix = '';

        return AlertDialog(
          title: const Text('Chave Pix'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Digite sua chave Pix'),
                onChanged: (value) {
                  chavePix = value;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Lógica para processar a retirada via Pix

                    // Subtrai o valor retirado do saldo atual
                    double novoSaldo = saldoAtual - valorRetirada;
                    // Atualiza o saldo no Firestore
                    await _firestore
                        .collection("Prestadores")
                        .doc(prestador!.id)
                        .update({
                      'saldo': novoSaldo,
                    });

                    // Atualiza o saldo localmente no prestador
                    prestador.saldo = novoSaldo;

                    // Atualiza o saldo na página
                    setState(() {
                      saldo = novoSaldo;
                    });

                    // Mostra a mensagem de sucesso
                    ScaffoldMessenger.of(currentContext).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Retirada via Pix de R\$ $valorRetirada para $chavePix realizada com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Fecha os diálogos
                    Navigator.pop(currentContext); // Fecha o diálogo atual
                    Navigator.pop(currentContext); // Fecha o diálogo anterior
                  } catch (e) {
                    print('Erro ao processar retirada via Pix: $e');
                    // Trate o erro conforme necessário
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF73C9C9),
                ),
                child: const Text('Confirmar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
