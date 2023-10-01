import 'package:flutter/material.dart';

class Agenda extends StatelessWidget {
  const Agenda({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF73C9C9),
        title: Text('Minha Agenda'),
        
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildServiceButton(
            'Serviço 1',
            'Descrição do Serviço 1',
            'Horário: 10:00 - 11:00',
            () {
              // Adicione a lógica para navegar para a página de detalhamento aqui
            },
          ),
          _buildServiceButton(
            'Serviço 2',
            'Descrição do Serviço 2',
            'Horário: 14:00 - 15:00',
            () {
              // Adicione a lógica para navegar para a página de detalhamento aqui
            },
          ),
          // Adicione mais serviços aqui, se necessário
        ],
      ),
    );
  }

  Widget _buildServiceButton(
    String serviceName,
    String serviceDescription,
    String serviceTime,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            serviceName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF73C9C9),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                serviceDescription,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                serviceTime,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF73C9C9),
          ),
        ),
      ),
    );
  }
}