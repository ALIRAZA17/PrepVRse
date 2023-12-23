import 'package:flutter/material.dart';
import 'package:prepvrse/common/constants/styles.dart';

class OptionsContainer extends StatelessWidget {
  const OptionsContainer({
    super.key,
    required this.industryName,
  });

  final industryName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.only(top: 15, left: 20),
          height: 65,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 160, 203, 224),
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Text(
            industryName,
            style: Styles.displayLargeBoldStyle,
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
