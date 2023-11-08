import 'package:cuidadoamigoapp/models/servico.dart';
import 'package:cuidadoamigoapp/provider/servicos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetalhesServico extends StatefulWidget {
  final Servico servico;
  DetalhesServico({required this.servico});

  @override
  _DetalhesServicoState createState() => _DetalhesServicoState();
}

class _DetalhesServicoState extends State<DetalhesServico> {
  // Crie uma variável para armazenar o ID do serviço
  late String servicoId;

  TextEditingController serviceNameController = TextEditingController();
  TextEditingController serviceDescriptionController = TextEditingController();
  TextEditingController serviceTimeController = TextEditingController();
  TextEditingController serviceAddressController = TextEditingController();
  TextEditingController serviceDateController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Inicialize os controladores de texto com os valores recebidos
    serviceNameController.text = "Teste";
    serviceDescriptionController.text = "Teste";
    serviceTimeController.text = widget.servico.horaInicio;
    serviceAddressController.text = widget.servico.endereco;
    serviceDateController.text = widget.servico.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C9C9),
        title: const Text('Detalhes do Serviço'),
         leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ícone de seta voltar
          onPressed: () {
            Navigator.of(context).pushNamed("/agenda"); // Navega de volta à tela anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF73C9C9),
              radius: 60,
              child: Icon(
                Icons.person,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nome do Serviço',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Descrição do Serviço',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Hora de Início: 10:00 - Hora de Término: 11:00',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const Text(
              'Endereço: 123 Rua Principal, Cidade',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const Text(
              'Data: 01/01/2023',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _mostrarEditarServicoDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF73C9C9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Editar Serviço'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _mostrarCancelarServicoDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF73C9C9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Cancelar Serviço'),
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
          title: const Text('Editar Serviço'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: serviceNameController,
                  decoration: const InputDecoration(labelText: 'Nome do Serviço'),
                ),
                TextFormField(
                  controller: serviceDescriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição do Serviço'),
                ),
                TextFormField(
                  controller: serviceTimeController,
                  decoration: const InputDecoration(labelText: 'Horário'),
                ),
                TextFormField(
                  controller: serviceAddressController,
                  decoration: const InputDecoration(labelText: 'Endereço'),
                ),
                TextFormField(
                  controller: serviceDateController,
                  decoration: const InputDecoration(labelText: 'Data'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Aqui você pode implementar a lógica para salvar as edições do serviço
                // Use as propriedades do widget para acessar os valores atualizados
                final novoNome = serviceNameController.text;
                final novaDescricao = serviceDescriptionController.text;
                final novoHorario = serviceTimeController.text;
                final novoEndereco = serviceAddressController.text;
                final novaData = serviceDateController.text;
                // Agora, você pode fazer o que desejar com esses valores
                // Por exemplo, você pode enviá-los de volta para a página anterior
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
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
          title: const Text('Cancelar Serviço'),
          content: const Text('Tem certeza que deseja cancelar o serviço?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<Servicos>(context,listen: false).remove(widget.servico);
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/agenda');
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }
}