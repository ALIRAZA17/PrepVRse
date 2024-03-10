import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';
import 'package:prepvrse/screens/start_session/widgets/mode_type/providers/mode_type_provider.dart';
import 'package:prepvrse/screens/start_session/ui_start_session.dart';

enum MenuOption { logout }

enum StatusOption { started, fileUploaded, audioUploaded, reportGenerated }

class ModeTypeScreen extends ConsumerStatefulWidget {
  const ModeTypeScreen({super.key});

  @override
  ConsumerState<ModeTypeScreen> createState() => _ModeTypeScreenState();
}

class _ModeTypeScreenState extends ConsumerState<ModeTypeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      ref.read(modeTypeProvider.notifier).state = "";
    });
    super.initState();
  }

  void onSelected(BuildContext context, MenuOption item) {
    switch (item) {
      case MenuOption.logout:
        FirebaseAuth.instance.signOut();
        Get.toNamed('/login');
        break;
    }
  }

  Future<bool> createSession() async {
    try {
      Map<String, dynamic> sessionData = {
        'questionsGenerated': <List<String>>[],
        'audioFilePath': "",
        'filePath': "",
        'reportGenerated': "",
        'status': StatusOption.started.name,
      };

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final collectionRef = FirebaseFirestore.instance.collection('sessions');
        final docRef = collectionRef.doc(userId);
        final docSnapshot = await docRef.get();

        if (!docSnapshot.exists) {
          await docRef.set({
            'sessions': [sessionData]
          });
        } else {
          List<dynamic> sessions =
              List.from(docSnapshot.data()?['sessions'] ?? []);
          sessions.add(sessionData);
          await docRef.update({'sessions': sessions});
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
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
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<MenuOption>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOption>>[
              const PopupMenuItem<MenuOption>(
                value: MenuOption.logout,
                child: Text('Logout'),
              ),
            ],
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
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
            ),
            _isLoading
                ? Positioned(
                    left: 10,
                    bottom: 10,
                    right: 10,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Positioned(
                    left: 10,
                    bottom: 5,
                    right: 10,
                    child: AppTextButton(
                      text: "Next",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          bool sessionCreated = await createSession();

                          if (sessionCreated) {
                            final modeTypeValue =
                                ref.read(modeTypeProvider.notifier).state;
                            final isPresentation =
                                modeTypeValue == "Presentation";
                            Get.to(
                              () => StartSessionScreen(
                                  isPresentation: isPresentation),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Failed to create session. Please try again."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }

                          setState(() {
                            _isLoading = false;
                          });
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
