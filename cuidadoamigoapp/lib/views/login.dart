import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

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
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    try {
      setState(() => loading = true);

      final emailText = email.text;
      final senhaText = senha.text;

      // Verificar se o e-mail está cadastrado como Cliente
      final clienteSnapshot = await FirebaseFirestore.instance
          .collection('Clientes')
          .where('email', isEqualTo: emailText)
          .get();

      // Verificar se o e-mail está cadastrado como Prestador
      final prestadorSnapshot = await FirebaseFirestore.instance
          .collection('Prestadores')
          .where('email', isEqualTo: emailText)
          .get();

      if (clienteSnapshot.docs.isNotEmpty) {
        // Autenticação com Firebase Authentication
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: emailText,
          password: senhaText,
        );

        if (userCredential.user != null) {
          // Autenticação bem-sucedida - redireciona para a próxima tela de cliente
          Navigator.of(context).pushReplacementNamed('/homeIdoso');
        } else {
          // Exiba uma mensagem de erro caso a autenticação falhe
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Erro de autenticação. Verifique seu email e senha.')),
          );
          setState(() => loading = false);
        }
      } else if (prestadorSnapshot.docs.isNotEmpty) {
        // Autenticação com Firebase Authentication
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: emailText,
          password: senhaText,
        );

        if (userCredential.user != null) {
          // Autenticação bem-sucedida - redireciona para a próxima tela de prestador
          Navigator.of(context).pushReplacementNamed('/homeCuidador');
        } else {
          // Exiba uma mensagem de erro caso a autenticação falhe
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Erro de autenticação. Verifique seu email e senha.')),
          );
          setState(() => loading = false);
        }
      } else {
        // Exiba uma mensagem se o e-mail não estiver cadastrado como cliente nem prestador
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('E-mail não cadastrado. Cadastre-se agora.')),
        );
        setState(() => loading = false);
      }
    } catch (e) {
      print('Erro de autenticação com Firebase Authentication: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erro de autenticação. Verifique seu email e senha.')),
      );
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child:
                    Image.asset('Assets/imagens/LOGO.png', fit: BoxFit.cover),
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

  Future<void> _showAccountTypeDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
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
                    Navigator.of(context)
                        .pushReplacementNamed('/cadastroPrestador');
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
}
