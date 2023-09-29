import 'package:cuidadoamigoapp/views/RecuperarSenha.dart';
import 'package:cuidadoamigoapp/views/cadastro1.dart';
import 'package:cuidadoamigoapp/views/login.dart';
import 'package:cuidadoamigoapp/views/homeIdoso.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.red),
      home: Login(),
      routes: {
        '/login': (context) => Login(),
        '/cadastro1': (context) => Cadastro1(),
        '/recuperarSenha': (context) => RecuperarSenha(),
        '/homeIdoso': (context) => HomeIdoso(),
      },
    );
  }
}



