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
  var HoraInicio = "inicio";
  var Horafim = "fim";
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
                controller:dataController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: 'Selecione a data',
                ),
                onTap: () async{
                  DateTime? pickddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));
                  if (pickddate != null) {
                      setState(() {
                        dataController.text =
                            DateFormat('dd/MM/yyyy').format(pickddate);
                      });
                    };
              }),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: ()  async {
                          final TimeOfDay? timeOfDay = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                            initialEntryMode: TimePickerEntryMode.dial,
                          );
                          if (TimeOfDay != null) {
                            setState(() {
                              HoraInicio =
                                  timeOfDay!.format(context).characters.string;
                            });
                          };
                        },
                  
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF73C9C9), // Cor do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Torna o botão redondo
                      ),
                    ),
                    child: Text('${HoraInicio}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: ()  async {
                          final TimeOfDay? timeOfDay = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                            initialEntryMode: TimePickerEntryMode.dial,
                          );
                          if (TimeOfDay != null) {
                            setState(() {
                              Horafim =
                                  timeOfDay!.format(context).characters.string;
                            });
                          };
                        },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF73C9C9), // Cor do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Torna o botão redondo
                      ),
                    ),
                    child: Text(
                      '${Horafim}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF73C9C9), // Cor do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Torna o botão redondo
                      ),
                    ),
                    child: Text(
                      'Salvo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _exibirCamposEndereco = !_exibirCamposEndereco;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF73C9C9), // Cor do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Torna o botão redondo
                      ),
                    ),
                    child: Text(
                      'Novo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              if (_exibirCamposEndereco)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      // Campo de CEP
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'CEP',
                      ),
                    ),
                    TextFormField(
                      // Campo de Cidade
                      decoration: InputDecoration(
                        hintText: 'Cidade',
                      ),
                    ),
                    TextFormField(
                      // Campo de Endereço
                      decoration: InputDecoration(
                        hintText: 'Endereço',
                      ),
                    ),
                    TextFormField(
                      // Campo de Complemento
                      decoration: InputDecoration(
                        hintText: 'Complemento (opcional)',
                      ),
                    ),
                    TextFormField(
                      // Campo de Número
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Número',
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/solicitarCuidador2');
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF73C9C9), // Cor do botão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Torna o botão redondo
                  ),
                ),
                child: Text(
                  'Prosseguir',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
