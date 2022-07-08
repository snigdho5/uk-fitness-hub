import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ukfitnesshub/config/constants.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String? Function(String? value)? validator;
  final String? Function(String? value)? onChanged;
  final bool obscureText;
  final bool isNumber;
  final TextInputType keyboardType;
  final String? suffix;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.title,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.isNumber = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultPadding),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 6), blurRadius: 4, color: Colors.black12),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters:
            isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(
          suffix: suffix != null ? Text(suffix!) : null,
          labelText: title,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kDefaultPadding),
              borderSide: const BorderSide(color: primaryColor)),
        ),
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText,
      ),
    );
  }
}
