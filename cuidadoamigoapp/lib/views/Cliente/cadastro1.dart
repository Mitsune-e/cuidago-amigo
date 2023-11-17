import 'dart:io';
import 'package:cuidadoamigoapp/models/Endereco.dart';
import 'package:cuidadoamigoapp/models/cliente.dart';
import 'package:cuidadoamigoapp/provider/Clientes.dart';
import 'package:cuidadoamigoapp/provider/Enderecos.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import 'package:csc_picker/csc_picker.dart';


class Cadastro1 extends StatefulWidget {
  Cadastro1({Key? key}) : super(key: key);

  @override
  State<Cadastro1> createState() => _Cadastro1State();
}

class _Cadastro1State extends State<Cadastro1> {
  final nome = TextEditingController();
  final email = TextEditingController();
  final fone = TextEditingController();
  final cpf = TextEditingController();
  final senha = TextEditingController();
  final confirmaSenha = TextEditingController();
  final estadoController = TextEditingController();
  final cidadeController = TextEditingController();
  final enderecoController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();
  final cepController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  XFile? _image;
  bool isButtonEnabled = false;
  var estado = '';
  var cidade = '';
  String? selectedCity = 'Selecione a Cidade';

  @override
  void initState() {
    super.initState();
    nome.addListener(enableButton);
    email.addListener(enableButton);
    fone.addListener(enableButton);
    cpf.addListener(enableButton);
    senha.addListener(enableButton);
    confirmaSenha.addListener(enableButton);
    estadoController.addListener(enableButton);
    cidadeController.addListener(enableButton);
    enderecoController.addListener(enableButton);
    numeroController.addListener(enableButton);
    complementoController.addListener(enableButton);
    cepController.addListener(enableButton);
  }

  void enableButton() {
    setState(() {
      isButtonEnabled = nome.text.isNotEmpty &&
          email.text.isNotEmpty &&
          fone.text.isNotEmpty &&
          cpf.text.isNotEmpty &&
          senha.text.isNotEmpty &&
          estado != '' &&
          cidade != "" &&
          enderecoController.text.isNotEmpty &&
          numeroController.text.isNotEmpty &&
          complementoController.text.isNotEmpty;
    });
  }

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zAZ0-9-.]+$');
    return emailRegExp.hasMatch(email);
  }

