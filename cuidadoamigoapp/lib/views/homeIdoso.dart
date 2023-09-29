import 'package:flutter/material.dart';

class HomeIdoso extends StatelessWidget {
  const HomeIdoso({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF73C9C9),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: Icon(Icons.person), 
          ),
          Spacer(), 
          IconButton(
            onPressed: () {Navigator.of(context).pushReplacementNamed('/login');},
            icon: Icon(Icons.home),
          ),
          Spacer(), 
          IconButton(
            onPressed: () {
            },
            icon: Icon(Icons.list),
          ),          
        ],
      ),
      body: Center(
        child:Padding(
          padding: EdgeInsets.only(bottom:175.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'Assets/imagens/LOGO.png',
                width:300,
                height:300,
              ),
              SizedBox(width: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSquare(context, 'Enfermeira(o)', 'Assets/imagens/enfermeira.png',(){
                    Navigator.of(context).pushNamed('/pedirEnfermeiro');
                  }),
                  SizedBox(width: 20),
                  _buildSquare(context, 'Cuidador ou Passeador', 'Assets/imagens/cuidador.png',(){
                    Navigator.of(context).pushNamed('/pedirCuidador');
                  }),
              ],
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildSquare(
      BuildContext context, String title, String imagePath, VoidCallback onPressed) {
    return GestureDetector(
      onTap: () {             //Aqui vai redirecionar pro
      },
      child: Container(
        width: 150,
        height: 150,
        color: Color(0xFF73C9C9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 80, 
              height: 80, 
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
