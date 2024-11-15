import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool mandatory;
  final Function(String) onChanged;

  const TextFieldComponent({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.label,
    required this.mandatory,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          onChanged: (text) {
            onChanged(text);
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
}
