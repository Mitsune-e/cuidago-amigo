import 'package:flutter/material.dart';

class HomePrestador extends StatelessWidget {
  const HomePrestador({Key? key});

  @override
  Widget build(BuildContext context) {
    // Aqui você precisará ajustar a lógica para verificar se o usuário é um prestador
    bool isPrestador = true; // Substitua isso pela sua lógica de verificação

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
            icon: const Icon(
                Icons.wallet), // Ícone de carteira à direita
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/perfilPrestador');
            },
            icon: const Icon(Icons.person), // Ícone de perfil à direita
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 175.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                // Adicione uma imagem do prestador aqui
                backgroundImage: AssetImage('caminho/para/sua/imagem.jpg'),
              ),
              const SizedBox(height: 20),
              Text(
                'Bem-vindo(a), Nome do Prestador',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),*/
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSquare(
                    context,
                    'Iniciar Serviço',
                    Icons.play_arrow,
                    () {
                      // Adicione ação para iniciar serviço
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildSquare(
                    context,
                    'Solicitações',
                    Icons.notification_important,
                    () {
                      // Adicione ação para visualizar solicitações
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquare(
      BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 150,
        height: 150,
        color: const Color(0xFF73C9C9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 80,
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