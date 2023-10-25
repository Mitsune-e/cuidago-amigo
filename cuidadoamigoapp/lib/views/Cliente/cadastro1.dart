import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Cadastro1 extends StatefulWidget {
  Cadastro1({Key? key}) : super(key: key);

  @override
  State<Cadastro1> createState() => _Cadastro1State();
}

class _Cadastro1State extends State<Cadastro1> {
  final formKey = GlobalKey<FormState>();
  final nome = TextEditingController();
  final email = TextEditingController();
  final fone = TextEditingController();
  final codpf = TextEditingController();
  final datanasc = TextEditingController();
  final senha = TextEditingController();


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
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao Login.';
      }
    });
  }

  registrar() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().registrar(nome.text, email.text, fone.text, codpf.text, datanasc.text, senha.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
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
                Navigator.of(context).pushReplacementNamed('/login');
              },
              icon: Icon(Icons.arrow_back),
            ),
            
            Text('Informações Pessoais'),
            IconButton(
            onPressed: () {Navigator.of(context).pushReplacementNamed("/cadastro2");},
            icon: Icon(Icons.arrow_forward), // Ícone vazio à direita
          ),
  
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            _buildHeader(context),
            SizedBox(height: 20),
            _buildTextField(controller: nome, 'Nome', TextInputType.text, 20),
            SizedBox(height: 12),
            _buildCPFTextField(controller: codpf),
            SizedBox(height: 15),
            _buildTextField(controller: email, 'E-mail', TextInputType.emailAddress),
            SizedBox(height: 15),
            _buildPhoneTextField(controller: fone),
            SizedBox(height: 10),
            _buildTextField(controller: datanasc)
            SizedBox(height: 40),
            _buildPasswordField(controller: senha, 'Senha', 'Senha'),
            const SizedBox(height: 5),
            _buildPasswordField('Confirma Senha', 'Confirma Senha'),
            const SizedBox(height: 10),
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


  }
  Widget _buildTextField(
    String hintText,
    TextInputType keyboardType, [
    int? maxLength,
    String? initialValue,
  ]) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        initialValue: initialValue,
        inputFormatters: maxLength != null
            ? [LengthLimitingTextInputFormatter(maxLength)]
            : [],
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildDateTextField(){
    return SizedBox(
      width: 250,
      child: TextFormField(
        inputFormatters: [
          MaskTextInputFormatter(
            mask: '##/##/####',
            filter: {"#": RegExp(r'[0-9]')},
            type: MaskAutoCompletionType.lazy,
          )
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'CPF',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
  Widget _buildCPFTextField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        inputFormatters: [
          MaskTextInputFormatter(
            mask: '###.###.###-##',
            filter: {"#": RegExp(r'[0-9]')},
            type: MaskAutoCompletionType.lazy,
          )
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'CPF',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildPhoneTextField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        inputFormatters: [
          MaskTextInputFormatter(
            mask: '(##) #####-####',
            filter: {"#": RegExp(r'[0-9]')},
            type: MaskAutoCompletionType.lazy,
          )
        ],
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: 'Telefone',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hintText, String labelText) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/cadastro2');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(92, 198, 186, 100),
        shape: const StadiumBorder(),
      ),
      child: const Text(
        'Prosseguir',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
