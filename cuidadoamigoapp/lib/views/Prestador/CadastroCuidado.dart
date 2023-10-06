import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroPrestador extends StatelessWidget {
  const CadastroPrestador({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildTextField(
              'Nome',
              TextInputType.text,
              20,
            ),
            const SizedBox(height: 5),
            _buildCPFTextField(),
            const SizedBox(height: 5),
            _buildTextField(
              'E-mail',
              TextInputType.emailAddress,
              null,
            ),
            const SizedBox(height: 5),
            _buildPhoneTextField(),
            const SizedBox(height: 5),
            _buildCEPTextField(),
            const SizedBox(height: 40),
            _buildPasswordField('Senha', 'Senha'),
            const SizedBox(height: 5),
            _buildPasswordField('Confirma Senha', 'Confirma Senha'),
            const SizedBox(height: 10),
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 48),
        Image.asset('Assets/imagens/LOGO.png'),
      ],
    );
  }

  Widget _buildTextField(
    String hintText,
    TextInputType keyboardType, [
    int? maxLength,
    String? initialValue,
  ]) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        initialValue: initialValue,
        inputFormatters: maxLength != null
            ? [LengthLimitingTextInputFormatter(maxLength)]
            : [],
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildCPFTextField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        inputFormatters: [
          MaskTextInputFormatter(
            mask: '###.###.###-##',
            filter: {"#": RegExp(r'[0-9]')},
            type: MaskAutoCompletionType.lazy,
          )
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'CPF',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildPhoneTextField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        inputFormatters: [
          MaskTextInputFormatter(
            mask: '#####-####',
            filter: {"#": RegExp(r'[0-9]')},
            type: MaskAutoCompletionType.lazy,
          )
        ],
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: 'Telefone',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildCEPTextField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        inputFormatters: [
          MaskTextInputFormatter(
            mask: '##.###.###',
            filter: {"#": RegExp(r'[0-9]')},
            type: MaskAutoCompletionType.lazy,
          )
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'CEP',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hintText, String labelText) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/homePrestador');
      },
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
}