void _showRegistrationSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Impede o fechamento do alert ao tocar fora dele
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Cadastro Finalizado'),
        content: Text('Seu cadastro foi concluído com sucesso!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Navegar de volta para a página de login
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Pop novamente para voltar para a página de login (ajuste conforme a necessidade)
            },
            child: Text('Ir para o Login'),
          ),
        ],
      );
    },
  );
}
  Widget _buildNextButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isButtonEnabled
          ? ()  {
              if (senha.text != confirmaSenha.text) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Erro'),
                      content: Text('A senha e a confirmação de senha devem ser iguais.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                return; // Retorna sem prosseguir com o registro
              }

              if (!_isValidEmail(email.text)) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Erro'),
                      content: Text('Por favor, insira um e-mail válido.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                return; // Retorna sem prosseguir com o registro
              }

               _showRegistrationSuccessDialog(context);
              _registerUser(context);
            }
              // ... (código existente)

          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isButtonEnabled ? const Color.fromRGBO(92, 198, 186, 100) : Colors.grey,
        shape: const StadiumBorder(),
      ),
      child: const Text(
        'Finalizar Cadastro',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _registerUser(BuildContext context) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.text,
        password: senha.text,
      );

      final User? user = userCredential.user;
      if (user != null) {
        final cliente = Cliente(
          id: user.uid,
          name: nome.text,
          email: email.text,
          telefone: fone.text,
          senha: senha.text,
          cpf: cpf.text,
          imagem: _image?.path ?? '',
          estado: estado,
          cidade: cidade,
          endereco: enderecoController.text,
          numero: numeroController.text,
          complemento: complementoController.text,
        );

        if (cepController.text.isNotEmpty &&
            enderecoController.text.isNotEmpty &&
            numeroController.text.isNotEmpty &&
            complementoController.text.isNotEmpty) {
          final endereco = Endereco(
            id: Uuid().v1(),
            cep: cepController.text,
            endereco: enderecoController.text,
            numero: numeroController.text,
            complemento: complementoController.text,
          );
          Provider.of<Enderecos>(context, listen: false).adiciona(endereco);
        }

        Provider.of<Clientes>(context, listen: false).adiciona(cliente);
      }
    } catch (e) {
      print('Erro de criação de usuário no Firebase Authentication: $e');
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
  }) {
    bool isNotEmpty = controller.text.isNotEmpty;

    return Column(
      children: [
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label${isNotEmpty ? '' : ' (Obrigatório)'}',
                style: TextStyle(
                  color: isNotEmpty ? Colors.black : Colors.red,
                ),
              ),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneTextField({required TextEditingController controller, required String label,}) {
    bool isNotEmpty = controller.text.isNotEmpty;
    var maskFormatter = TextInputFormatter.withFunction(
      (oldValue, newValue) {
        if (newValue.text.isEmpty) {
          return newValue.copyWith(
            text: '',
            selection: TextSelection.collapsed(offset: 0),
          );
        }

        var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

        if (text.length > 10) {
          text = text.substring(0, 11);
        }

        var maskedText = '(${text.substring(0, 2)}) ${text.substring(2, 7)}-${text.substring(7)}';

        return newValue.copyWith(
          text: maskedText,
          selection: TextSelection.collapsed(offset: maskedText.length),
        );
      },
    );
    return Column(
      children: [
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label${isNotEmpty ? '' : ' (Obrigatório)'}',
                style: TextStyle(
                  color: isNotEmpty ? Colors.black : Colors.red,
                ),
              ),
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [maskFormatter],
                decoration: InputDecoration(
                  hintText: 'Telefone',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required String label,
  }) {
    bool isNotEmpty = controller.text.isNotEmpty;
    return Column(
      children: [
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label${isNotEmpty ? '' : ' (Obrigatório)'}',
                style: TextStyle(
                  color: isNotEmpty ? Colors.black : Colors.red,
                ),
              ),
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.text,
                obscureText: true, // Para ocultar a senha
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCPFTextField({
    required TextEditingController controller,
    required String label,
  }) {
    bool isNotEmpty = controller.text.isNotEmpty;
    var maskFormatter = TextInputFormatter.withFunction(
      (oldValue, newValue) {
        if (newValue.text.isEmpty) {
          return newValue.copyWith(
            text: '',
            selection: TextSelection.collapsed(offset: 0),
          );
        }

        var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

        if (text.length > 11) {
          text = text.substring(0, 11);
        }

        var maskedText = '${text.substring(0, 3)}.${text.substring(3, 6)}.${text.substring(6, 9)}-${text.substring(9)}';

        return newValue.copyWith(
          text: maskedText,
          selection: TextSelection.collapsed(offset: maskedText.length),
        );
      },
    );
    return Column(
      children: [
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label${isNotEmpty ? '' : ' (Obrigatório)'}',
                style: TextStyle(
                  color: isNotEmpty ? Colors.black : Colors.red,
                ),
              ),
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [maskFormatter],
                decoration: InputDecoration(
                  hintText: 'CPF',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePickerButton() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _getImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            shape: const StadiumBorder(),
          ),
          child: const Text(
            'Selecionar Imagem',
            style: TextStyle(color: Colors.white),
          ),
        ),
        if (_image != null)
          Image.file(
            File(_image!.path),
            height: 100,
          ),
      ],
    );
  }

  Widget _buildCSCPicker() {
    return CSCPicker(
      layout: Layout.vertical,
      currentCountry: "Brazil",
      defaultCountry: CscCountry.Brazil,
      disableCountry: true,
      flagState: CountryFlag.DISABLE,
      onCountryChanged: (Country) {},
      onStateChanged: (value) {
        setState(() {
          estado = value.toString();
        });
      },
      onCityChanged: (value) {
        setState(() {
          cidade = value.toString();
        });
      },
      countryDropdownLabel: "Pais",
      stateDropdownLabel: "Estado",
      cityDropdownLabel: "cidade",
      dropdownDialogRadius: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF73C9C9),
          title: Text('Cadastro'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Informações Pessoais'),
              Tab(text: 'Endereço'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Informações Pessoais
                  const SizedBox(height: 20),
                  _buildImagePickerButton(),
                  const SizedBox(height: 10),
                  _buildTextField(controller: nome, hintText: 'Nome', label: 'Nome'),
                  const SizedBox(height: 10),
                  _buildTextField(controller: email, hintText: 'E-mail', label: 'E-mail'),
                  const SizedBox(height: 10),
                  _buildPhoneTextField(controller: fone, label: 'Telefone'),
                  const SizedBox(height: 10),
                  _buildCPFTextField(controller: cpf, label: 'CPF'),
                  const SizedBox(height: 10),
                  _buildPasswordField(controller: senha, hintText: 'Senha', label: 'Senha'),
                  const SizedBox(height: 10),
                  _buildPasswordField(controller: confirmaSenha, hintText: 'Confirmação de Senha', label: 'Confirmação de Senha'),
                  const SizedBox(height: 10),
                  const SizedBox(height: 5),
                  _buildNextButton(context),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Endereço
                  const SizedBox(height: 20),
                  _buildCSCPicker(),
                  _buildTextField(controller: enderecoController, hintText: 'Endereço', label: 'Endereço'),
                  _buildTextField(controller: numeroController, hintText: 'Número', label: 'Número'),
                  _buildTextField(controller: complementoController, hintText: 'Complemento', label: 'Complemento'),
                  const SizedBox(height: 5),
                  _buildNextButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
