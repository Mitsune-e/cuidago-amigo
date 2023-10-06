import 'package:flutter/material.dart';

class HomePrestador extends StatelessWidget {
  const HomePrestador({Key? key});

  @override
  Widget build(BuildContext context) {
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
              // Adicione ação para visualizar solicitações pendentes
            },
            icon: const Icon(
                Icons.notifications), // Ícone de notificações à direita
          ),
          IconButton(
            onPressed: () {
              // Adicione ação para visualizar perfil do prestador
            },
            icon: const Icon(Icons.person), // Ícone de perfil à direita
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 175.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                'Bem-vindo(a), Nome do Prestador',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* _buildSquare(
                    context,
                    'Iniciar Serviço',
                    'Assets/imagens/iniciar_servico.png',
                    () {
                      // Adicione ação para iniciar serviço
                    },
                  ),*/
                  /*SizedBox(width: 20),
                  _buildSquare(
                    context,
                    'Solicitações',
                    'Assets/imagens/solicitacoes.png',
                    () {
                      // Adicione ação para visualizar solicitações
                    },
                  ),*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquare(BuildContext context, String title, String imagePath,
      VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 150,
        height: 150,
        color: const Color(0xFF73C9C9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
