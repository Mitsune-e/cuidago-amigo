import 'package:flutter/material.dart';

class Carteira extends StatelessWidget {
  const Carteira({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C9C9),
        title: Text('Minha Carteira'),
        actions: [
          IconButton(
            onPressed: () {
              // Adicione ação para visualizar o perfil do prestador
            },
            icon: Icon(Icons.person), // Ícone de perfil à direita
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text(
              'Saldo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF73C9C9), // Cor principal
              ),
            ),
            Text(
              'R\$ 1.000,00', // Exemplo de saldo do usuário
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _mostrarOpcoesRetirada(context);
              },
              child: Text('Retirar Dinheiro'),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarOpcoesRetirada(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Adicione ação para retirada via Pix
                  Navigator.pop(context); // Fechar o modal
                },
                child: Text('Pix'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Adicione ação para retirada via Boleto
                  Navigator.pop(context); // Fechar o modal
                },
                child: Text('Boleto'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Adicione ação para retirada via Conta corrente
                  Navigator.pop(context); // Fechar o modal
                },
                child: Text('Conta Corrente'),
              ),
            ],
          ),
        );
      },
    );
  }
}
