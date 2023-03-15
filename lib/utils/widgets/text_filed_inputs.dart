import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final EdgeInsets textInputPadding;
  final TextInputType textInputType;
  final Text labelText;
  final bool isPassword;
  const TextFieldInput(
      {Key? key,
      required this.textInputPadding,
      required this.labelText,
      this.isPassword = false,
      required this.textEditingController,
      required this.textInputType})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        label: labelText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: textInputPadding,
      ),
      keyboardType: textInputType,
      obscureText: isPassword,
    );
  }
}
