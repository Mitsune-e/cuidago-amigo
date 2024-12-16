import 'dart:io';

import 'package:cuidadoamigoapp/Util/BuscarCEP.dart';
import 'package:cuidadoamigoapp/Util/Mascaras.dart';
import 'package:cuidadoamigoapp/Util/Validacao.dart';
import 'package:cuidadoamigoapp/models/cliente.dart';
import 'package:cuidadoamigoapp/provider/Clientes.dart';
import 'package:cuidadoamigoapp/widgets/TextFieldComponent.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:csc_picker/csc_picker.dart';
import 'package:provider/provider.dart';
import 'package:search_cep/search_cep.dart';

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
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _imagemController = TextEditingController();

  String movimentacao = "";
  String alimentacao = "";
  String doencaCronica = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isNomeValid = false;

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
                  _buildQuestionario(),
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
            TextFieldComponent(
              controller: _nomeController,
              hintText: 'Nome',
              label: 'Nome',
              mandatory: true,
              onChanged: (text) {
                setState(() {});
              },
            ),
            const SizedBox(height: 10),
            TextFieldComponent(
              controller: _emailController,
              hintText: 'E-mail',
              label: 'E-mail',
              mandatory: true,
              onChanged: (text) {
                setState(() {});
              },
            ),
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

  Widget _buildQuestionario() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Questionario',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Como é sua Movimentação?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text("Não necessito de Ajuda"),
                      value: "Não necessito de Ajuda",
                      groupValue: movimentacao,
                      onChanged: (value) {
                        setState(() {
                          movimentacao = value ?? "";
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("Necessito de Ajuda"),
                      value: "Necessito de Ajuda",
                      groupValue: movimentacao,
                      onChanged: (value) {
                        setState(() {
                          movimentacao = value ?? "";
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("Utilizo andador"),
                      value: "Utilizo andador",
                      groupValue: movimentacao,
                      onChanged: (value) {
                        setState(() {
                          movimentacao = value ?? "";
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("Utilizo Cadeira de Rodas"),
                      value: "Utilizo Cadeira de Rodas",
                      groupValue: movimentacao,
                      onChanged: (value) {
                        setState(() {
                          movimentacao = value ?? "";
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("Acamado"),
                      value: "Acamado",
                      groupValue: movimentacao,
                      onChanged: (value) {
                        setState(() {
                          movimentacao = value ?? "";
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Como é sua Alimentação?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text("Via Oral"),
                      value: "Via Oral",
                      groupValue: alimentacao,
                      onChanged: (value) {
                        setState(() {
                          alimentacao = value ?? "";
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("Via Sonda"),
                      value: "Via Sonda",
                      groupValue: alimentacao,
                      onChanged: (value) {
                        setState(() {
                          alimentacao = value ?? "";
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Existe alguma doença crônica?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text("Sim"),
                      value: "Sim",
                      groupValue: doencaCronica,
                      onChanged: (value) {
                        setState(() {
                          doencaCronica = value ?? "";
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("Não"),
                      value: "Não",
                      groupValue: doencaCronica,
                      onChanged: (value) {
                        setState(() {
                          doencaCronica = value ?? "";
                        });
                      },
                    ),
                  ],
                ),
              ],
            )
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
            Row(children: [
              Expanded(
                child: TextFieldComponent(
                    controller: _cepController,
                    hintText: 'Digite o seu CEP',
                    label: 'CEP',
                    mandatory: true,
                    onChanged: (text) {
                      setState(() {});
                    }),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: Colors.grey,
                      )),
                ),
                onPressed: () {
                  _buscarCep(_cepController.text);
                },
                child: const Text('Buscar Endereço'),
              ),
            ]),

            TextFieldComponent(
                controller: _estadoController,
                hintText: 'Digite o seu estado',
                label: 'Estado',
                mandatory: true,
                onChanged: (text) {
                  setState(() {});
                }),
            TextFieldComponent(
              controller: _cidadeController,
              hintText: 'Digite a sua cidade',
              label: 'Cidade',
              mandatory: true,
              onChanged: (text) {
                setState(() {});
              },
            ),
            //_buildCSCPicker(),
            TextFieldComponent(
              controller: _enderecoController,
              hintText: 'Endereço',
              label: 'Endereço',
              mandatory: true,
              onChanged: (text) {
                setState(() {});
              },
            ),
            TextFieldComponent(
              controller: _numeroController,
              hintText: 'Número',
              label: 'Número',
              mandatory: true,
              onChanged: (text) {
                setState(() {});
              },
            ),
            TextFieldComponent(
              controller: _complementoController,
              hintText: 'Complemento',
              label: 'Complemento',
              mandatory: false,
              onChanged: (text) {
                setState(() {});
              },
            ),
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
          onChanged: (text) {
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
          onChanged: (text) {
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
          onChanged: (text) {
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

/*   Widget _buildCSCPicker() {
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
 */

  Widget _buildFinalizarButton() {
    return ElevatedButton(
      onPressed: _validateAndRegister,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(92, 198, 186, 100),
        shape: const StadiumBorder(),
      ),
      child: const Text(
        'Continuar',
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
    if (_pageController.page! < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  void _buscarCep(String Cep) async {
    try {
      //Writes what Cep returns and write in the input fields
      final result = await buscarCEP(Cep);
      print(result);

      _estadoController.text = result.uf ?? "";
      _cidadeController.text = result.localidade ?? "";
      _enderecoController.text = result.logradouro ?? "";
      _numeroController.text = result.unidade ?? "";
      setState(() {});
    } on Exception catch (e) {
      _showErrorDialog('Erro', 'Erro ao buscar o CEP: $e');
    } catch (e) {
      _showErrorDialog('Erro', 'Erro desconhecido ao buscar o CEP: $e');
    }
  }

  void _validateAndRegister() async {
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
    if (_cidadeController.text.isEmpty) {
      emptyFields.add('Cidade');
    }
    if (_estadoController.text.isEmpty) {
      emptyFields.add('Estado');
    }
    if (_cepController.text.isEmpty) {
      emptyFields.add('CEP');
    }
    if (movimentacao.isEmpty) {
      emptyFields.add("Como é sua Movimentação?");
    }
    if (alimentacao.isEmpty) {
      emptyFields.add("Como é sua Alimentação?");
    }
    if (doencaCronica.isEmpty) {
      emptyFields.add("Existe alguma doença crônica?");
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
                Navigator.of(context).pushReplacementNamed('/homeIdoso');
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
            estado: _estadoController.text,
            cidade: _cidadeController.text,
            cep: _cepController.text,
            endereco: _enderecoController.text,
            numero: _numeroController.text,
            complemento: _complementoController.text,
            movimentacao: movimentacao,
            alimentacao: alimentacao,
            doencaCronica: doencaCronica);

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
