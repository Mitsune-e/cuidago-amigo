import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidado_amigo/models/cliente.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:csc_picker/csc_picker.dart';

class SolicitarCuidado1 extends StatefulWidget {
  const SolicitarCuidado1({super.key});

  @override
  _SolicitarCuidado1State createState() => _SolicitarCuidado1State();
}

class _SolicitarCuidado1State extends State<SolicitarCuidado1> {
  final bool _exibirCamposEndereco =
      true; // Modificado para sempre mostrar os campos de endereço

  TextEditingController dataController = TextEditingController();
  DateTime? selectedTimeInicio;
  DateTime? selectedTimeFim;
  TextEditingController numeroController = TextEditingController();
  TextEditingController complementoController = TextEditingController();
  String estado = '';
  String cidade = '';
  String cep = '';
  String clienteId = '';
  TextEditingController enderecoController = TextEditingController();
  final TextEditingController _movimentacaoController = TextEditingController();
  final TextEditingController _alimentacaoController = TextEditingController();
  final TextEditingController _doencaCronicaController =
      TextEditingController();
  double valor = 0.0;
  double valorHoraEnfermeiro = 20.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey<CSCPickerState>();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  Future<void> _loadUserData(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('Clientes').doc(userId).get();

      if (userDoc.exists) {
        setState(() {
          enderecoController.text = userDoc['endereco'] ?? '';
          numeroController.text = userDoc['numero'] ?? '';
          complementoController.text = userDoc['complemento'] ?? '';
          cidade = userDoc['cidade'] ?? '';
          estado = userDoc['estado'] ?? '';
          cep = userDoc['cep'] ?? '';
          _movimentacaoController.text = userDoc['movimentacao'] ?? '';
          _alimentacaoController.text = userDoc['alimentacao'] ?? '';
          _doencaCronicaController.text = userDoc['doencaCronica'] ?? '';
          clienteId = userDoc['id'];
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
        title: const Text('Solicitar Cuidado'),
        backgroundColor: const Color(0xFF73C9C9),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextFormField(
                  controller: dataController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    hintText: 'Selecione a data',
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dataController.text =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                      });
                    } else {
                      // Mostrar mensagem de erro ou fazer alguma outra ação
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, selecione uma data.'),
                        ),
                      );
                    }
                  }),
              const SizedBox(height: 20),
              const Text(
                'Horário',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showTimePickerAlert(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF73C9C9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          selectedTimeInicio != null
                              ? DateFormat('HH:mm').format(selectedTimeInicio!)
                              : 'Início',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'até',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showTimePickerAlert(context, false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF73C9C9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          selectedTimeFim != null
                              ? DateFormat('HH:mm').format(selectedTimeFim!)
                              : 'Fim',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Valor: R\$ ${valor.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: const Color(0xFF73C9C9), // Cor destacada
                ),
              ),
              const Text(
                'Endereço',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _loadUserData(_auth.currentUser!.uid);
                          stateController.text = estado;
                          cityController.text = cidade;
                        });
                        final cscPickerState = _cscPickerKey.currentState;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF73C9C9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Salvo',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Limpar os campos ao clicar em Novo
                          stateController.clear();
                          cityController.clear();
                          enderecoController.clear();
                          numeroController.clear();
                          complementoController.clear();
                          cidade = '';
                          estado = '';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF73C9C9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Novo',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_exibirCamposEndereco)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CEP: ${cep.isNotEmpty ? cep : 'Nenhum CEP selecionado'}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Cidade: ${cidade.isNotEmpty ? cidade : 'Nenhuma cidade selecionada'}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Estado: ${estado.isNotEmpty ? estado : 'Nenhum estado selecionado'}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditLocationAlert(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      // Campo de Número
                      controller: enderecoController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: 'Endereco',
                        prefixIcon: Icon(Icons.home),
                      ),
                    ),
                    TextFormField(
                      // Campo de Número
                      controller: numeroController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Número',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                    TextFormField(
                      // Campo de Complemento
                      controller: complementoController,
                      decoration: const InputDecoration(
                        hintText: 'Complemento (opcional)',
                        prefixIcon: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              const Text(
                'Especificações',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Movimentação: ${_movimentacaoController.text.isNotEmpty ? _movimentacaoController.text : 'Nenhum dado informado'}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Alimentação: ${_alimentacaoController.text.isNotEmpty ? _alimentacaoController.text : 'Nenhum dado informado'}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Doença Cronica: ${_doencaCronicaController.text.isNotEmpty ? _doencaCronicaController.text : 'Nenhum dado informado'}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedTimeInicio != null &&
                        selectedTimeFim != null &&
                        selectedTimeFim!.isAfter(
                            selectedTimeInicio!.add(Duration(minutes: 30))) &&
                        _validateAddress()) {
                      if (dataController.text.isEmpty ||
                          dataController.text == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('O campo de Data é obrigatório.'),
                          ),
                        );
                        return;
                      }
                      if (selectedTimeInicio == null ||
                          selectedTimeFim == null ||
                          selectedTimeFim!.isBefore(selectedTimeInicio!)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('O campo de Horário é obrigatório.'),
                          ),
                        );
                        return;
                      }
                      if (cidade == null || cidade.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('O campo de Cidade é obrigatório.'),
                          ),
                        );
                        return;
                      }
                      if (estado == null || estado.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('O campo de Estado é obrigatório.'),
                          ),
                        );
                        return;
                      }
                      if (enderecoController.text.isEmpty ||
                          enderecoController.text == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('O campo de Endereço é obrigatório.'),
                          ),
                        );
                        return;
                      }
                      if (numeroController.text.isEmpty ||
                          numeroController.text == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('O campo de Número é obrigatório.'),
                          ),
                        );
                        return;
                      }

                      final dataToPass = {
                        'data': dataController.text,
                        'horaInicio':
                            DateFormat('HH:mm').format(selectedTimeInicio!),
                        'horaFim': DateFormat('HH:mm').format(selectedTimeFim!),
                        'valor': valor,
                        'cidade': cidade,
                        'estado': estado,
                        'cep': cep,
                        'endereco': enderecoController.text,
                        'complemento': complementoController.text,
                        'numero': numeroController.text,
                        'movimentacao': _movimentacaoController.text,
                        'alimentacao': _alimentacaoController.text,
                        'doencaCronica': _doencaCronicaController.text,
                        'clienteId': clienteId
                      };

                      Navigator.of(context).pushNamed('/solicitarCuidador2',
                          arguments: dataToPass);
                    } else {
                      // Mostrar uma mensagem de erro ou fazer alguma outra ação
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Por favor, verifique as informações e siga as regras.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF73C9C9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                    child: Text(
                      'Prosseguir',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePickerAlert(BuildContext context, bool isStart) async {
    final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
        cancelText: "Cancelar",
        confirmText: "Confirmar",
        helpText: "Selecione o horário. (Minimo 30 Minutos de atendimento)",
        errorInvalidText: "Error Invalid Text",
        hourLabelText: 'Hour Label',
        minuteLabelText: "Minute Label");

    if (selectedTime != null) {
      final now = DateTime.now();
      /* print({now}); */
      final dateTimeSelected = DateTime(
          now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
      /* print({dateTimeSelected});
      print({isStart}); */
      if (isStart) {
        setState(() {
          selectedTimeInicio = dateTimeSelected;
        });
        //Navigator.of(context).pop();
      } else {
        if (dateTimeSelected
            .isAfter(selectedTimeInicio!.add(Duration(minutes: 30)))) {
          setState(() {
            selectedTimeFim = dateTimeSelected;
            _updateValor();
          });
          //Navigator.of(context).pop();
        } else {
          // Mostrar mensagem de erro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'O horário de fim deve ser pelo menos 30 minutos após o início.'),
            ),
          );
        }
      }
    }
    /* showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isStart ? 'Horário de Início' : 'Horário de Fim'),
          content: HourPickerSpinner(
            is24HourMode: true,
            normalTextStyle: TextStyle(fontSize: 24, color: Colors.grey),
            highlightedTextStyle: TextStyle(fontSize: 24, color: Colors.black),
            spacing: 50,
            itemHeight: 80,
            isForce2Digits: true,
            onTimeChange: (time) {
              selectedTime = time;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                if (selectedTime != null) {
                  if (isStart) {
                    setState(() {
                      selectedTimeInicio = selectedTime;
                    });
                    Navigator.of(context).pop();
                  } else {
                    if (selectedTime!.isAfter(
                        selectedTimeInicio!.add(Duration(minutes: 30)))) {
                      setState(() {
                        selectedTimeFim = selectedTime;
                        _updateValor();
                      });
                      Navigator.of(context).pop();
                    } else {
                      // Mostrar mensagem de erro
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'O horário de fim deve ser pelo menos 30 minutos após o início.'),
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    ); */
  }

  bool _validateAddress() {
    return estado.isNotEmpty &&
        cidade.isNotEmpty &&
        enderecoController.text.isNotEmpty &&
        numeroController.text.isNotEmpty;
  }

  void _updateValor() {
    if (selectedTimeInicio != null && selectedTimeFim != null) {
      final timeDifference = selectedTimeFim!.difference(selectedTimeInicio!);
      if (timeDifference.inMinutes >= 30) {
        // Lógica para calcular o valor baseado no tempo e outros fatores
        double valorBase =
            timeDifference.inMinutes.toDouble() / 60 * valorHoraEnfermeiro;

        // Lógica para adicionar possíveis custos adicionais (exemplo: deslocamento)
        double custoDeslocamentoPercentual =
            0.10; // 10% do valorBase como custo de deslocamento
        double custoDeslocamento = valorBase * custoDeslocamentoPercentual;

        // Lógica para adicionar margem de lucro
        double margemLucroPercentual =
            0.20; // 20% do valorBase como margem de lucro
        double margemLucro = valorBase * margemLucroPercentual;

        valor = valorBase + custoDeslocamento + margemLucro;
      } else {
        // Defina um valor padrão ou mostre uma mensagem de erro
        // Exemplo:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('O tempo mínimo é de 30 minutos.'),
          ),
        );
      }
      setState(() {});
    }
  }

  Future<void> _showEditLocationAlert(BuildContext context) async {
    TextEditingController cidadeController =
        TextEditingController(text: cidade);
    TextEditingController estadoController =
        TextEditingController(text: estado);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Não pode ser fechado ao tocar fora
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Estado e Cidade'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CSCPicker(
                key: _cscPickerKey,
                layout: Layout.vertical,
                stateSearchPlaceholder: "Pesquise pelo nome do estado",
                citySearchPlaceholder: "Pesquise pelo nome da cidade",
                currentCountry: "Brazil",
                defaultCountry: CscCountry.Brazil,
                stateDropdownLabel: 'Selecione o estado',
                cityDropdownLabel: 'Selecione a cidade',
                currentState: estadoController.text,
                currentCity: cidadeController.text,
                disableCountry: true,
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
                    estadoController.text = value.toString();
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cidadeController.text = value.toString();
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (cidadeController.text.isNotEmpty &&
                    estadoController.text.isNotEmpty &&
                    cidadeController.text != 'City') {
                  setState(() {
                    cidade = cidadeController.text;
                    estado = estadoController.text;
                  });
                  Navigator.of(context).pop();
                } else {
                  // Mostrar mensagem de erro ou realizar alguma ação
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha cidade e estado.'),
                    ),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
