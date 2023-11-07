import 'package:cuidadoamigoapp/models/cliente.dart';
import 'package:cuidadoamigoapp/provider/Clientes.dart';
import 'package:cuidadoamigoapp/provider/Enderecos.dart';
import 'package:flutter/material.dart';
import 'package:cuidadoamigoapp/models/Endereco.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _cepController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _numeroController = TextEditingController();
  TextEditingController _complementoController = TextEditingController();
  List<String> cliente_enderecos = [];

  @override
  void initState() {
    super.initState();

    // Verifique se o usuário está autenticado
    User? user = _auth.currentUser;
    if (user != null) {
      // O usuário está autenticado, agora vamos carregar seus dados do Firestore
      _loadUserData(user.uid);
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      // Consulte o Firestore para obter os dados do cliente com o mesmo ID de usuário
      DocumentSnapshot userDoc = await _firestore.collection('Clientes').doc(userId).get();

      if (userDoc.exists) {
        // Dados encontrados, preencha os controladores de texto
        setState(() {
          _nomeController.text = userDoc['name'] ?? '';
          _cpfController.text = userDoc['cpf'] ?? '';
          _emailController.text = userDoc['email'] ?? '';
          _telefoneController.text = userDoc['telefone'] ?? '';
          cliente_enderecos = List<String>.from(userDoc['enderecos'] ?? []);
        });
      } else {
        // Não foram encontrados dados para o ID do usuário
      }
    } catch (e) {
      // Trate qualquer erro que possa ocorrer
      print('Erro ao carregar dados do Firestore: $e');
    }
  }
Future<void> _endEdit() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alerta!'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Nenhum endereço a se editar.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Conta'),
        backgroundColor: Color(0xFF73C9C9),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                // Adicione a lógica para editar a foto do perfil aqui
              },
              child: CircleAvatar(
                radius: 75,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildInfoBox(
              title: 'Dados Pessoais',
              buttonText: 'Editar',
              onButtonPressed: () {
                _mostrarEditarDialog(
                  'Dados Pessoais',
                  [
                    _nomeController,
                    _cpfController,
                    _emailController,
                    _telefoneController,
                  ],
                );
              },
              children: [
                _buildInfoRow('Nome', _nomeController.text),
                _buildInfoRow('CPF', _cpfController.text),
                _buildInfoRow('E-mail', _emailController.text),
                _buildInfoRow('Telefone', _telefoneController.text),
              ],
            ),
            SizedBox(height: 20),
            _buildInfoBox(
              title: 'Endereços',
              buttonText: 'Editar',
              onButtonPressed: () {
                if (_enderecosListView().isEmpty){
                  _endEdit();
                }                      
              },
              children: _enderecosListView(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _mostrarAdicionarEnderecoDialog();
              },
              child: Text('Adicionar Endereço'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _enderecosListView() {
    List<Widget> enderecoWidgets = [];

    for (var enderecoId in cliente_enderecos) {
      enderecoWidgets.add(
        FutureBuilder<DocumentSnapshot>(
          future: _firestore.collection('Enderecos').doc(enderecoId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('Erro ao carregar endereço.');
              }

                  return Column(
                    children: [
                      _buildInfoRow('CEP', _cepController.text),
                      _buildInfoRow('Endereço', _cepController.text),
                      _buildInfoRow('Número', _cepController.text),
                      _buildInfoRow('Complemento', _cepController.text),
                    ],
                  );               
            }

            return Text('Carregando endereço...');
          },
        ),
      );
    }

    return enderecoWidgets;
  }

  Widget _buildInfoBox({
    required String title,
    required String buttonText,
    required VoidCallback onButtonPressed,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF73C9C9),
                ),
              ),
              TextButton(
                onPressed: onButtonPressed,
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF73C9C9),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarEditarDialogEnd(String title, List<TextEditingController> controllers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar $title'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < controllers.length; i++)
                  TextFormField(
                    controller: controllers[i],
                    decoration: InputDecoration(
                      labelText: controllers[i].text,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Endereco end = Endereco(id: '', cep: _cepController.text, endereco: _enderecoController.text, numero: _numeroController.text, complemento: _complementoController.text);
                Provider.of<Enderecos>(context, listen: false).edita(end);  
                Navigator.of(context).pop();
              },
              child: Text('Salvar '),
            ),
          ],
        );
      },
    );
  }
  void _mostrarEditarDialog(String title, List<TextEditingController> controllers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar $title'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < controllers.length; i++)
                  TextFormField(
                    controller: controllers[i],
                    decoration: InputDecoration(
                      labelText: controllers[i].text,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Cliente c = Cliente(id: '', name: _nomeController.text, imagem: '', cpf: _cpfController.text, email: _emailController.text, senha: '', telefone: _telefoneController.text);
                Provider.of<Clientes>(context, listen: false).editar(c);  
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarAdicionarEnderecoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Endereço'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _cepController,
                  decoration: InputDecoration(labelText: 'CEP'),
                ),
                TextFormField(
                  controller: _enderecoController,
                  decoration: InputDecoration(labelText: 'Endereço'),
                ),
                TextFormField(
                  controller: _numeroController,
                  decoration: InputDecoration(labelText: 'Número'),
                ),
                TextFormField(
                  controller: _complementoController,
                  decoration: InputDecoration(labelText: 'Complemento'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {               
                Endereco endAdd = Endereco(id: '', cep: _cepController.text, endereco: _enderecoController.text, numero: _numeroController.text, complemento: _complementoController.text);
                Provider.of<Enderecos>(context, listen: false).adiciona(endAdd);               
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
