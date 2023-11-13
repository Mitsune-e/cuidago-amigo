import 'package:brasil_fields/brasil_fields.dart';
import 'package:cuidadoamigoapp/models/cliente.dart';
import 'package:cuidadoamigoapp/provider/Clientes.dart';
import 'package:flutter/material.dart';
import 'package:cuidadoamigoapp/models/Endereco.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:csc_picker/csc_picker.dart';

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
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _numeroController = TextEditingController();
  TextEditingController _complementoController = TextEditingController();
  var cidade ="";
  var estado = '';
  var estado_novo = "";
  var cidade_novo = "";
  List<String> cliente_enderecos = [];

  @override
  void initState() {
    super.initState();
    _loadData();

    User? user = _auth.currentUser;
    if (user != null) {
      _loadUserData(user.uid);
    }
  }

  
Future<void> _loadData() async {
  User? user = _auth.currentUser;
  if (user != null) {
    await _loadUserData(user.uid);
  }
}
  Future<void> _loadUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('Clientes').doc(userId).get();

      if (userDoc.exists) {
        setState(() {
          _nomeController.text = userDoc['name'] ?? '';
          _cpfController.text = userDoc['cpf'] ?? '';
          _emailController.text = userDoc['email'] ?? '';
          _telefoneController.text = userDoc['telefone'] ?? '';

          _enderecoController.text = userDoc['endereco'] ?? '';
          _numeroController.text = userDoc['numero'] ?? '';
          _complementoController.text = userDoc['complemento'] ?? '';
           cidade = userDoc['cidade'] ?? '';
           estado = userDoc['estado'] ?? '';
        });
      }
    } catch (e) {
      print('Erro ao carregar dados do Firestore: $e');
    }
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
            _buildEnderecoBox()
          ],
        ),
      ),
    );
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
              onPressed: () async {
                User? user = _auth.currentUser;

                await _updateUserData(user!.uid);

                _loadUserData(user.uid);

                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUserData(String userId) async {
    try {
      await _firestore.collection('Clientes').doc(userId).update({
        'name': _nomeController.text,
        'cpf': _cpfController.text,
        'email': _emailController.text,
        'telefone': _telefoneController.text,
        'estado': estado,
        'cidade': cidade,
        'endereco': _enderecoController.text,
        'numero':_numeroController.text,
        'complemento': _complementoController.text,

      });
    } catch (e) {
      print('Erro ao atualizar dados do usuário no Firestore: $e');
    }
  }

Widget _buildEnderecoBox() {
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
                'Endereço',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF73C9C9),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      _mostrarEditarEnderecoDialog();
                    },
                    child: Text(
                      'Editar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF73C9C9),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildInfoRow('Estado', estado),
          _buildInfoRow('Cidade', cidade),
          _buildInfoRow('Endereço', _enderecoController.text),
          _buildInfoRow('Número', _numeroController.text),
          _buildInfoRow('Complemento', _complementoController.text),
        ],
      ),
    );
  }

  void _mostrarEditarEnderecoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Editar Endereço'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CSCPicker(
                      currentCountry: "Brazil",
                      defaultCountry: CscCountry.Brazil,
                      currentState: estado,
                      currentCity: cidade,
                      disableCountry: true,
                      showCities: true,
                      showStates: true,
                      flagState: CountryFlag.DISABLE,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          style: BorderStyle.solid,
                        ),
                      ),
                      disabledDropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey[200],
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          style: BorderStyle.solid,
                        ),
                      ),
                      selectedItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      dropdownHeadingStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      dropdownItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      dropdownDialogRadius: 10.0,
                      searchBarRadius: 10.0,
                      onCountryChanged: (value) {
                        // Handle country change
                      },
                      onStateChanged: (value) {
                        setState(() {
                          estado_novo = value.toString();
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cidade_novo =  value.toString();
                        });
                      },
                    ),
                    TextFormField(
                      controller: _enderecoController,
                      decoration: InputDecoration(
                        labelText: 'Endereço',
                      ),
                    ),
                    TextFormField(
                      controller: _numeroController,
                      decoration: InputDecoration(
                        labelText: 'Número',
                      ),
                    ),
                    TextFormField(
                      controller: _complementoController,
                      decoration: InputDecoration(
                        labelText: 'Complemento',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                  if (estado_novo !="" && cidade_novo != ''){
                    estado = estado_novo;
                    cidade = cidade_novo;
                  }
                  
                  User? user = _auth.currentUser;

                  await _updateUserData(user!.uid);

                  _loadUserData(user.uid);

                  Navigator.of(context).pop();
                },
                  child: Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }


}
