import 'package:flutter/material.dart';

class Cadastro3 extends StatefulWidget {
  const Cadastro3({Key? key}) : super(key: key);

  @override
  State<Cadastro3> createState() => _Cadastro3State();
}

class _Cadastro3State extends State<Cadastro3> {
  final String? respostaPergunta1;
  final String? respostaPergunta2;
  final String? respostaPergunta3;

  // Opções para os DropdownButtonFormField
  final List<String> movimentacaoOptions = [
    "Não necessito de Ajuda",
    "Necessito de Ajuda",
    "Utilizo andador",
    "Utilizo Cadeira de Rodas",
    "Acamado",
  ];

  final List<String> alimentacaoOptions = ["Via Oral", "Via Sonda"];

  final List<String> doencaOptions = ["Sim", "Não"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF73C9C9),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/cadastro2');
              },
              icon: Icon(Icons.arrow_back),
            ),
            Text('Informações de Saúde'),
             IconButton(
            onPressed: () {Navigator.of(context).pushReplacementNamed('/homeIdoso');},
            icon: Icon(Icons.arrow_forward), // Ícone vazio à direita
          ),
  
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

           
            Center(
              child: Image.asset('Assets/imagens/LOGO.png'),
            ),
            SizedBox(height: 20),
            Text(
              "Como é sua Movimentação?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              value: respostaPergunta1,
              onChanged: (value) {
                setState(() {
                  respostaPergunta1 = value;
                });
              },
              items: movimentacaoOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              "Como é sua Alimentação?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              value: respostaPergunta2,
              onChanged: (value) {
                setState(() {
                  respostaPergunta2 = value;
                });
              },
              items: alimentacaoOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              "Existe alguma doença crônica?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              value: respostaPergunta3,
              onChanged: (value) {
                setState(() {
                  respostaPergunta3 = value;
                });
              },
              items: doencaOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/homeIdoso');
              },
              child: Text(
                'Finalizar',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(92, 198, 186, 100),
                shape: StadiumBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
