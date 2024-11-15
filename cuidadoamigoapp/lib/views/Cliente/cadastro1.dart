import 'dart:io';

import 'package:cuidadoamigoapp/Util/Mascaras.dart';
import 'package:cuidadoamigoapp/Util/Validacao.dart';
import 'package:cuidadoamigoapp/models/cliente.dart';
import 'package:cuidadoamigoapp/provider/Clientes.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:csc_picker/csc_picker.dart';
import 'package:provider/provider.dart';

class Cadastro1 extends StatefulWidget {
  const Cadastro1({super.key});

  @override
  _Cadastro1State createState() => _Cadastro1State();
}

class _Cadastro1State extends State<Cadastro1> {
  final PageController _pageController = PageController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController =
      TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _imagemController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _possuiCarro = false;
  bool isNomeValid = false;
  var cidade = '';
  var estado = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastra-se como Cliente'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _previousPage();
          } else if (details.primaryVelocity! < 0) {
            _nextPage();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildDadosPessoais(),
                  _buildEndereco(),
                  _buildFinalizar(),
                ],
              ),
            ),
            _buildNextPrevButtons(),
            const SizedBox(height: 10),
            const Text(
              'Arraste para o lado ou clique nas setas para navegar entre as páginas.',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDadosPessoais() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados Pessoais',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildImagePickerButton(),
            const SizedBox(height: 10),
            _buildTextField(
                controller: _nomeController,
                hintText: 'Nome',
                label: 'Nome',
                mandatory: true),
            const SizedBox(height: 10),
            _buildTextField(
                controller: _emailController,
                hintText: 'E-mail',
                label: 'E-mail',
                mandatory: true),
            const SizedBox(height: 10),
            _buildPhoneTextField(
              controller: _telefoneController,
              label: 'Telefone',
            ),
            const SizedBox(height: 10),
            _buildCPFTextField(controller: _cpfController, label: 'CPF'),
            const SizedBox(height: 10),
            _buildPasswordField(
                controller: _senhaController,
                hintText: 'Senha',
                label: 'Senha'),
            const SizedBox(height: 10),
            _buildPasswordField(
                controller: _confirmaSenhaController,
                hintText: 'Confirmação de Senha',
                label: 'Confirmação de Senha'),
          ],
        ),
      ),
    );
  }

  Widget _buildEndereco() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Endereço',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildCSCPicker(),
            _buildTextField(
                controller: _enderecoController,
                hintText: 'Endereço',
                label: 'Endereço',
                mandatory: true),
            _buildTextField(
                controller: _numeroController,
                hintText: 'Número',
                label: 'Número',
                mandatory: true),
            _buildTextField(
                controller: _complementoController,
                hintText: 'Complemento',
                label: 'Complemento',
                mandatory: false),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalizar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Finalizar Cadastro',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildFinalizarButton(),
        ],
      ),
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
        if (_imagemController.text.isNotEmpty)
          Image.file(
            File(_imagemController.text),
            height: 100,
          ),
      ],
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String hintText,
      required String label,
      required bool mandatory}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${controller.text.isNotEmpty ? '' : (mandatory == true ? ' (Obrigatório)' : '')}',
          style: TextStyle(
            color: controller.text.isNotEmpty ? Colors.black : Colors.red,
          ),
        ),
        TextFormField(
          onChanged: (Text) {
            setState(() {});
          },
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
          validator: (value) {
            if (mandatory == true && (value == null || value.isEmpty)) {
              return 'Campo obrigatório';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneTextField(
      {required TextEditingController controller, required String label}) {
    var maskFormatter = TextInputFormatter.withFunction(
      (oldValue, newValue) {
        if (newValue.text.isEmpty) {
          return newValue.copyWith(
            text: '',
            selection: TextSelection.collapsed(offset: 0),
          );
        }

        String maskedText = Mascaras.aplicarMascara('telefone', newValue.text);

        return newValue.copyWith(
          text: maskedText,
          selection: TextSelection.collapsed(offset: maskedText.length),
        );
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${controller.text.isNotEmpty ? '' : ' (Obrigatório)'}',
          style: TextStyle(
            color: controller.text.isNotEmpty ? Colors.black : Colors.red,
          ),
        ),
        TextFormField(
          onChanged: (Text) {
            setState(() {});
          },
          controller: controller,
          keyboardType: TextInputType.phone,
          inputFormatters: [maskFormatter],
          decoration: InputDecoration(
            hintText: 'Telefone',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${controller.text.isNotEmpty ? '' : ' (Obrigatório)'}',
          style: TextStyle(
            color: controller.text.isNotEmpty ? Colors.black : Colors.red,
          ),
        ),
        TextFormField(
          onChanged: (Text) {
            setState(() {});
          },
          controller: controller,
          keyboardType: TextInputType.text,
          obscureText: true,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCPFTextField({
    required TextEditingController controller,
    required String label,
  }) {
    var maskFormatter = TextInputFormatter.withFunction(
      (oldValue, newValue) {
        if (newValue.text.isEmpty) {
          return newValue.copyWith(
            text: '',
            selection: TextSelection.collapsed(offset: 0),
          );
        }

        var maskedText = Mascaras.aplicarMascara("cpf", newValue.text);

        return newValue.copyWith(
          text: maskedText,
          selection: TextSelection.collapsed(offset: maskedText.length),
        );
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${controller.text.isNotEmpty ? '' : ' (Obrigatório)'}',
          style: TextStyle(
            color: controller.text.isNotEmpty ? Colors.black : Colors.red,
          ),
        ),
        TextFormField(
          onChanged: (Text) {
            setState(() {});
          },
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [maskFormatter],
          decoration: InputDecoration(
            hintText: 'CPF',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCSCPicker() {
    return CSCPicker(
      layout: Layout.vertical,
      currentCountry: "Brazil",
      currentState: estado,
      currentCity: cidade,
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
      cityDropdownLabel: "Cidade",
      dropdownDialogRadius: 30,
    );
  }

  Widget _buildCarroCheckbox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Possui Carro',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            Radio(
              value: true,
              groupValue: _possuiCarro,
              onChanged: (value) {
                setState(() {
                  _possuiCarro = value as bool;
                });
              },
            ),
            Text('Sim'),
            Radio(
              value: false,
              groupValue: _possuiCarro,
              onChanged: (value) {
                setState(() {
                  _possuiCarro = value as bool;
                });
              },
            ),
            Text('Não'),
          ],
        ),
      ],
    );
  }

  Widget _buildDescricaoTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descrição ${_descricaoController.text.isNotEmpty ? '' : ' (Obrigatório)'}',
          style: TextStyle(
            color: _descricaoController.text.isNotEmpty
                ? Colors.black
                : Colors.red,
          ),
        ),
        TextFormField(
          onChanged: (Text) {
            setState(() {});
          },
          controller: _descricaoController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Digite uma descrição',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalizarButton() {
    return ElevatedButton(
      onPressed: _validateAndRegister,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(92, 198, 186, 100),
        shape: const StadiumBorder(),
      ),
      child: const Text(
        'Finalizar',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildNextPrevButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: _previousPage,
          icon: Icon(Icons.arrow_back),
        ),
        IconButton(
          onPressed: _nextPage,
          icon: Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  void _previousPage() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  void _nextPage() {
    if (_pageController.page! < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  void _validateAndRegister() {
    // Validate required fields
    if (!_validateFields()) {
      return;
    }

    // Validate password match
    if (!Validacao.validarSenha(
        _senhaController.text, _confirmaSenhaController.text)) {
      _showErrorDialog(
          'Erro', 'A senha e a confirmação de senha devem ser iguais.');
      return;
    }

    // Validade email
    if (!Validacao.validar("email", _emailController.text)) {
      _showErrorDialog('Erro', 'E-mail inválido.');
      return;
    }

    // All validations passed, proceed with registration
    _showRegistrationSuccessDialog(context);
    _registerUser(context);
  }

  bool _validateFields() {
    List<String> emptyFields = [];

    // Check required fields
    if (_nomeController.text.isEmpty) {
      emptyFields.add('Nome');
    }
    if (_emailController.text.isEmpty) {
      emptyFields.add('E-mail');
    }
    if (_telefoneController.text.isEmpty) {
      emptyFields.add('Telefone');
    }
    if (_cpfController.text.isEmpty) {
      emptyFields.add('CPF');
    }
    if (_senhaController.text.isEmpty) {
      emptyFields.add('Senha');
    }
    if (_confirmaSenhaController.text.isEmpty) {
      emptyFields.add('Confirmação de Senha');
    }
    if (_enderecoController.text.isEmpty) {
      emptyFields.add('Endereço');
    }
    if (_numeroController.text.isEmpty) {
      emptyFields.add('Número');
    }
    if (_complementoController.text.isEmpty) {
      emptyFields.add('Complemento');
    }
    if (cidade == '') {
      emptyFields.add('Cidade');
    }
    if (estado == '') {
      emptyFields.add('Estado');
    }

    if (emptyFields.isNotEmpty) {
      _showErrorDialog('Campos obrigatórios não preenchidos',
          'Preencha os seguintes campos: \n ${emptyFields.join(",\n ")}');
      return false;
    }

    return true;
  }

  void _showRegistrationSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cadastro Finalizado'),
          content: Text('Seu cadastro foi concluído com sucesso!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  void _registerUser(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );

      final User? user = userCredential.user;
      if (user != null) {
        final cliente = Cliente(
          id: user.uid,
          name: _nomeController.text,
          email: _emailController.text,
          telefone: _telefoneController.text,
          senha: _senhaController.text,
          cpf: _cpfController.text,
          imagem: _imagemController.text ?? '',
          estado: estado,
          cidade: cidade,
          endereco: _enderecoController.text,
          numero: _numeroController.text,
          complemento: _complementoController.text,
        );

        Provider.of<Clientes>(context, listen: false).adiciona(cliente);
      }
    } catch (e) {
      print('Erro de criação de usuário no Firebase Authentication: $e');
    }
  }

  Future<void> _getImage() async {
    // Implement your image picking logic here
    // Use _imagemController to store the path to the selected image
  }
}
