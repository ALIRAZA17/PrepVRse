import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';

class AudioUploadScreen extends StatefulWidget {
  const AudioUploadScreen({super.key});

  @override
  State<AudioUploadScreen> createState() => _AudioUploadScreenState();
}

class _AudioUploadScreenState extends State<AudioUploadScreen> {
  Future<String> uploadAudioToFirebase(String fileName, File file) async {
    final reference = FirebaseStorage.instance.ref().child("audios/$fileName");

    final uploadTask = reference.putFile(file);

    await uploadTask.whenComplete(() => {});

    final downloadLink = await reference.getDownloadURL();

    return downloadLink;
  }

  final _fireStoreRef = FirebaseFirestore.instance;
  void pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (pickedFile != null) {
      final fileName = pickedFile.files[0].name;
      final file = File(pickedFile.files[0].path!);
      final audioFileDownloadLink = await uploadAudioToFirebase(fileName, file);
      _fireStoreRef.collection("audios").add(
        {
          "name": fileName,
          "url": audioFileDownloadLink,
        },
      );
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  height: 20,
                ),
                Text(
                  "Upload your audio",
                  style: Styles.displayLargeNormalStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromRGBO(250, 249, 246, 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: IconButton(
                            onPressed: pickFile,
                            icon: const Icon(Icons.upload_file_outlined),
                            iconSize: 40,
                          ),
                        ),
                        Text("Upload")
                      ],
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
              onTap: () {},
              color: Styles.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
