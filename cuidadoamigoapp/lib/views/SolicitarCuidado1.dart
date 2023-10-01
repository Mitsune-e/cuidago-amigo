import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SolicitarCuidado1 extends StatefulWidget {
  const SolicitarCuidado1({Key? key}) : super(key: key);

  @override
  _SolicitarCuidado1State createState() => _SolicitarCuidado1State();
}

class _SolicitarCuidado1State extends State<SolicitarCuidado1> {
  bool _exibirCamposEndereco = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  var HoraInicio = "Início";
  var Horafim = "Fim";
  TextEditingController dataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar Cuidado'),
        backgroundColor: Color(0xFF73C9C9), // Cor principal da página
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Campo de data
              TextFormField(
                controller: dataController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
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
              SizedBox(height: 20),
              Text(
                'Horário',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? timeOfDay = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                          initialEntryMode: TimePickerEntryMode.dial,
                        );
                        if (timeOfDay != null) {
                          setState(() {
                            HoraInicio = timeOfDay.format(context);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF73C9C9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Início',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 4.0),
                            Icon(Icons.access_time, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'até',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? timeOfDay = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                          initialEntryMode: TimePickerEntryMode.dial,
                        );
                        if (timeOfDay != null) {
                          setState(() {
                            Horafim = timeOfDay.format(context);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF73C9C9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Fim',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 4.0),
                            Icon(Icons.access_time, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Endereço',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF73C9C9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Salvo',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _exibirCamposEndereco = !_exibirCamposEndereco;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF73C9C9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Padding(
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
                    SizedBox(height: 20),
                    TextFormField(
                      // Campo de CEP
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'CEP',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    TextFormField(
                      // Campo de Cidade
                      decoration: InputDecoration(
                        hintText: 'Cidade',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                    TextFormField(
                      // Campo de Endereço
                      decoration: InputDecoration(
                        hintText: 'Endereço',
                        prefixIcon: Icon(Icons.home),
                      ),
                    ),
                    TextFormField(
                      // Campo de Complemento
                      decoration: InputDecoration(
                        hintText: 'Complemento (opcional)',
                        prefixIcon: Icon(Icons.add),
                      ),
                    ),
                    TextFormField(
                      // Campo de Número
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Número',
                        prefixIcon: Icon(Icons.format_list_numbered),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/solicitarCuidador2');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF73C9C9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Padding(
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
}
