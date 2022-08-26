import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final void Function(String?) onSaved;

  const CustomTextFormField({
    Key? key,
    required this.label,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        label: Text(label),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
    );
  }
}
