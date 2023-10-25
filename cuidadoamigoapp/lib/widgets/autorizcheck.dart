import 'package:cuidadoamigoapp/views/Cliente/homeIdoso.dart';
import 'package:flutter/material.dart';
import 'package:cuidadoamigoapp/views/login.dart';
import 'package:cuidadoamigoapp/servicos/autorizacao.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null) {
      return Login();
    } else {
      return HomeIdoso();
    }
  }

  loading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}