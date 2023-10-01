import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  TextEditingController _nomeController = TextEditingController(text: 'João da Silva');
  TextEditingController _cpfController = TextEditingController(text: '123.456.789-00');
  TextEditingController _emailController = TextEditingController(text: 'joao.silva@example.com');
  TextEditingController _telefoneController = TextEditingController(text: '(12) 3456-7890');
  TextEditingController _cepController = TextEditingController(text: '12345-678');
  TextEditingController _enderecoController = TextEditingController(text: 'Rua da Paz, 123');
  TextEditingController _tipoSanguineoController = TextEditingController(text: 'A+');
  TextEditingController _alergiasController = TextEditingController(text: 'Nenhuma');
  TextEditingController _medicamentosController = TextEditingController(text: 'Nenhum');
  TextEditingController _condicoesMedicasController = TextEditingController(text: 'Nenhuma');

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
              title: 'Dados Pessoais',
              buttonText: 'Editar',
              onButtonPressed: () {
                _mostrarEditarDialog(
                  'Dados Pessoais',
                  [
                    _nomeController,
                    _cpfController,
                    _emailController,
                    _telefoneController,
                    _cepController,
                  ],
                );
              },
              children: [
                _buildInfoRow('Nome', _nomeController.text),
                _buildInfoRow('CPF', _cpfController.text),
                _buildInfoRow('E-mail', _emailController.text),
                _buildInfoRow('Telefone', _telefoneController.text),
                _buildInfoRow('CEP', _cepController.text),
              ],
            ),
            SizedBox(height: 20),
            _buildInfoBox(
              title: 'Endereço',
              buttonText: 'Editar',
              onButtonPressed: () {
                _mostrarEditarDialog(
                  'Endereço',
                  [
                    _enderecoController,
                  ],
                );
              },
              children: [
                _buildInfoRow('Endereço', _enderecoController.text),
              ],
            ),
            SizedBox(height: 20),
            _buildInfoBox(
              title: 'Informações de Saúde',
              buttonText: 'Editar',
              onButtonPressed: () {
                _mostrarEditarDialog(
                  'Informações de Saúde',
                  [
                    _tipoSanguineoController,
                    _alergiasController,
                    _medicamentosController,
                    _condicoesMedicasController,
                  ],
                );
              },
              children: [
                _buildInfoRow('Tipo Sanguíneo', _tipoSanguineoController.text),
                _buildInfoRow('Alergias', _alergiasController.text),
                _buildInfoRow('Medicamentos', _medicamentosController.text),
                _buildInfoRow('Condições Médicas', _condicoesMedicasController.text),
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

  void _mostrarEditarDialog(String title, List<TextEditingController> controllers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar $title'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < controllers.length; i++)
                  TextFormField(
                    controller: controllers[i],
                    decoration: InputDecoration(
                      labelText: controllers[i].text,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
