import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Cadastro1 extends StatelessWidget {
  const Cadastro1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Row(
            children: [
             IconButton(onPressed: (){Navigator.of(context).pushReplacementNamed('/login');}, icon: Icon(Icons.arrow_back)), 
             SizedBox(width: 48,),
             Image.asset('Assets/imagens/LOGO.png'), 
            ],
          ),
          
          
          SizedBox(
                  height: 20,
                ),
          TextFormField(
            inputFormatters: [LengthLimitingTextInputFormatter(20),],
            keyboardType: TextInputType.text,
            decoration:InputDecoration(
              labelText:  'NOME',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
           )
          ),
          SizedBox(
                  height: 5,
                ),
          TextFormField( 
            inputFormatters: [
                    MaskTextInputFormatter(
                        mask: '###.###.###-##',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy)
                  ],
            keyboardType: TextInputType.number,
            decoration:InputDecoration(
              labelText:  'CPF',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
           )
           ),
           SizedBox(
                  height: 5,
                ),
          TextFormField( 
            keyboardType: TextInputType.emailAddress,
            decoration:InputDecoration(
              labelText:  'E-mail',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
           )
           ),
           SizedBox(
                  height: 5,
                ),
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
                  height: 5,
                ),
          TextFormField(
              inputFormatters: [
                    MaskTextInputFormatter(
                        mask: '##.###.###',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy)
                  ], 
            keyboardType: TextInputType.number,
            decoration:InputDecoration(
              labelText:  'Cep',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
           )),
          SizedBox(
                  height: 40,
                ),
          TextFormField(
            obscureText: true,  
            decoration:InputDecoration(
              labelText:  'Senha',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
           )),
          SizedBox(
                  height: 5,
                ),
           TextFormField(
            obscureText: true, 
            decoration:InputDecoration(
              labelText:  'Confirma Senha',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
           )),
           SizedBox(
                  height: 10,
                ),
            ElevatedButton(onPressed:(){}, child: Text('Prosseguir',style: TextStyle(color: Colors.white,)),
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(92, 198, 186, 100),
              shape:  StadiumBorder()
            ),
            ),

          ElevatedButton(onPressed:(){}, child: Text('Trabalhe conosco',style: TextStyle(color: Colors.white,)),
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(92, 198, 186, 100),
              shape: StadiumBorder()
            ),
            
            )
          ],
      ),
    ),
    );
  }
}