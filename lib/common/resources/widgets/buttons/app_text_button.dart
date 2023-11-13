import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    this.textColor,
    this.addBorder = false,
    this.borderColor,
    this.fontSize = 16,
  });

  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final bool addBorder;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(color ?? Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
                color: borderColor ?? const Color.fromRGBO(184, 184, 184, 1)),
          ),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.only(top: 15.5, bottom: 15.5, left: 70, right: 70),
        ),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor ?? Colors.white,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
