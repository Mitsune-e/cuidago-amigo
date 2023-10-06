import 'package:flutter/material.dart';

class DetalhesServico extends StatefulWidget {
  final String serviceName;
  final String serviceDescription;
  final String serviceTime;
  final String serviceAddress;
  final String serviceDate;

  DetalhesServico({
    required this.serviceName,
    required this.serviceDescription,
    required this.serviceTime,
    required this.serviceAddress,
    required this.serviceDate,
  });

  @override
  _DetalhesServicoState createState() => _DetalhesServicoState();
}

class _DetalhesServicoState extends State<DetalhesServico> {
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController serviceDescriptionController = TextEditingController();
  TextEditingController serviceTimeController = TextEditingController();
  TextEditingController serviceAddressController = TextEditingController();
  TextEditingController serviceDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicialize os controladores de texto com os valores recebidos
    serviceNameController.text = widget.serviceName;
    serviceDescriptionController.text = widget.serviceDescription;
    serviceTimeController.text = widget.serviceTime;
    serviceAddressController.text = widget.serviceAddress;
    serviceDateController.text = widget.serviceDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF73C9C9), // Cor principal da página
        title: Text('Detalhes do Serviço'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFF73C9C9),
              child: Icon(
                Icons.person,
                size: 80,
                color: Colors.white,
              ),
              radius: 60,
            ),
            SizedBox(height: 20),
            Text(
              'Nome do Serviço',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Descrição do Serviço',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Hora de Início: 10:00 - Hora de Término: 11:00',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              'Endereço: 123 Rua Principal, Cidade',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              'Data: 01/01/2023',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _mostrarEditarServicoDialog(context);
                  },
                  child: Text('Editar Serviço'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF73C9C9), // Cor do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Torna o botão redondo
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _mostrarCancelarServicoDialog(context);
                  },
                  child: Text('Cancelar Serviço'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF73C9C9), // Cor do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Torna o botão redondo
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarEditarServicoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Serviço'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: serviceNameController,
                  decoration: InputDecoration(labelText: 'Nome do Serviço'),
                ),
                TextFormField(
                  controller: serviceDescriptionController,
                  decoration: InputDecoration(labelText: 'Descrição do Serviço'),
                ),
                TextFormField(
                  controller: serviceTimeController,
                  decoration: InputDecoration(labelText: 'Horário'),
                ),
                TextFormField(
                  controller: serviceAddressController,
                  decoration: InputDecoration(labelText: 'Endereço'),
                ),
                TextFormField(
                  controller: serviceDateController,
                  decoration: InputDecoration(labelText: 'Data'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Aqui você pode implementar a lógica para salvar as edições do serviço
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarCancelarServicoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancelar Serviço'),
          content: Text('Tem certeza que deseja cancelar o serviço?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: Text('Não'),
            ),
            TextButton(
              onPressed: () {
                // Aqui você pode implementar a lógica para cancelar o serviço
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: Text('Sim'),
            ),
          ],
        );
      },
    );
  }
}
