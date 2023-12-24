import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/options/optionsContainer.dart';

class IndustrySelectionScreen extends ConsumerStatefulWidget {
  const IndustrySelectionScreen({super.key});

  @override
  ConsumerState<IndustrySelectionScreen> createState() =>
      _IndustrySelectionScreenState();
}

class _IndustrySelectionScreenState
    extends ConsumerState<IndustrySelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final industries = [
      "Software Engineering",
      "Electrical Engineering",
      "Chemical Engineering",
      "Environmental Sciences",
      "Economics Sciences",
      "Materials Engineering",
    ];
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.blueGrey,
              ],
              begin: FractionalOffset(0.0, 0.4),
              end: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
                width: MediaQuery.of(context).size.width,
                height: 210,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Select Industry",
                      style: Styles.displayLargeBoldStyle.copyWith(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Select the industry you currently work or aim to work in the future",
                      style: Styles.displayMedLightStyle.copyWith(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return OptionsContainer(
                        industryName: industries[index],
                      );
                    },
                    itemCount: industries.length,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
