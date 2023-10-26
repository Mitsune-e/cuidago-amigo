import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Cadastro2 extends StatefulWidget {
  Cadastro2({Key? key}) : super(key: key);

  @override
  State<Cadastro2> createState() => _Cadastro2State();
}

class _Cadastro2State extends State<Cadastro2> {
  final cep = TextEditingController();
  final comp = TextEditingController();
  final numb = TextEditingController();
  final pref = TextEditingController();

  bool isCad = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isCad = acao;
      if (isCad) {
        titulo = 'Parte 2 de seu cadastro';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao Login.';
      }
    });
  }

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
                Navigator.of(context).pushReplacementNamed('/cadastro1');
              },
              icon: Icon(Icons.arrow_back),
            ),
            Text('Informações de Endereço'),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/cadastro3');
              },
              icon: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(context),
            SizedBox(height: 20),
            _buildCEPTextField(controller: cep),
            SizedBox(height: 5),
            _buildTextField('Complemento', TextInputType.text, controller: comp),
            SizedBox(height: 5),
            _buildTextField('Número', TextInputType.number, controller: numb),
            SizedBox(height: 5),
            _buildTextField('Ponto de Referência', TextInputType.text, controller: pref),
            SizedBox(height: 40),
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('Assets/imagens/LOGO.png'),
      ],
    );
  }

  Widget _buildTextField(
    String hintText,
    TextInputType keyboardType, {
    TextEditingController? controller,
  }) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildCEPTextField({TextEditingController? controller}) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        controller: controller,
        inputFormatters: [
          MaskTextInputFormatter(
            mask: '##.###.###',
            filter: {"#": RegExp(r'[0-9]')},
            type: MaskAutoCompletionType.lazy,
          ),
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'CEP',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/cadastro3');
      },
      child: Text(
        'Prosseguir',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(92, 198, 186, 100),
        shape: StadiumBorder(),
      ),
    );
  }
}
