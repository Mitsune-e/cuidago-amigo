import 'package:flutter/material.dart';

class Carteira extends StatefulWidget {
  const Carteira({Key? key}) : super(key: key);

  @override
  _CarteiraState createState() => _CarteiraState();
}

class _CarteiraState extends State<Carteira> {
  double saldo = 1000.0; // Saldo inicial

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C9C9),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popAndPushNamed('/homePrestador');
          },
        ),
        title: Text('Minha Carteira'),
        actions: [],
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
                color: const Color(0xFF73C9C9),
              ),
            ),
            Text(
              'R\$ ${saldo.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Formas de Retirada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF73C9C9),
              ),
            ),
            SizedBox(height: 16),
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
          child: Text('Pix'),
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFF73C9C9),
            onPrimary: Colors.white,
            minimumSize: Size(150, 50)
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Adicione ação para retirada via Boleto
          },
          child: Text('Boleto'),
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
            onPrimary: Colors.white,
            minimumSize: Size(150, 50)
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Adicione ação para retirada via Conta corrente
          },
          child: Text('Conta Corrente'),
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
            onPrimary: Colors.white,
            minimumSize: Size(150, 50)
          ),
        ),
      ],
    );
  }

  void _mostrarOpcaoPix(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double valorRetirada = 0;

        return AlertDialog(
          title: Text('Retirar via Pix'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Valor a ser retirado'),
                onChanged: (value) {
                  valorRetirada = double.tryParse(value) ?? 0;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (valorRetirada > 0 && valorRetirada <= saldo) {
                    _pedirChavePix(context, valorRetirada);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Valor inválido!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('Continuar'),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF73C9C9),
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pedirChavePix(BuildContext context, double valorRetirada) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String chavePix = '';

        return AlertDialog(
          title: Text('Chave Pix'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Digite sua chave Pix'),
                onChanged: (value) {
                  chavePix = value;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implemente a lógica para processar a retirada via Pix
                  setState(() {
                    saldo -= valorRetirada; // Atualiza o saldo usando setState
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Retirada via Pix de R\$ $valorRetirada para $chavePix realizada com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context); // Fechar o diálogo
                  Navigator.pop(context); // Fechar o diálogo anterior
                },
                child: Text('Confirmar'),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF73C9C9),
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
