import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';

class AudioUploadScreen extends StatefulWidget {
  const AudioUploadScreen({super.key});

  @override
  State<AudioUploadScreen> createState() => _AudioUploadScreenState();
}

class _AudioUploadScreenState extends State<AudioUploadScreen> {
  final _fireStoreRef = FirebaseFirestore.instance;
  bool _isLoading = false;
  File? _pickedFile;
  String? _fileName;
  String documentId = "";
  Future<String> uploadAudioToFirebase(String fileName, File file) async {
    final reference = FirebaseStorage.instance.ref().child("audios/$fileName");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() => {});
    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }

  void pickFile() async {
    final pickedFileResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (pickedFileResult != null &&
        pickedFileResult.files.single.path != null) {
      setState(() {
        _pickedFile = File(pickedFileResult.files.single.path!);
        _fileName = pickedFileResult.files.single.name;
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Get.back(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadFile() async {
    dynamic arguments = Get.arguments;
    String text = arguments["extracted_text"];
    if (_pickedFile != null && _fileName != null) {
      try {
        setState(() {
          _isLoading = true;
        });

        final fileDownloadLink =
            await uploadAudioToFirebase(_fileName!, _pickedFile!);
        final docRef = await _fireStoreRef.collection("audios").add({
          "name": _fileName,
          "url": fileDownloadLink,
        });

        documentId = docRef.id;
        setState(() {
          _pickedFile = null;
          _fileName = null;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      } finally {
        Get.toNamed(
          '/feedback',
          arguments: {
            "id": documentId,
            "text": text,
          },
        );
      }
    } else {
      showErrorDialog("Please attach a file before uploading.");
      return;
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
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Upload your audio",
                    style: Styles.displayXlBoldStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Allowed Formats: .mp3"),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 250,
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
                          Text("Choose File from Device"),
                          if (_fileName != null) ...[
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.music_video,
                                  ), // PDF Icon
                                  SizedBox(width: 8),
                                  Text(
                                    _fileName!,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ), // File name
                                ],
                              ),
                            ),
                          ]
                        ],
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
                    text: "Upload",
                    onTap: uploadFile,
                    color: Styles.primaryColor,
                  ),
                )
        ],
      ),
    );
  }
}
