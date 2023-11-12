import 'dart:io';
import 'package:cuidadoamigoapp/models/Endereco.dart';
import 'package:cuidadoamigoapp/models/cliente.dart';
import 'package:cuidadoamigoapp/provider/Clientes.dart';
import 'package:cuidadoamigoapp/provider/Enderecos.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  XFile? _image;
  bool isButtonEnabled = false;
  bool allFieldsFilled = false;

  final cepController = TextEditingController();
  final enderecoController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();

  bool showEnderecoForm = false;
  String endereco = '';
  String enderecoButtonText = 'Adicionar Endereço (Opcional)';

  @override
  void initState() {
    super.initState();
    nome.addListener(enableButton);
    email.addListener(enableButton);
    fone.addListener(enableButton);
    cpf.addListener(enableButton);
    senha.addListener(enableButton);
    confirmaSenha.addListener(enableButton);
  }

  void enableButton() {
    setState(() {
      isButtonEnabled = nome.text.isNotEmpty &&
          email.text.isNotEmpty &&
          fone.text.isNotEmpty &&
          cpf.text.isNotEmpty &&
          senha.text.isNotEmpty &&
          confirmaSenha.text.isNotEmpty;

      if (showEnderecoForm) {
        isButtonEnabled = isButtonEnabled && (cepController.text.isNotEmpty || enderecoController.text.isNotEmpty);
      }
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

  Widget _buildNextButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isButtonEnabled
          ? () {
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
                    ]);
                     });
                return; // Retorna sem prosseguir com o registro
              }

              if (showEnderecoForm) {
                enderecoButtonText = 'Editar Endereço';
              }
              _registerUser(context);
            }
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
          cliente.enderecos?.add(endereco.id);
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
  required String label
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

  Future<void> _showEnderecoAlert(BuildContext context) async {
    final formKey = GlobalKey<FormState>();

    final isUpdating = showEnderecoForm;
    final actionText = isUpdating ? 'Editar' : 'Adicionar';

    final alert = AlertDialog(
      title: Text('$actionText Endereço (Opcional)'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(controller: cepController, hintText: 'CEP', label: "CEP"),
              _buildTextField(controller: enderecoController, hintText: 'Endereço', label: "Endereço"),
              _buildTextField(controller: numeroController, hintText: 'Número', label: "Número"),
              _buildTextField(controller: complementoController, hintText: 'Complemento', label: "Complemento"),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if (cepController.text.isNotEmpty &&
                  enderecoController.text.isNotEmpty &&
                  numeroController.text.isNotEmpty &&
                  complementoController.text.isNotEmpty) {
                formKey.currentState!.save();
                setState(() {
                  showEnderecoForm = true;
                  enderecoButtonText = 'Editar Endereço';
                  endereco = '${enderecoController.text}\n Numero: ${numeroController.text}\n Complemento ${complementoController.text}';
                });
                Navigator.of(context).pop();
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Aviso'),
                      content: Text('Por favor, preencha todos os campos obrigatórios.'),
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
            }
          },
          child: Text(actionText),
        ),
      ],
    );

    await showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C9C9),
        title: Text('Cadastro'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildTextField(controller: nome, hintText: 'Nome', label: "Nome"),
            const SizedBox(height: 10),
            _buildTextField(controller: email, hintText: 'E-mail', label: "E-mail"),
            const SizedBox(height: 10),
            _buildPhoneTextField(controller: fone, label: "Telefone"),
            const SizedBox(height: 10),
            _buildCPFTextField(controller: cpf, label: "CPF"),
            const SizedBox(height: 10),
            _buildPasswordField(controller: senha, hintText: 'Senha', label: "Senha"),
            const SizedBox(height: 10),
            _buildPasswordField(controller: confirmaSenha, hintText: 'Confirmação de Senha', label: 'Confirmação de Senha'),
            const SizedBox(height: 5),
            _buildImagePickerButton(),
            const SizedBox(height: 10),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (showEnderecoForm) {
                      _showEnderecoAlert(context);
                    } else {
                      setState(() {
                        showEnderecoForm = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  child: Text(enderecoButtonText),
                ),
                if (showEnderecoForm)
                  Column(
                    children: [
                      Text('Endereço: $endereco'),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 5),
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }
}