import 'package:cuidadoamigoapp/views/CadastroCuidado.dart';
import 'package:cuidadoamigoapp/views/Perfil.dart';
import 'package:cuidadoamigoapp/views/RecuperarSenha.dart';
import 'package:cuidadoamigoapp/views/SolicitarCuidado1.dart';
import 'package:cuidadoamigoapp/views/SolicitarCuidador2.dart';
import 'package:cuidadoamigoapp/views/agenda.dart';
import 'package:cuidadoamigoapp/views/cadastro1.dart';
import 'package:cuidadoamigoapp/views/cadastro2.dart';
import 'package:cuidadoamigoapp/views/detalhamento.dart';
import 'package:cuidadoamigoapp/views/homeCuidador.dart';
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
      home: const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/cadastro1': (context) => const Cadastro1(),
        '/recuperarSenha': (context) => const RecuperarSenha(),
        '/homeIdoso': (context) => const HomeIdoso(),
        '/cadastro2': (context) => const Cadastro2(),
        '/cadastroPrestador': (context) => const CadastroPrestador(),
        '/perfil': (context) => const Perfil(),
        '/agenda': (context) => const Agenda(),
        "/homePrestador": (context) => const HomePrestador(),
        '/solicitarCuidador1': (context) => const SolicitarCuidado1(),
        '/solicitarCuidador2': (context) => const CuidadorInfoPage(),
      },
    );
  }
}
