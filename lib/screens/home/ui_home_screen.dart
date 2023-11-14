import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> modes = [
      'Interview',
      'Presentation',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Styles.primaryColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Start New Session",
                    style: Styles.displayXlBoldStyle,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    hint: const Text(
                      'Select Mode Type',
                      style: TextStyle(fontSize: 14),
                    ),
                    items: modes
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {},
                    onSaved: (value) {},
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Attach Presentation/Resume",
                  style: Styles.displayLargeBoldStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 207, 203, 203),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.upload_file),
                        iconSize: 40,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 10,
            bottom: 5,
            right: 10,
            child: AppTextButton(
              text: "Start Session",
              onTap: () {},
              color: Styles.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
