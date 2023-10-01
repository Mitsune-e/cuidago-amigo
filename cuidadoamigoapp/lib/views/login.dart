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
            title: Text('Escolha o tipo de conta'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Selecione o tipo de conta que você deseja criar:'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para escolher "Usuário"
                      Navigator.of(context).pushReplacementNamed('/cadastro1');
                    },
                    child: Text('Usuário'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(92, 198, 186, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para escolher "Cuidador"
                      Navigator.of(context).pushReplacementNamed('/cadastroPrestador');
                    },
                    child: Text('Cuidador'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(92, 198, 186, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Sair'),
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
          padding: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 400,
                child: Image.asset('Assets/imagens/LOGO.png', fit: BoxFit.cover),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                inputFormatters: [],
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
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
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/recuperarSenha');
                },
                child: Text(
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
                child: Text(
                  'Não tenho uma conta',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/homeIdoso');
                },
                child: Text(
                  'Logar',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(92, 198, 186, 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}