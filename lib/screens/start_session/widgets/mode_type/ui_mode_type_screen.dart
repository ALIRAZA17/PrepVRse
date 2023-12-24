import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';
import 'package:prepvrse/screens/start_session/widgets/mode_type/providers/mode_type_provider.dart';
import 'package:prepvrse/screens/start_session/ui_start_session.dart';

class ModeTypeScreen extends ConsumerStatefulWidget {
  const ModeTypeScreen({super.key});

  @override
  ConsumerState<ModeTypeScreen> createState() => _ModeTypeScreenState();
}

class _ModeTypeScreenState extends ConsumerState<ModeTypeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    ref.read(modeTypeProvider.notifier).state = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? selectedValue;
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
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Select Mode Type",
                      style: Styles.displayXlBoldStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Select the type of mode you want to practice on",
                    style: Styles.displayMedLightStyle.copyWith(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
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
                        if (value == null || value.isEmpty) {
                          return 'Please select mode';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        selectedValue = value;
                        ref.read(modeTypeProvider.notifier).state =
                            selectedValue ?? "Presentation";
                      },
                      onSaved: (value) {
                        selectedValue = value.toString();
                      },
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
                ],
              ),
            ),
            Positioned(
              left: 10,
              bottom: 5,
              right: 10,
              child: AppTextButton(
                text: "Next",
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    final modeTypeValue =
                        ref.read(modeTypeProvider.notifier).state;
                    final isPresentation = modeTypeValue == "Presentation";
                    Get.to(
                      () => StartSessionScreen(isPresentation: isPresentation),
                    );
                  }
                },
                color: Styles.primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
