import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';

class CustomInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool? obscureText;

  final String formProperty;
  final Map<String, dynamic> formValues;

  const CustomInputField({
    Key? key,
    this.hintText,
    this.labelText,
    this.helperText,
    this.icon,
    this.suffixIcon,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText,
    required this.formProperty,
    required this.formValues,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: ThemeProvider.blueColor),
      textInputAction: TextInputAction.done,
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      obscureText: obscureText == null ? false : true,
      onChanged: (value) {
        (value != '') ? formValues[formProperty] = value : ' ';
      },
      validator: (value) {
        if (value == null) return 'Este campo es requerido';
        return value.length > 3 ? null : 'Se requieren al menos 3 caracteres.';
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.black38),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        suffixIconColor: ThemeProvider.lightColor,
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        suffixIcon: suffixIcon == null ? null : Icon(suffixIcon),
      ),
    );
  }
}
