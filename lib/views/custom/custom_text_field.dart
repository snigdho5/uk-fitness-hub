import 'package:dropdown_textfield/dropdown_textfield.dart';
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
  final bool showTitleAsHint;
  final int? maxLines;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.title,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.isNumber = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.showTitleAsHint = false,
    this.maxLines,
  });

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
        maxLines: obscureText ? 1 : maxLines,
        inputFormatters:
            isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(
          suffix: suffix != null ? Text(suffix!) : null,
          labelText: showTitleAsHint ? null : title,
          alignLabelWithHint: true,
          hintText: showTitleAsHint ? title : null,
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

class CustomDropdownTextField extends StatelessWidget {
  final SingleValueDropDownController contoller;
  final List<DropDownValueModel> items;
  final String title;
  final String? Function(String?)? validator;
  final bool isSearchable;

  const CustomDropdownTextField({
    super.key,
    required this.contoller,
    required this.items,
    required this.title,
    this.validator,
    this.isSearchable = false,
  });

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
      child: DropDownTextField(
        controller: contoller,
        dropDownList: items,
        validator: validator,
        enableSearch: isSearchable,
        textFieldDecoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kDefaultPadding),
              borderSide: const BorderSide(color: primaryColor)),
        ),
        dropdownRadius: kDefaultPadding,
        searchAutofocus: true,
        searchKeyboardType: TextInputType.text,
        dropDownIconProperty: IconProperty(color: primaryColor),
      ),
    );
  }
}
