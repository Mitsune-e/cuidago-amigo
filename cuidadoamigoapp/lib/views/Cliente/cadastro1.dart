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
          confirmaSenha.text.isNotEmpty &&
          senha.text == confirmaSenha.text;

      if (showEnderecoForm) {
        // Validar os campos de endereço apenas se o usuário optar por adicioná-los
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
  final emailRegExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
  return emailRegExp.hasMatch(email);
}

  Widget _buildNextButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isButtonEnabled
          ? () {
             if (senha.text == confirmaSenha.text) {
              if (_isValidEmail(email.text)) {
                if (showEnderecoForm) {
                  enderecoButtonText = 'Editar Endereço';
                }
              _registerUser(context);
              } else{
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
              }
            } else{
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
            }
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
     

      // Crie um objeto Cliente
      final cliente = Cliente(
        id: user.uid,
        name: nome.text,
        email: email.text,
        telefone: fone.text,
        senha: senha.text,
        cpf: cpf.text,
        imagem: _image?.path ?? '',
      );

      // Se todos os campos de endereço forem preenchidos
      if (cepController.text.isNotEmpty && enderecoController.text.isNotEmpty && numeroController.text.isNotEmpty && complementoController.text.isNotEmpty) {
        print("teste");
        // Crie um objeto Endereco
        final endereco = Endereco(
          id: Uuid().v1(), // Gere um ID para o endereço
          cep: cepController.text,
          endereco: enderecoController.text,
          numero: numeroController.text,
          complemento: complementoController.text,
        );
        Provider.of<Enderecos>(context, listen: false).adiciona(endereco);
        // Adicione o ID do endereço ao cliente
        cliente.enderecos?.add(endereco.id);

        // Adicione o endereço ao provedor de endereços
        
      }  
      Provider.of<Clientes>(context, listen: false).adiciona(cliente);

      // Adicione o cliente ao provedor de clientes
   

      // Após salvar, você pode navegar para a próxima página (cadastro2) ou fazer qualquer outra coisa.
    }
  } catch (e) {
    print('Erro de criação de usuário no Firebase Authentication: $e');
  }
}


  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      children: [
        if (controller.text.isEmpty)
          Text(
            'Obrigatório',
            style: TextStyle(color: Colors.red),
          ),
        SizedBox(
          width: 250,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
    )],
    );
  }

  Widget _buildPhoneTextField({
    required TextEditingController controller,
  }) {
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
        if (controller.text.isEmpty)
          Text(
            'Obrigatório',
            style: TextStyle(color: Colors.red),
          ),
        SizedBox(
          width: 250,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            inputFormatters: [maskFormatter],
            decoration: InputDecoration(
              hintText: 'Telefone',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
    )],
    );
  }

  Widget _buildCPFTextField({
    required TextEditingController controller,
  }) {
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
        if (controller.text.isEmpty)
          Text(
            'Obrigatório',
            style: TextStyle(color: Colors.red),
          ),
        SizedBox(
          width: 250,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number, 
            inputFormatters: [maskFormatter],     
            decoration: InputDecoration(
              hintText: 'CPF',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
    )],
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      children: [
        if (controller.text.isEmpty)
          Text(
            'Obrigatório',
            style: TextStyle(color: Colors.red),
          ),
        SizedBox(
          width: 250,
          child: TextFormField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
    )],
      
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
            _buildTextField(controller: cepController, hintText: 'CEP'),
            _buildTextField(controller: enderecoController, hintText: 'Endereço'),
            _buildTextField(controller: numeroController, hintText: 'Número'),
            _buildTextField(controller: complementoController, hintText: 'Complemento'),
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
            // Verifica se todos os campos obrigatórios estão preenchidos
            if (cepController.text.isNotEmpty &&
                enderecoController.text.isNotEmpty &&
                numeroController.text.isNotEmpty &&
                complementoController.text.isNotEmpty) {
              formKey.currentState!.save();
              setState(() {
                showEnderecoForm = true;
                enderecoButtonText = 'Editar Endereço';
              });
              Navigator.of(context).pop();
            } else {
              // Se algum campo obrigatório estiver vazio, exibe um AlertDialog
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
            _buildTextField(controller: nome, hintText: 'Nome'),
            _buildTextField(controller: email, hintText: 'E-mail'),
            _buildPhoneTextField(controller: fone),
            _buildCPFTextField(controller: cpf),
            _buildPasswordField(controller: senha, hintText: 'Senha'),
            _buildPasswordField(controller: confirmaSenha, hintText: 'Confirmação de Senha'),
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
