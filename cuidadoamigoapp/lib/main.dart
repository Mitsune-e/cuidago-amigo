import 'package:cuidadoamigoapp/provider/Clientes.dart';
import 'package:cuidadoamigoapp/provider/Enderecos.dart';
import 'package:cuidadoamigoapp/provider/Prestadores.dart';
import 'package:cuidadoamigoapp/provider/servicos.dart';
//import 'package:cuidadoamigoapp/views/Cliente/cadastro2.dart';
import 'package:cuidadoamigoapp/views/Prestador/CadastroCuidado.dart';
import 'package:cuidadoamigoapp/views/Cliente/Perfil.dart';
import 'package:cuidadoamigoapp/views/Prestador/Carteira.dart';
import 'package:cuidadoamigoapp/views/Prestador/perfilCuidado.dart';
import 'package:cuidadoamigoapp/views/RecuperarSenha.dart';
import 'package:cuidadoamigoapp/views/Cliente/SolicitarCuidado1.dart';
import 'package:cuidadoamigoapp/views/Cliente/SolicitarCuidador2.dart';
import 'package:cuidadoamigoapp/views/Cliente/agenda.dart';
import 'package:cuidadoamigoapp/views/Cliente/cadastro1.dart';
import 'package:cuidadoamigoapp/views/Prestador/homeCuidador.dart';
import 'package:cuidadoamigoapp/views/login.dart';
import 'package:cuidadoamigoapp/views/Cliente/homeIdoso.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Clientes()),
      ChangeNotifierProvider(create: (context) => Enderecos()),
      ChangeNotifierProvider(create: (context) => Prestadores()),
      ChangeNotifierProvider(create: (context) => Servicos()),
      // Outros providers, se houver
    ],
    child: const MyApp(),
  ));
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
        //'/cadastro2': (context) => Cadastro2(),
        '/recuperarSenha': (context) => const RecuperarSenha(),
        '/homeIdoso': (context) => const HomeIdoso(),
        '/cadastroPrestador': (context) => CadastroCuidado(),
        '/perfil': (context) => const Perfil(),
        '/agenda': (context) => Agenda(),
        "/homeCuidador": (context) => HomeCuidador(),
        '/solicitarCuidador1': (context) => SolicitarCuidado1(),
        '/solicitarCuidador2': (context) => CuidadorInfoPage(),
        '/carteira': (context) => Carteira(),
        '/perfilPrestador': (context) => PerfilCuidador(),
      },
    );
  }
}
