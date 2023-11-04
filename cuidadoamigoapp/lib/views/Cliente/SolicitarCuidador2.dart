import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CuidadorInfoPage extends StatefulWidget {
  const CuidadorInfoPage({Key? key}) : super(key: key);

  @override
  _CuidadorInfoPageState createState() => _CuidadorInfoPageState();
}

class _CuidadorInfoPageState extends State<CuidadorInfoPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> cuidadores = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCuidadores();
  }

  Future<void> _loadCuidadores() async {
    // Consulta o Firestore para obter os prestadores
    final prestadoresSnapshot = await _firestore.collection('Prestadores').get();
    if (prestadoresSnapshot.docs.isNotEmpty) {
      setState(() {
        cuidadores = prestadoresSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: GestureDetector(
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
                    // Adapte a renderização dos tópicos de acordo com seus dados
                    if (cuidadores[currentIndex]['topicos'] is List<String>)
                      for (String topico in cuidadores[currentIndex]['topicos'])
                        ListTile(
                          leading: const Icon(Icons.check),
                          title: Text(topico),
                        ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Adicione ação para finalizar o agendamento
                      },
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