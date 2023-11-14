import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';

class CustomCSCPicker extends StatefulWidget {
  final String currentCountry;
  String currentState;
  String currentCity;
  final bool disableCountry;

  CustomCSCPicker({
    required this.currentCountry,
    required this.currentState,
    required this.currentCity,
    required this.disableCountry,
  });

  @override
  _CustomCSCPickerState createState() => _CustomCSCPickerState();
}

class _CustomCSCPickerState extends State<CustomCSCPicker> {
  late CSCPicker _cscPicker;

  @override
  void initState() {
    super.initState();
    _cscPicker = CSCPicker(
      currentCountry: widget.currentCountry,
      currentState: widget.currentState,
      currentCity: widget.currentCity,
      disableCountry: widget.disableCountry,
      // Outros parâmetros necessários para o CSCPicker
    );
  }

 void updateData(String newState, String newCity) {
    setState(() {
      widget.currentState = newState;
      widget.currentCity = newCity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _cscPicker;
  }
}
