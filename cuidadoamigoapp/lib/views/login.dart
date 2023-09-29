import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
          SingleChildScrollView(
            child: Padding(
            padding: new EdgeInsets.only(top:150.0),
            child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                SizedBox(
                  height: 200,
                  width:400 ,
                  child: Image.asset('Assets/imagens/LOGO.png',fit:BoxFit.cover,)),
                TextFormField( 
                    inputFormatters: [
                          MaskTextInputFormatter(
                              mask: '#####-####',
                              filter: {"#": RegExp(r'[0-9]')},
                              type: MaskAutoCompletionType.lazy)
                        ],
                  keyboardType: TextInputType.phone,
                  decoration:InputDecoration(
                    labelText:  'Telefone',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                 )),
                SizedBox(
                  height: 10,
                ),
                 TextFormField(
                  obscureText: true,  
                  decoration:InputDecoration(
                    labelText:  'Senha',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                 )),
                
                TextButton(onPressed: (){Navigator.of(context).pushNamed('/recuperarSenha');}, child: Text('Esqueci minha senha')),
                
                 ElevatedButton(onPressed:(){Navigator.of(context).pushReplacementNamed('/homeIdoso');}, child: Text('Logar',style: TextStyle(color: Colors.white,)),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(92, 198, 186, 100),
                    shape:  StadiumBorder()
                  ),
                  ),
             SizedBox(height: 100,) ,
            TextButton(onPressed: (){Navigator.of(context).pushReplacementNamed('/cadastro1');}, child: Text('Não tenho uma conta')),
             ],
            ),
                  ),
          ),
    );
  }
}