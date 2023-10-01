import 'package:flutter/material.dart';

class CuidadorInfoPage extends StatefulWidget {
  const CuidadorInfoPage({Key? key}) : super(key: key);

  @override
  _CuidadorInfoPageState createState() => _CuidadorInfoPageState();
}

class _CuidadorInfoPageState extends State<CuidadorInfoPage> {
  // Lista de informações de cuidadores (para demonstração)
  final List<Map<String, dynamic>> cuidadores = [
    {
      'nome': 'Cuidador 1',
      'descricao':
          'Descrição do Cuidador 1. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eget dui et quam tincidunt condimentum.',
      'foto': Icons.person, // Altere para a foto do cuidador
      'topicos': ['Experiência', 'Especializações', 'Disponibilidade'],
    },
    {
      'nome': 'Cuidador 2',
      'descricao':
          'Descrição do Cuidador 2. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eget dui et quam tincidunt condimentum.',
      'foto': Icons.person, // Altere para a foto do cuidador
      'topicos': ['Experiência', 'Especializações', 'Disponibilidade'],
    },
    // Adicione mais informações de cuidadores conforme necessário
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Cuidador'),
        backgroundColor: Color(0xFF73C9C9),
        actions: [
          IconButton(
            onPressed: () {
              // Adicione ação para abrir o filtro
            },
            icon: Icon(Icons.filter_alt),
          ),
        ],
      ),
      body: GestureDetector(
        // Detecta gestos de deslizar para a esquerda e direita
        onHorizontalDragEnd: (details) {
          // Verifica a direção do gesto
          if (details.primaryVelocity! > 0) {
            // Deslizar para a direita
            if (currentIndex > 0) {
              setState(() {
                currentIndex--;
              });
            }
          } else if (details.primaryVelocity! < 0) {
            // Deslizar para a esquerda
            if (currentIndex < cuidadores.length - 1) {
              setState(() {
                currentIndex++;
              });
            }
          }
        },
        child: Container(
          color: Color(0xFF73C9C9),
          child: Center(
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Foto do cuidador (substituir pelo cuidador real)
                    Icon(
                      cuidadores[currentIndex]['foto'],
                      size: 80.0,
                      color: Color(0xFF73C9C9),
                    ),
                    SizedBox(height: 20),
                    Text(
                      cuidadores[currentIndex]['nome'],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      cuidadores[currentIndex]['descricao'],
                      textAlign: TextAlign.center,
                      maxLines: 5, // Limite o número de linhas para 5
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Informações do Cuidador:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Lista de tópicos com informações do cuidador
                    for (String topico in cuidadores[currentIndex]['topicos'])
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text(topico),
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Adicione ação para finalizar o agendamento
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF73C9C9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
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
}
