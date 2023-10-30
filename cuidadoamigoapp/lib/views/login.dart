import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();

  bool isLogin = true;
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
      isLogin = acao;
      if (isLogin) {
        titulo = 'Bem vindo';
        actionButton = 'Login';
        toggleButton = 'Ainda não tem conta? Cadastre-se agora.';
      }
    });
  }

  Future<void> login() async {
    setState(() => loading = true);
    final emailText = email.text;
    final senhaText = senha.text;

    // Consulta Firestore para encontrar um documento com o email e senha correspondentes
    final clienteDocs = await FirebaseFirestore.instance
        .collection('Clientes')
        .where('email', isEqualTo: emailText)
        .where('senha', isEqualTo: senhaText)
        .get();

    if (clienteDocs.docs.isNotEmpty) {
      // Autenticação bem-sucedida - redireciona para a próxima tela
      Navigator.of(context).pushReplacementNamed('/homeIdoso');
    } else {
      // Exiba uma mensagem de erro caso a autenticação falhe
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de autenticação')),
      );
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _showAccountTypeDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // Evita fechar o diálogo ao tocar fora
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Escolha o tipo de conta'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text('Selecione o tipo de conta que você deseja criar:'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/cadastro1');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(92, 198, 186, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Usuário'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/cadastroPrestador');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(92, 198, 186, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Cuidador'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Sair'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 400,
                child: Image.asset('Assets/imagens/LOGO.png', fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              TextFormField(
                inputFormatters: const [],
                keyboardType: TextInputType.emailAddress,
                controller: email,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                controller: senha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/recuperarSenha');
                },
                child: const Text(
                  'Esqueci minha senha',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _showAccountTypeDialog(context);
                },
                child: const Text(
                  'Não tenho uma conta',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(92, 198, 186, 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Logar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
