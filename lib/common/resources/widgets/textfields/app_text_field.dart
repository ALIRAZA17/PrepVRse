import 'package:flutter/material.dart';
import 'package:prepvrse/common/constants/styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.label,
    required this.keyboardType,
    required this.controller,
    required this.validator,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
  }) : super(key: key);

  final String label;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        key: Key('$key TextFormField'),
        decoration: InputDecoration(
          label: Text(
            label,
            style: Styles.displaySmNormalStyle.copyWith(
              color: Colors.grey,
            ),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: Color.fromRGBO(184, 184, 184, 1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Styles.primaryColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            left: 20,
            top: 19,
            bottom: 18,
          ),
        ),
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        maxLines: maxLines,
        minLines: minLines,
      ),
    );
  }
}
