import 'package:cuidadoamigoapp/models/cliente.dart';
import 'package:cuidadoamigoapp/provider/Clientes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Cadastro1 extends StatefulWidget {
  Cadastro1({Key? key}) : super(key: key);

  @override
  State<Cadastro1> createState() => _Cadastro1State();
}

class _Cadastro1State extends State<Cadastro1> {
  final nome = TextEditingController();
  final email = TextEditingController();
  final fone = TextEditingController();
  final senha = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget _buildNextButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: email.text,
            password: senha.text,
          );

          final User? user = userCredential.user;
          if (user != null) {
            final uid = user.uid;

            final cliente = Cliente(
              id: Uuid().v5(Uuid.NAMESPACE_URL, uid),
              name: nome.text,
              email: email.text,
              telefone: fone.text,
              senha: senha.text,
              imagem: '',
            );

            Provider.of<Clientes>(context, listen: false).adiciona(cliente);
          }

          // Navegue para a próxima página (cadastro2)

          

          Navigator.of(context).pushReplacementNamed('/cadastro2');

        } catch (e) {
          print('Erro de criação de usuário no Firebase Authentication: $e');
        }
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
              onPressed: () {
                // Chame a função para prosseguir
                _buildNextButton(context);
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
            SizedBox(height: 20),
            _buildTextField(controller: nome, hintText: 'Nome', keyboardType: TextInputType.text),
            _buildTextField(controller: email, hintText: 'E-mail', keyboardType: TextInputType.emailAddress),
            _buildPhoneTextField(controller: fone),
            _buildPasswordField(controller: senha, hintText: 'Senha', labelText: 'Senha'),
            const SizedBox(height: 5),
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
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
      ));
    }
  }

  Widget _buildPhoneTextField({
    required TextEditingController controller,
  }) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        controller: controller,
        inputFormatters: [
          MaskTextInputFormatter(
            mask: '(##) #####-####',
            filter: {"#": RegExp(r'[0-9]')},
            type: MaskAutoCompletionType.lazy,
          ),
        ],
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: 'Telefone',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ));
    }
  

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
  }) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ));
    }
  