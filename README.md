Implementar


import 'package:cuidadoamigoapp/provider/Clientes.dart';
import 'package:cuidadoamigoapp/provider/Enderecos.dart';
import 'package:flutter/material.dart';
import 'package:cuidadoamigoapp/models/Endereco.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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

  MaskTextInputFormatter mascaraCPF = MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });
  MaskTextInputFormatter mascaraTEL = MaskTextInputFormatter(mask: '(##) #####-####', filter: { "#": RegExp(r'[0-9]') });
  MaskTextInputFormatter mascaraCEP = MaskTextInputFormatter(mask: '#####-###', filter: { "#": RegExp(r'[0-9]') });

  @override
  void initState() {
    super.initState();

    User? user = _auth.currentUser;
    if (user != null) {
      _loadUserData(user.uid);
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
        cliente_enderecos = List<String>.from(userDoc['enderecos'] ?? []);
      });

      // Carregar detalhes dos endereços
      await _loadEnderecosDetails();

      updateMascaras();
    }
  } catch (e) {
    print('Erro ao carregar dados do Firestore: $e');
  }
}

Future<void> _loadEnderecosDetails() async {
  for (var enderecoId in cliente_enderecos) {
    try {
      DocumentSnapshot enderecoDoc = await _firestore.collection('Enderecos').doc(enderecoId).get();

      if (enderecoDoc.exists) {
        // Processar os detalhes do endereço aqui, se necessário
      }
    } catch (e) {
      print('Erro ao carregar detalhes do endereço: $e');
    }
  }
}

  Future<void> _endEdit() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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

  void updateMascaras() {
    _cpfController.text = mascaraCPF.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: _cpfController.text)).text;
    _telefoneController.text = mascaraTEL.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: _telefoneController.text)).text;
    _cepController.text = mascaraCEP.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: _cepController.text)).text;
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
              children: 
              [
                _buildInfoRow('Nome', _nomeController.text),
                _buildInfoRow('CPF', _cpfController.text),
                _buildInfoRow('E-mail', _emailController.text),
                _buildInfoRow('Telefone', _telefoneController.text),
              ],
            ),
            SizedBox(height: 20),
            for (var enderecoId in cliente_enderecos)
              _buildEnderecoBox(enderecoId),
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

Widget _buildEnderecoBox(String enderecoId) {
  return FutureBuilder<DocumentSnapshot>(
    future: _firestore.collection('Enderecos').doc(enderecoId).get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Se ainda estiver carregando os dados, você pode exibir um indicador de carregamento
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        // Se ocorrer um erro durante o carregamento, exiba uma mensagem de erro
        return Text('Erro ao carregar endereço: ${snapshot.error}');
      } else if (!snapshot.hasData || !snapshot.data!.exists) {
        // Não exiba nada se os dados não existirem
        return Container();
      } else {
        // Os dados foram carregados com sucesso
        Map<String, dynamic>? enderecoData = snapshot.data?.data() as Map<String, dynamic>?;

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
                          _mostrarEditarDialogEnd(
                            'Endereço',
                            [
                              _cepController,
                              _enderecoController,
                              _numeroController,
                              _complementoController,
                            ],
                          );
                        },
                        child: Text(
                          'Editar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF73C9C9),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _mostrarExcluirEnderecoDialog(enderecoId);
                        },
                        child: Text(
                          'Excluir',
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
              _buildInfoRow('CEP', enderecoData?['cep'] ?? ''),
              _buildInfoRow('Endereço', enderecoData?['endereco'] ?? ''),
              _buildInfoRow('Número', enderecoData?['numero'] ?? ''),
              _buildInfoRow('Complemento', enderecoData?['complemento'] ?? ''),
            ],
          ),
        );
      }
    },
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
        'endereco': cliente_enderecos,
      });
    } catch (e) {
      print('Erro ao atualizar dados do usuário no Firestore: $e');
    }
  }
void _mostrarExcluirEnderecoDialog(String enderecoId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Excluir Endereço'),
        content: const Text('Tem certeza que deseja excluir este endereço?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              User? user = _auth.currentUser;

              // Remova o ID do endereço da lista de endereços do cliente no front-end
              setState(() {
                cliente_enderecos.remove(enderecoId);
              });

              // Atualize os dados do cliente no Firestore
              await _updateUserData(user!.uid);

              // Remova o endereço do provedor de endereços
              Provider.of<Enderecos>(context, listen: false).removeById(enderecoId);

              Navigator.of(context).pop();
            },
            child: Text('Excluir'),
          ),
        ],
      );
    },
  );
}
void _mostrarAdicionarEnderecoDialog() {
  print("Iniciando _mostrarAdicionarEnderecoDialog");

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
            onPressed: () async {
              try {
                User? user = _auth.currentUser;
                final clientesProvider = Clientes();
                final clientes = await clientesProvider.caregar();
                final clienteIndex = clientes.indexWhere((c) => c.id == user!.uid);

                // Criar um novo endereço
                Endereco endAdd = Endereco(
                  id: Uuid().v1(),
                  cep: _cepController.text,
                  endereco: _enderecoController.text,
                  numero: _numeroController.text,
                  complemento: _complementoController.text,
                );

                print("Dados do endereço a adicionar: $endAdd");

                // Verificar se o endereço já existe
                List<String>? enderecosDoCliente = clientes[clienteIndex].enderecos;
                if (enderecosDoCliente != null && !(_enderecoJaExiste(enderecosDoCliente, endAdd) == true)) {
                  // Adicionar o endereço se não existir
                  
                  

                  // Atualizar o estado para reconstruir a interface do usuário
                  setState(() {
                    // Atualizar o estado para reconstruir a interface do usuário
                    Provider.of<Enderecos>(context, listen: false).adiciona(endAdd);
                    clientes[clienteIndex].enderecos.add(endAdd.id);
                    clientesProvider.adiciona(clientes[clienteIndex]);
                  });

                  // Fechar o diálogo
                  Navigator.of(context).pop();

                  // Chamar o método _loadUserData para atualizar a página
                  await _loadUserData(user!.uid);
                } else {
                  // Mostrar alerta se o endereço já existir
                  _mostrarAlertaEnderecoExistente();
                }
              } catch (e) {
                print('Erro ao adicionar endereço: $e');
              }
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


void _mostrarAlertaEnderecoExistente() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Endereço Existente'),
        content: const Text('Este endereço já foi adicionado.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<bool> _enderecoJaExiste(List<String> enderecosIds, Endereco novoEndereco) async {
  for (String enderecoId in enderecosIds) {
    try {
      DocumentSnapshot enderecoSnapshot = await _firestore.collection('Enderecos').doc(enderecoId).get();

      if (enderecoSnapshot.exists) {
        Map<String, dynamic> enderecoData = enderecoSnapshot.data() as Map<String, dynamic>;

        if (_mesmoEndereco(enderecoData, novoEndereco)) {
          return true; // Endereço já existe
        }
      }
    } catch (e) {
      print('Erro ao verificar endereço: $e');
    }
  }
  return false; // Endereço não existe
}



bool _mesmoEndereco(Map<String, dynamic>? enderecoData, Endereco novoEndereco) {
  return enderecoData != null &&
      enderecoData['cep'] == novoEndereco.cep &&
      enderecoData['endereco'] == novoEndereco.endereco &&
      enderecoData['numero'] == novoEndereco.numero &&
      enderecoData['complemento'] == novoEndereco.complemento;
}





}
