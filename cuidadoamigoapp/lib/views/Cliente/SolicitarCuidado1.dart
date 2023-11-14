import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/widgets/HourPickerSpinner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';


class SolicitarCuidado1 extends StatefulWidget {
  const SolicitarCuidado1({Key? key}) : super(key: key);

  @override
  _SolicitarCuidado1State createState() => _SolicitarCuidado1State();
}

class _SolicitarCuidado1State extends State<SolicitarCuidado1> {
  bool _exibirCamposEndereco = true; // Modificado para sempre mostrar os campos de endereço

  TextEditingController dataController = TextEditingController();
  DateTime? selectedTimeInicio;
  DateTime? selectedTimeFim;
  TextEditingController numeroController = TextEditingController();
  TextEditingController complementoController = TextEditingController();
  String estado = '';
  String cidade = '';
  TextEditingController enderecoController = TextEditingController();
  double valor = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey<CSCPickerState>();



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
                  }
                },
              ),
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
                          style: const TextStyle(color: Colors.white, fontSize: 16),
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
                          style: const TextStyle(color: Colors.white, fontSize: 16),
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
                          enderecoController.clear();
                          numeroController.clear();
                          complementoController.clear();
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
                    CSCPicker(
                      currentCountry: "Brazil",
                      defaultCountry: CscCountry.Brazil,
                      currentState: estado,
                      currentCity: cidade,
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
                          estado = value.toString();
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cidade =  value.toString();
                        });
                      },
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
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedTimeInicio != null &&
                        selectedTimeFim != null &&
                        selectedTimeFim!.isAfter(selectedTimeInicio!.add(Duration(minutes: 30))) &&
                        _validateAddress()) {
                      final dataToPass = {
                        'data': dataController.text,
                        'horaInicio': DateFormat('HH:mm').format(selectedTimeInicio!),
                        'horaFim': DateFormat('HH:mm').format(selectedTimeFim!),
                        'valor': valor,
                        'cidade': cidade,
                        'estado': estado,
                        'endereco': enderecoController.text,
                        'complemento': complementoController.text,
                        'numero': numeroController.text,
                      };
                      Navigator.of(context).pushNamed('/solicitarCuidador2', arguments: dataToPass);
                    } else {
                      // Mostrar uma mensagem de erro ou fazer alguma outra ação
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, verifique as informações e siga as regras.'),
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
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
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

  void _showTimePickerAlert(BuildContext context, bool isStart) {
    DateTime? selectedTime;
    showDialog(
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
                    if (selectedTime!.isAfter(selectedTimeInicio!.add(Duration(minutes: 30)))) {
                      setState(() {
                        selectedTimeFim = selectedTime;
                        _updateValor();
                      });
                      Navigator.of(context).pop();
                    } else {
                      // Mostrar mensagem de erro
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('O horário de fim deve ser pelo menos 30 minutos após o início.'),
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
    );
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
        valor = timeDifference.inMinutes.toDouble() / 60 * 20.0;
      } else {
        // Defina um valor padrão ou mostre uma mensagem de erro
      }
      setState(() {});
    }
  }
}
