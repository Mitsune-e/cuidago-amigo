import 'package:cuidadoamigoapp/models/Prestador.dart';
import 'package:cuidadoamigoapp/models/Servico.dart';
import 'package:cuidadoamigoapp/provider/Prestadores.dart';
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
  late String servicoId;
  Prestador? prestador;
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController serviceDescriptionController = TextEditingController();
  TextEditingController serviceTimeController = TextEditingController();
  TextEditingController serviceAddressController = TextEditingController();
  TextEditingController serviceDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    servicoId = widget.servico.id;
    _carregarPrestadorSync();
    serviceTimeController.text = widget.servico.horaInicio;
    serviceAddressController.text = widget.servico.endereco;
    serviceDateController.text = widget.servico.data;
  }

void _carregarPrestadorSync() {
  prestador = Provider.of<Prestadores>(context, listen: false)
      .loadClienteByIdSync(widget.servico.prestador);

  if (prestador != null) {
    serviceNameController.text = prestador!.name;
  } else {
    print('Prestador não encontrado');
  }
}

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xFF73C9C9),
      title: const Text('Detalhes do Serviço'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pushNamed("/agenda");
        },
      ),
    ),
   body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: FutureBuilder<Prestador?>(
      future: Provider.of<Prestadores>(context).loadClienteById(widget.servico.prestador),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Se estiver carregando, você pode exibir um widget de carregamento ou nada.
          return Container();
        } else if (snapshot.hasError) {
          // Se ocorrer um erro, você pode tratá-lo de acordo.
          return Text('Erro: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // Se as informações estiverem prontas, construa a interface do usuário.
          prestador = snapshot.data!;
          serviceNameController.text = prestador!.name;

            return SingleChildScrollView(
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
               const SizedBox(height: 20),
              _buildSectionTitle('Informações do Prestador'),
              if (prestador != null) ...[
                _buildPrestadorInfo('Nome', prestador!.name),
                _buildPrestadorInfo('Email', prestador!.email),
                // Adicione mais informações do prestador conforme necessário
              ] else ...[
                Text('Prestador não encontrado'),
              ],
              _buildSectionTitle('Detalhes do Serviço'),
              Text(
                'Horario:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '${widget.servico.horaInicio} - ${widget.servico.horaFim}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              _buildServiceInfo('Endereço', widget.servico.endereco),
              _buildServiceInfo('Data', widget.servico.data),
             _buildServiceInfo('Valor', 'R\$ ${double.parse(widget.servico.valor).toStringAsFixed(2)}'),
              const SizedBox(height: 20),
             if (!widget.servico.finalizada)
            ElevatedButton(
              onPressed: () {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _mostrarCancelarServicoDialog(context);
                });
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
      );} else {
            // Se as informações não estiverem disponíveis, você pode tratar isso de acordo.
            return Text('Prestador não encontrado');
          }
        },
      ),
    ),
  );
}

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildServiceInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPrestadorInfo(String label, String value) {
    return _buildServiceInfo(label, value);
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
                Provider.of<Servicos>(context, listen: false).remove(widget.servico);
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
