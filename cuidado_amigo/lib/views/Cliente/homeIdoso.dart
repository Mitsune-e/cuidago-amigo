import 'package:flutter/material.dart';

class HomeIdoso extends StatelessWidget {
  const HomeIdoso({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C9C9),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
          icon: const Icon(Icons.exit_to_app), // Botão de Saída na esquerda
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/agenda');
            },
            icon: const Icon(Icons.calendar_today), // Botão de Agenda à direita
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/perfil');
            },
            icon: const Icon(Icons.person), // Botão de Perfil à direita
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 175.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* const CircleAvatar(
                radius: 80, // Tamanho do ícone de pessoa
                backgroundColor: Colors.white, // Fundo branco para o ícone
              ),
              const SizedBox(height: 20),
              const Text(
                'Bem-vindo(a), Nome do Idoso',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ) , */
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSquare(
                    context,
                    'Enfermeira(o)',
                    'Assets/imagens/enfermeira.png',
                    () {
                      //Navigator.of(context).pushNamed('/pedirEnfermeiro');
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildSquare(
                    context,
                    'Cuidador ou Passeador',
                    'Assets/imagens/cuidador.png',
                    () {
                      Navigator.of(context).pushNamed('/solicitarCuidador1');
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
