import 'package:cuidadoamigoapp/provider/Clientes.dart';
import 'package:cuidadoamigoapp/provider/Prestadores.dart';
import 'package:cuidadoamigoapp/provider/servicos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/Servico.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CuidadorInfoPage extends StatefulWidget {
  const CuidadorInfoPage({super.key});

  @override
  _CuidadorInfoPageState createState() => _CuidadorInfoPageState();
}

class _CuidadorInfoPageState extends State<CuidadorInfoPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> cuidadores = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int currentIndex = 0;
  bool isLoading = true;
  String navegacaoInstrucao = "";
  late String qrCodeData;
  bool filtroCarro = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCuidadores();
  }

  Future<void> _loadCuidadores() async {
    final Map<String, dynamic> dataToPass =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    try {
      User? user = _auth.currentUser;
      final clienteSnapshot =
          await _firestore.collection('Clientes').doc(user!.uid).get();

      if (clienteSnapshot.exists) {
        final clienteData = clienteSnapshot.data() as Map<String, dynamic>;

        QuerySnapshot prestadoresSnapshot;
        if (filtroCarro) {
          // Se o filtroCarro estiver habilitado, filtre também pelo carro
          prestadoresSnapshot = await _firestore
              .collection('Prestadores')
              .where('estado', isEqualTo: dataToPass['estado'])
              .where('cidade', isEqualTo: dataToPass['cidade'])
              .where('carro', isEqualTo: true)
              .get();
        } else {
          prestadoresSnapshot = await _firestore
              .collection('Prestadores')
              .where('estado', isEqualTo: dataToPass['estado'])
              .where('cidade', isEqualTo: dataToPass['cidade'])
              .get();
        }

        if (prestadoresSnapshot.size > 0) {
          setState(() {
            cuidadores = prestadoresSnapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
          });
        }
      }
    } catch (e) {
      print('Erro ao carregar cuidadores: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> dataToPass =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
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
          : cuidadores.isEmpty
              ? Center(
                  child: Text(
                      'Nenhum cuidador disponível na sua região no momento.'),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      if (currentIndex > 0) {
                                        setState(() {
                                          currentIndex--;
                                        });
                                      }
                                    },
                                  ),
                                  Text(navegacaoInstrucao),
                                  IconButton(
                                    icon: Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      if (currentIndex <
                                          cuidadores.length - 1) {
                                        setState(() {
                                          currentIndex++;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    cuidadores[currentIndex]['foto'] ??
                                        Icons.person,
                                    size: 80.0,
                                    color: const Color(0xFF73C9C9),
                                  ),
                                  cuidadores[currentIndex]['carro'] == true
                                      ? const Icon(Icons.directions_car,
                                          color: Colors.green)
                                      : Row(
                                          children: [
                                            const Icon(Icons.directions_car),
                                            const SizedBox(width: 5),
                                            const Icon(Icons.clear,
                                                color: Colors.red),
                                          ],
                                        ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                cuidadores[currentIndex]['name'] ??
                                    'Nome do Cuidador',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Descrição:'),
                              Text(
                                cuidadores[currentIndex]['descricao'] ??
                                    'Descrição do Cuidador',
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
                              RatingBar.builder(
                                initialRating: cuidadores[currentIndex]
                                        ['avaliacao'] ??
                                    0.0,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  // Trate a atualização da avaliação, se necessário
                                },
                              ),
                              const SizedBox(height: 20),
                              if (cuidadores[currentIndex]['topicos']
                                  is List<String>)
                                for (String topico in cuidadores[currentIndex]
                                    ['topicos'])
                                  ListTile(
                                    leading: const Icon(Icons.check),
                                    title: Text(topico),
                                  ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  final cuidadorSelecionado =
                                      cuidadores[currentIndex];
                                  final prestadorID = cuidadorSelecionado['id'];

                                  if (cuidadores.isNotEmpty &&
                                      currentIndex < cuidadores.length) {
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
                                      cidade: dataToPass['cidade'],
                                      valor: dataToPass['valor'].toString(),
                                    );

                                    // Use o provider para adicionar o serviço ao banco de dados
                                    final servicosProvider = Servicos();
                                    servicosProvider.adiciona(servico);

                                    // Atualize a lista de serviços do cliente
                                    final clientesProvider = Clientes();
                                    final clientes =
                                        await clientesProvider.caregar();
                                    final clienteIndex = clientes
                                        .indexWhere((c) => c.id == user.uid);

                                    if (clienteIndex != -1) {
                                      clientes[clienteIndex]
                                          .servicos
                                          .add(servico.id);
                                      await clientesProvider
                                          .adiciona(clientes[clienteIndex]);
                                    } else {
                                      // Trate o caso em que o cliente não é encontrado (por exemplo, exibindo um erro)
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Cliente não encontrado. Certifique-se de estar autenticado como cliente.'),
                                        ),
                                      );
                                    }

                                    //Atualizar a lista de servicos do pestador

                                    final prestadoresProvider = Prestadores();
                                    final prestador = await prestadoresProvider
                                        .loadClienteById(prestadorID);
                                    prestador!.servicos!.add(servico.id);
                                    prestador.saldo += dataToPass['valor'];

                                    await prestadoresProvider
                                        .adiciona(prestador);
                                    print(prestador.id);

                                    qrCodeData = 'ServiçoID:${servico.id}';
                                    _mostrarQRCodeDialog(context);
                                    // Adicione código para lidar com o sucesso do agendamento aqui
                                    print('Serviço agendado com sucesso');
                                    //Navigator.of(context).pushNamed('/homeIdoso');

                                    // Adicione a concatenação ao atributo datas
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
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filtros'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selecione os filtros desejados:'),
                  Row(
                    children: [
                      Checkbox(
                        value: filtroCarro,
                        onChanged: (value) {
                          setState(() {
                            filtroCarro = value!;
                          });
                        },
                      ),
                      const Text('Prestador com Carro'),
                    ],
                  ),
                  // Adicione mais filtros conforme necessário
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    _aplicarFiltros();
                    Navigator.of(context).pop(); // Fechar o diálogo
                  },
                  child: const Text('Aplicar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _limparFiltros();
                    Navigator.of(context).pop(); // Fechar o diálogo
                  },
                  child: const Text('Limpar Filtros'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _mostrarQRCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code do Agendamento'),
          content: SizedBox(
            width: 200.0, // Set a fixed width
            height: 200.0, // Set a fixed height
            child: QrImageView(
              data: qrCodeData ?? '', // Ensure qrCodeData is not null
              version: QrVersions.auto,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/homeIdoso'); // Close the dialog
              },
              child: const Text('Concluir'),
            ),
          ],
        );
      },
    );
  }

  void _aplicarFiltros() {
    _loadCuidadores();
  }

  void _limparFiltros() {
    setState(() {
      filtroCarro = false;
    });
    _loadCuidadores();
  }
}
