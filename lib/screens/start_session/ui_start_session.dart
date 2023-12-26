import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';

class StartSessionScreen extends ConsumerStatefulWidget {
  const StartSessionScreen({required this.isPresentation, super.key});
  final bool isPresentation;

  @override
  ConsumerState<StartSessionScreen> createState() => _StartSessionScreenState();
}

class _StartSessionScreenState extends ConsumerState<StartSessionScreen> {
  List<Map<String, dynamic>> pdfData = [];
  bool _isLoading = false;
  File? _pickedFile;
  String? _fileName;
  Future<String> uploadPdfToFirebase(String fileName, File file) async {
    final reference = FirebaseStorage.instance.ref().child("files/$fileName");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() => {});
    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }

  final _fireStoreRef = FirebaseFirestore.instance;
  void pickFile() async {
    final pickedFileResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'pptx'],
    );

    if (pickedFileResult != null &&
        pickedFileResult.files.single.path != null) {
      setState(() {
        _pickedFile = File(pickedFileResult.files.single.path!);
        _fileName = pickedFileResult.files.single.name;
      });
    }
  }

  Future<void> uploadFile() async {
    if (_pickedFile != null && _fileName != null) {
      try {
        setState(() {
          _isLoading = true;
        });

        final fileDownloadLink =
            await uploadPdfToFirebase(_fileName!, _pickedFile!);
        await _fireStoreRef.collection("files").add({
          "name": _fileName,
          "url": fileDownloadLink,
        });

        setState(() {
          _pickedFile = null;
          _fileName = null;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
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
                widget.isPresentation
                    ? Text(
                        "Attach your presentation",
                        style: Styles.displayLargeNormalStyle,
                      )
                    : Text(
                        "Attach your resume",
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
                        Text("Attach"),
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
                                  getFileExtension(_fileName!) == 'pdf'
                                      ? Icons.picture_as_pdf
                                      : Icons.slideshow,
                                  color: getFileExtension(_fileName!) == 'pdf'
                                      ? Colors.red
                                      : Colors.orange,
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
