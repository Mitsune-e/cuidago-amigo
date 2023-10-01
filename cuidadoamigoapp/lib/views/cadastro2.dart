import 'package:flutter/material.dart';

class Cadastro2 extends StatefulWidget {
  const Cadastro2({Key? key}) : super(key: key);

  @override
  State<Cadastro2> createState() => _Cadastro2State();
}

class _Cadastro2State extends State<Cadastro2> {
  String? respostaPergunta1 = "";
  String? respostaPergunta2 = "";
  String? respostaPergunta3 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/cadastro1');
              },
              icon: Icon(Icons.arrow_back),
            ),
            SizedBox(height: 20),
            Center(
              child: Image.asset('Assets/imagens/LOGO.png'),
            ),
            SizedBox(height: 20),
            Text(
              "Como é sua Movimentação?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  title: Text("Não necessito de Ajuda"),
                  value: "Não necessito de Ajuda",
                  groupValue: respostaPergunta1,
                  onChanged: (value) {
                    setState(() {
                      respostaPergunta1 = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text("Necessito de Ajuda"),
                  value: "Necessito de Ajuda",
                  groupValue: respostaPergunta1,
                  onChanged: (value) {
                    setState(() {
                      respostaPergunta1 = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text("Utilizo andador"),
                  value: "Utilizo andador",
                  groupValue: respostaPergunta1,
                  onChanged: (value) {
                    setState(() {
                      respostaPergunta1 = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text("Utilizo Cadeira de Rodas"),
                  value: "Utilizo Cadeira de Rodas",
                  groupValue: respostaPergunta1,
                  onChanged: (value) {
                    setState(() {
                      respostaPergunta1 = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text("Acamado"),
                  value: "Acamao",
                  groupValue: respostaPergunta1,
                  onChanged: (value) {
                    setState(() {
                      respostaPergunta1 = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Como é sua Alimentação?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  title: Text("Via Oral"),
                  value: "Via Oral",
                  groupValue: respostaPergunta2,
                  onChanged: (value) {
                    setState(() {
                      respostaPergunta2 = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text("Via Sonda"),
                  value: "Via Sonda",
                  groupValue: respostaPergunta2,
                  onChanged: (value) {
                    setState(() {
                      respostaPergunta2 = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Existe alguma doença crônica?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  title: Text("Sim"),
                  value: "Sim",
                  groupValue: respostaPergunta3,
                  onChanged: (value) {
                    setState(() {
                      respostaPergunta3 = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text("Não"),
                  value: "Não",
                  groupValue: respostaPergunta3,
                  onChanged: (value) {
                    setState(() {
                      respostaPergunta3 = value;
                    });
                  },
                ),
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
          ],
        ),
      ),
    );
  }
}