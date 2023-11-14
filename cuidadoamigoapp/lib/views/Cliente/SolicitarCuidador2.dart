import 'package:cuidadoamigoapp/models/cliente.dart';
import 'package:cuidadoamigoapp/provider/Clientes.dart';
import 'package:cuidadoamigoapp/provider/servicos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/servico.dart';
import 'package:uuid/uuid.dart';

class CuidadorInfoPage extends StatefulWidget {
  const CuidadorInfoPage({Key? key}) : super(key: key);

  @override
  _CuidadorInfoPageState createState() => _CuidadorInfoPageState();
}

class _CuidadorInfoPageState extends State<CuidadorInfoPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> cuidadores = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  int currentIndex = 0;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadCuidadores();
  }

Future<void> _loadCuidadores() async {
  try {
    final prestadoresSnapshot = await _firestore.collection('Prestadores').get();
    print(prestadoresSnapshot.docs); // Adicione esta linha
    setState(() {
      cuidadores = prestadoresSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      isLoading = false;
    });
  } catch (e) {
    // Lidar com erros, como falta de conexão com a internet, aqui
    print('Erro ao carregar cuidadores: $e');
  }
}

  @override
  Widget build(BuildContext context) {
     final Map<String, dynamic> dataToPass = ModalRoute.of(context!)!.settings.arguments as Map<String, dynamic>;
     User? user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Cuidador'),
        backgroundColor: const Color(0xFF73C9C9),
        actions: [
          IconButton(
            onPressed: () {
              _mostrarFiltrosDialog(context);
            },
            icon: const Icon(Icons.filter_alt),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  if (currentIndex > 0) {
                    setState(() {
                      currentIndex--;
                    });
                  }
                } else if (details.primaryVelocity! < 0) {
                  if (currentIndex < cuidadores.length - 1) {
                    setState(() {
                      currentIndex++;
                    });
                  }
                }
              },
              child: Container(
                color: const Color(0xFF73C9C9),
                child: Center(
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Icon(
                            cuidadores[currentIndex]['foto'] ?? Icons.person,
                            size: 80.0,
                            color: const Color(0xFF73C9C9),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            cuidadores[currentIndex]['nome'] ?? 'Nome do Cuidador',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            cuidadores[currentIndex]['descricao'] ?? 'Descrição do Cuidador',
                            textAlign: TextAlign.center,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Informações do Cuidador:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (cuidadores[currentIndex]['topicos'] is List<String>)
                            for (String topico in cuidadores[currentIndex]['topicos'])
                              ListTile(
                                leading: const Icon(Icons.check),
                                title: Text(topico),
                              ),
                          const SizedBox(height: 20),
                         ElevatedButton(
                            onPressed: () async {
                              final cuidadorSelecionado = cuidadores[currentIndex];
                              final prestadorID = cuidadorSelecionado['id'];
                              print(dataToPass);

                              if (cuidadores.isNotEmpty && currentIndex < cuidadores.length) {
                                // Crie o serviço
                                final servico = Servico(
                                  id: Uuid().v1(),
                                  data: dataToPass['data'],
                                  horaInicio: dataToPass['horaInicio'],
                                  horaFim: dataToPass['horaFim'],
                                  endereco: dataToPass['endereco'],
                                  usuario: user!.uid,
                                  prestador: prestadorID,
                                  numero: dataToPass['numero'],
                                  complemento: dataToPass['complemento'],
                                  estado: dataToPass['estado'],
                                  cidade: dataToPass['cidade']

                                );
                               
                                // Use o provider para adicionar o serviço ao banco de dados
                                final servicosProvider = Servicos();
                                await servicosProvider.adiciona(servico);

                                // Atualize a lista de serviços do cliente
                                final clientesProvider = Clientes();
                                final clientes = await clientesProvider.caregar();
                                final clienteIndex = clientes.indexWhere((c) => c.id == user!.uid);

                                if (clienteIndex != -1) {
                                  clientes[clienteIndex].servicos.add(servico.id);
                                  await clientesProvider.adiciona(clientes[clienteIndex]);
                                } else {
                                  // Trate o caso em que o cliente não é encontrado (por exemplo, exibindo um erro)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Cliente não encontrado. Certifique-se de estar autenticado como cliente.'),
                                    ),
                                  );
                                }

                                // Adicione código para lidar com o sucesso do agendamento aqui
                                print('Serviço agendado com sucesso');
                              } else {
                                // Mostrar uma mensagem de erro ou fazer alguma outra ação
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Por favor, selecione um cuidador antes de finalizar o agendamento.'),
                                  ),
                                );
                              }
                            },
                            // ...

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF73C9C9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              'Finalizar Agendamento',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void _mostrarFiltrosDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtros'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Selecione os filtros desejados:'),
              CheckboxListTile(
                title: const Text('Filtro 1'),
                value: false, // Coloque o valor do filtro aqui
                onChanged: (bool? value) {
                  // Atualize o valor do filtro aqui
                },
              ),
              CheckboxListTile(
                title: const Text('Filtro 2'),
                value: false, // Coloque o valor do filtro aqui
                onChanged: (bool? value) {
                  // Atualize o valor do filtro aqui
                },
              ),
              // Adicione mais filtros conforme necessário
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: const Text('Aplicar'),
            ),
          ],
        );
      },
    );
  }
}