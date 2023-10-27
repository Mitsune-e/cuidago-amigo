import 'package:cuidadoamigoapp/views/Cliente/cadastro2.dart';
import 'package:cuidadoamigoapp/views/Prestador/CadastroCuidado.dart';
import 'package:cuidadoamigoapp/views/Cliente/Perfil.dart';
import 'package:cuidadoamigoapp/views/Prestador/Carteira.dart';
import 'package:cuidadoamigoapp/views/RecuperarSenha.dart';
import 'package:cuidadoamigoapp/views/Cliente/SolicitarCuidado1.dart';
import 'package:cuidadoamigoapp/views/Cliente/SolicitarCuidador2.dart';
import 'package:cuidadoamigoapp/views/Cliente/agenda.dart';
import 'package:cuidadoamigoapp/views/Cliente/cadastro1.dart';
import 'package:cuidadoamigoapp/views/Cliente/cadastro3.dart';

import 'package:cuidadoamigoapp/views/Prestador/homeCuidador.dart';
import 'package:cuidadoamigoapp/views/login.dart';
import 'package:cuidadoamigoapp/views/Cliente/homeIdoso.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.red),
      home:  Login(),
      routes: {
        '/login': (context) => Login(),
        '/cadastro1': (context) => Cadastro1(),
        '/cadastro2':(context) => Cadastro2(),
        '/cadastro3' :(context) => Cadastro3(),
        '/recuperarSenha': (context) => RecuperarSenha(),
        '/homeIdoso': (context) => HomeIdoso(),
        '/cadastroPrestador':(context) => CadastroPrestador(),
        '/perfil':(context) => Perfil(),
        '/agenda':(context) => Agenda(),
        "/homePrestador":(context) => HomePrestador(),
        '/solicitarCuidador1':(context) => SolicitarCuidado1(),
        '/solicitarCuidador2':(context) => CuidadorInfoPage(),
        '/carteira':(context) => Carteira(),
      },
    );
  }
}
