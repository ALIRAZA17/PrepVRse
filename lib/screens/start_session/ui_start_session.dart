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
  Future<String> uploadPdfToFirebase(String fileName, File file) async {
    final reference = FirebaseStorage.instance.ref().child("pdfs/$fileName");

    final uploadTask = reference.putFile(file);

    await uploadTask.whenComplete(() => {});

    final downloadLink = await reference.getDownloadURL();

    return downloadLink;
  }

  final _fireStoreRef = FirebaseFirestore.instance;
  void pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'pptx'],
    );

    if (pickedFile != null) {
      final fileName = pickedFile.files[0].name;
      final file = File(pickedFile.files[0].path!);
      final fileDownloadLink = await uploadPdfToFirebase(fileName, file);
      _fireStoreRef.collection("pdfs").add(
        {
          "name": fileName,
          "url": fileDownloadLink,
        },
      );
      if (mounted) {
        setState(() {});
      }
      getPdf();
    }
  }

  void getPdf() async {
    final fetchedPdf = await _fireStoreRef.collection("pdfs").get();
    pdfData = fetchedPdf.docs.map((e) => e.data()).toList();

    if (mounted) {
      setState(() {});
    }
    setState(() {});
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
                        Text("Upload")
                      ],
                    ),
                  ),
                ),
                pdfData.length > 0
                    ? Container(
                        padding: EdgeInsets.all(
                            8), // Add padding around the container
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius:
                              BorderRadius.circular(8), // Round the corners
                        ),
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min, // Use the minimum space
                          children: [
                            Icon(Icons.picture_as_pdf,
                                color: Colors.red), // PDF Icon
                            SizedBox(width: 8), // Space between icon and text
                            Text(pdfData[0]['name'],
                                style: TextStyle(fontSize: 16)), // File name
                          ],
                        ),
                      )
                    : Center(
                        child: Text("No file uploaded yet"),
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
