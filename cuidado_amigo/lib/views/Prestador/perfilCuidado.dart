import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:cuidado_amigo/models/Prestador.dart';
import 'package:cuidado_amigo/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PerfilCuidador extends StatefulWidget {
  const PerfilCuidador({super.key});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<PerfilCuidador> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  String? imageUrl;
  var cidade = "";
  var estado = '';
  var estado_novo = "";
  var cidade_novo = "";
  List<String> cliente_enderecos = [];
  bool _isLoadingImage = true;
  final TextEditingController _descricaoController = TextEditingController();
  bool _possuiCarro = false;

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
      DocumentSnapshot userDoc =
          await _firestore.collection('Prestadores').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        Prestador prestador = Prestador.fromMap(userData);

        setState(() {
          _nomeController.text = prestador.name ?? '';
          _cpfController.text = prestador.cpf ?? '';
          _emailController.text = prestador.email ?? '';
          _telefoneController.text = prestador.telefone ?? '';
          estado = prestador.estado ?? '';
          cidade = prestador.cidade ?? '';
          _enderecoController.text = prestador.endereco ?? '';
          _numeroController.text = prestador.numero ?? '';
          _complementoController.text = prestador.complemento ?? '';
          imageUrl = prestador.imagem ?? '';
          _descricaoController.text = prestador.descricao ?? '';
          _possuiCarro = prestador.carro;

          _isLoadingImage = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar dados do Firestore: $e');
      // Em caso de erro, marque que a imagem não está mais carregando
      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  Future<void> _mostrarOpcoesImagem() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolher Imagem'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Galeria'),
                  onTap: () {
                    _escolherImagem(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Câmera'),
                  onTap: () {
                    _escolherImagem(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _escolherImagem(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      // Aqui você pode lidar com a imagem selecionada
      // Por exemplo, você pode carregar a imagem para o Firebase Storage
      // e atualizar a referência no Firestore
      // A propriedade pickedFile.path contém o caminho local da imagem selecionada

      // Implemente a lógica para fazer upload da imagem para o Firebase Storage
      // e obter a URL da imagem

      // Chame a função _updateUserData para atualizar a URL da imagem no Firestore
      User? user = _auth.currentUser;

      await _updateUserData(user!.uid);
    }
  }

  Future<String> fazerUploadEObterUrl(String imagePath) async {
    // Lógica para fazer o upload da imagem e obter a URL
    // Substitua este código pela implementação real do upload

    // Suponhamos que você esteja usando Firebase Storage para o upload
    // Aqui está um exemplo hipotético usando o Firebase Storage
    // Certifique-se de adicionar a biblioteca 'firebase_storage' no seu arquivo pubspec.yaml
    // e inicializar o Firebase antes de usar o Storage

    // Upload da imagem para o Firebase Storage
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('uploads').child('imagem.png');
    final UploadTask uploadTask = storageReference.putFile(File(imagePath));

    // Aguardar o término do upload
    await uploadTask.whenComplete(() => print('Upload concluído'));

    // Obter a URL da imagem após o upload
    final String imageUrl = await storageReference.getDownloadURL();

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popAndPushNamed('/homeCuidador');
          },
        ),
        title: const Text('Minha Conta'),
        backgroundColor: const Color(0xFF73C9C9),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Use um widget de carregamento enquanto a imagem está sendo carregada
            _isLoadingImage
                ? CircularProgressIndicator()
                : ClipOval(
                    child: _isLoadingImage
                        ? CircularProgressIndicator()
                        : imageUrl != null && imageUrl!.isNotEmpty
                            ? Image.network(
                                imageUrl!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
                                    );
                                  }
                                },
                              )
                            : Icon(
                                Icons.person,
                                size: 150,
                              ),
                  ),
            ElevatedButton(
              onPressed: () {
                _mostrarConfirmacaoExclusaoDialog();
              },
              child: const Text('Deletar Perfil'),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            _buildEnderecoBox(),
            const SizedBox(height: 20),
            _buildInfoBox(
              title: 'Dados Profissionais',
              buttonText: 'Editar',
              onButtonPressed: () {
                _mostrarEditarProfissionaisDialog();
              },
              children: [
                _buildInfoRow('Descrição', _descricaoController.text),
                _buildInfoRow('Possui Carro', _possuiCarro ? 'Sim' : 'Não'),
              ],
            ),
            const SizedBox(height: 20),
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
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3),
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
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF73C9C9),
                ),
              ),
              TextButton(
                onPressed: onButtonPressed,
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF73C9C9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value ??
                '', // Usando operador de coalescência nula para tratar valores nulos
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarEditarDialog(
      String title, List<TextEditingController> controllers) {
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
                    readOnly:
                        i == 2, // Impede que o campo de e-mail seja editado
                    decoration: InputDecoration(
                      labelText: i == 0
                          ? 'Nome'
                          : (i == 1 ? 'CPF' : (i == 2 ? 'E-mail' : 'Telefone')),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                bool camposPreenchidos = controllers
                    .every((controller) => controller.text.isNotEmpty);

                if (!camposPreenchidos) {
                  // Exibir mensagem de erro se algum campo estiver em branco
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                User? user = _auth.currentUser;

                await _updateUserData(user!.uid);

                await _loadData();

                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUserData(String userId) async {
    try {
      await _firestore.collection('Prestadores').doc(userId).update({
        'name': _nomeController.text,
        'cpf': _cpfController.text,
        'email': _emailController.text,
        'telefone': _telefoneController.text,
        'estado': estado,
        'cidade': cidade,
        'endereco': _enderecoController.text,
        'numero': _numeroController.text,
        'complemento': _complementoController.text,
        'imagem': imageUrl,
        'carro': _possuiCarro,
        'descricao': _descricaoController.text,
      });
      await _loadData();
    } catch (e) {
      print('Erro ao atualizar dados do usuário no Firestore: $e');
    }
  }

  Widget _buildEnderecoBox() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
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
                    child: const Text(
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
          const SizedBox(height: 10),
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
              title: const Text('Editar Endereço'),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          style: BorderStyle.solid,
                        ),
                      ),
                      disabledDropdownDecoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey[200],
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          style: BorderStyle.solid,
                        ),
                      ),
                      selectedItemStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      dropdownHeadingStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      dropdownItemStyle: const TextStyle(
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
                          cidade_novo = value.toString();
                        });
                      },
                    ),
                    TextFormField(
                      controller: _enderecoController,
                      decoration: const InputDecoration(
                        labelText: 'Endereço',
                      ),
                    ),
                    TextFormField(
                      controller: _numeroController,
                      decoration: const InputDecoration(
                        labelText: 'Número',
                      ),
                    ),
                    TextFormField(
                      controller: _complementoController,
                      decoration: const InputDecoration(
                        labelText: 'Complemento',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    bool camposEnderecoPreenchidos =
                        _enderecoController.text.isNotEmpty &&
                            _numeroController.text.isNotEmpty &&
                            _complementoController.text.isNotEmpty;

                    if (estado_novo.isEmpty ||
                        cidade_novo.isEmpty ||
                        !camposEnderecoPreenchidos) {
                      // Exibir mensagem de erro se cidade, estado ou algum campo de endereço estiver em branco
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Por favor, preencha todos os campos de endereço, cidade e estado.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    cidade = cidade_novo;
                    estado = estado_novo;

                    User? user = _auth.currentUser;

                    await _updateUserData(user!.uid);

                    await _loadData();

                    Navigator.of(context).pop();
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _mostrarEditarProfissionaisDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Editar Dados Profissionais'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _descricaoController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                      ),
                    ),
                    CheckboxListTile(
                      title: const Text('Possui Carro?'),
                      value: _possuiCarro,
                      onChanged: (value) {
                        setState(() {
                          _possuiCarro = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    bool camposPreenchidos =
                        _descricaoController.text.isNotEmpty;

                    if (!camposPreenchidos) {
                      // Exibir mensagem de erro se algum campo estiver em branco
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, preencha todos os campos.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    User? user = _auth.currentUser;
                    await _updateUserData(user!.uid);

                    await _loadData();

                    Navigator.of(context).pop();
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _mostrarConfirmacaoExclusaoDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text(
              'Tem certeza de que deseja excluir o perfil? Esta ação é irreversível.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () async {
                // Fechar o diálogo
                Navigator.of(context).pop();

                // Executar a exclusão do perfil
                await _excluirPerfil();
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _excluirPerfil() async {
    try {
      User? user = _auth.currentUser;

      // Deletar a instância de autenticação
      await user?.delete();

      // Deletar entrada correspondente na tabela 'Clientes' do Firestore
      await _firestore.collection('Prestadores').doc(user?.uid).delete();

      // Navegar para a próxima página após excluir o perfil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    } catch (e) {
      print('Erro ao excluir perfil: $e');
      // Lide com erros aqui, se necessário
    }
  }
}
