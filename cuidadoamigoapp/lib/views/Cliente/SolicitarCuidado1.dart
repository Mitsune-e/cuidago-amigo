import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class SolicitarCuidado1 extends StatefulWidget {
  const SolicitarCuidado1({Key? key}) : super(key: key);

  @override
  _SolicitarCuidado1State createState() => _SolicitarCuidado1State();
}

class _SolicitarCuidado1State extends State<SolicitarCuidado1> {
  bool _exibirCamposEndereco = false;

  TextEditingController dataController = TextEditingController();
  DateTime? selectedTimeInicio;
  DateTime? selectedTimeFim;

  TextEditingController cepController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController enderecoController = TextEditingController();
  TextEditingController complementoController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  double valor = 0.0;

  @override
  void dispose() {
    dataController.dispose();
    cepController.dispose();
    cidadeController.dispose();
    enderecoController.dispose();
    complementoController.dispose();
    numeroController.dispose();
    super.dispose();
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
                          style: const TextStyle(color: Colors.white),
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
                          style: const TextStyle(color: Colors.white),
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
                ),
              ),
              const Text(
                'Endereço',
                style: TextStyle(
          
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
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
                          _exibirCamposEndereco = !_exibirCamposEndereco;
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
                    TextFormField(
                      // Campo de CEP
                      controller: cepController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'CEP',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    TextFormField(
                      // Campo de Cidade
                      controller: cidadeController,
                      decoration: const InputDecoration(
                        hintText: 'Cidade',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                    TextFormField(
                      // Campo de Endereço
                      controller: enderecoController,
                      decoration: const InputDecoration(
                        hintText: 'Endereço',
                        prefixIcon: Icon(Icons.home),
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
                    TextFormField(
                      // Campo de Número
                      controller: numeroController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Número',
                        prefixIcon: Icon(Icons.format_list_numbered),
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
                        'cep': cepController.text,
                        'cidade': cidadeController.text,
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
          content: TimePickerSpinner(
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
    return cepController.text.isNotEmpty &&
        cidadeController.text.isNotEmpty &&
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
