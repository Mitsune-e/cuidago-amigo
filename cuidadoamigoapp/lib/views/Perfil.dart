import 'package:flutter/material.dart';

class Perfil extends StatelessWidget {
  const Perfil({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Conta'),
        backgroundColor: Color(0xFF73C9C9), // Cor principal
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                // Adicione a lógica para editar a foto do perfil aqui
              },
              child: CircleAvatar(
                radius: 75,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildInfoBox(
              title: 'Informações Pessoais',
              buttonText: 'Editar',
              onButtonPressed: () {
                // Adicione a lógica para editar as informações pessoais aqui
              },
              children: [
                _buildInfoRow('Nome', 'João da Silva'),
                _buildInfoRow('CPF', '123.456.789-00'),
                _buildInfoRow('E-mail', 'joao.silva@example.com'),
                _buildInfoRow('Telefone', '(12) 3456-7890'),
                _buildInfoRow('CEP', '12345-678'),
              ],
            ),
            SizedBox(height: 20),
            _buildInfoBox(
              title: 'Informações de Saúde',
              buttonText: 'Editar',
              onButtonPressed: () {
                // Adicione a lógica para editar as informações de saúde aqui
              },
              children: [
                _buildInfoRow('Tipo Sanguíneo', 'A+'),
                _buildInfoRow('Alergias', 'Nenhuma'),
                _buildInfoRow('Medicamentos', 'Nenhum'),
                _buildInfoRow('Condições Médicas', 'Nenhuma'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox({
    required String title,
    required String buttonText,
    required VoidCallback onButtonPressed,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF73C9C9), // Cor principal
                ),
              ),
              TextButton(
                onPressed: onButtonPressed,
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF73C9C9), // Cor principal
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
