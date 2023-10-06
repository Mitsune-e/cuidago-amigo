import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
                  const Text(
                      'Selecione o tipo de conta que você deseja criar:'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para escolher "Usuário"
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
                      // Lógica para escolher "Cuidador"
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
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                inputFormatters: const [],
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/homeIdoso');
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
