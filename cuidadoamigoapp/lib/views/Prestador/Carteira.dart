import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cuidadoamigoapp/models/Prestador.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Carteira extends StatefulWidget {
  
  @override
  _CarteiraState createState() => _CarteiraState();
}

class _CarteiraState extends State<Carteira> {
  double valorRetirada = 0.0;

  @override
  Widget build(BuildContext context) {
    // Verificar se há um usuário autenticado
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Redirecionar para a tela de login, se não houver usuário autenticado
      // Coloque aqui a lógica para redirecionar para a tela de login
      return Scaffold(
        body: Center(
          child: Text('Usuário não autenticado. Por favor, faça o login.'),
        ),
      );
    }
    
    String prestadorId = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Carteira'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Saldo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('prestadores').doc(prestadorId).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  // Log para depuração
                  print('Erro ao carregar o documento do prestador: ${snapshot.error}');
                  print('Dados do Prestador: ${snapshot.data?.data()}');
                  return Text('Erro ao carregar saldo.');
                  
                }

                Prestador prestador = Prestador.fromFirestore(snapshot.data!);

                return Text(
                  'R\$ ${prestador.saldo ?? 0}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _mostrarRetiradaPix(context, prestadorId);
              },
              child: Text('Retirar via Pix'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                minimumSize: Size(150, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarRetiradaPix(BuildContext context, String prestadorId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Retirar via Pix'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    valorRetirada = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                  });
                },
                decoration: InputDecoration(labelText: 'Digite o valor a ser retirado'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_isValorRetiradaValid(valorRetirada)) {
                    _gerarQRCode(context, prestadorId, valorRetirada);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Valor inválido!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('Continuar'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isValorRetiradaValid(double valor) {
    return valor > 0;
  }

  Future<void> _gerarQRCode(BuildContext context, String prestadorId, double valorRetirada) async {
    DocumentSnapshot prestadorSnapshot = await FirebaseFirestore.instance.collection('prestadores').doc(prestadorId).get();
    
    if (!prestadorSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Prestador não encontrado.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Prestador prestador = Prestador.fromFirestore(prestadorSnapshot);

    String? chavePix = prestador.chavePix;

    if (chavePix != null) {
      // Formate os dados para o QR Code
      String urlPix = 'chave=$chavePix&valor=$valorRetirada';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('QR Code do Pagamento PIX'),
            content: Container(
              width: 200.0,
              height: 200.0,
              child: QrImageView(
                data: urlPix,
                version: QrVersions.auto,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  // Atualizar o saldo do prestador após a retirada
                  await FirebaseFirestore.instance.collection('prestadores').doc(prestadorId).update({
                    'saldo': FieldValue.increment(-valorRetirada),
                  });

                  Navigator.of(context).pop(); // Fechar o diálogo
                },
                child: Text('Concluir'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chave PIX não disponível.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
