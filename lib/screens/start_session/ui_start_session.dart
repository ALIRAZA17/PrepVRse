import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';
import 'package:prepvrse/screens/start_session/widgets/mode_type/ui_mode_type_screen.dart';

class StartSessionScreen extends ConsumerStatefulWidget {
  const StartSessionScreen({required this.isPresentation, super.key});
  final bool isPresentation;

  @override
  ConsumerState<StartSessionScreen> createState() => _StartSessionScreenState();
}

class _StartSessionScreenState extends ConsumerState<StartSessionScreen> {
  bool _isLoading = false;
  File? _pickedFile;
  String? _fileName;
  String documentId = "";
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
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadFile() async {
    if (_pickedFile != null && _fileName != null) {
      try {
        setState(() {
          _isLoading = true;
        });

        final fileDownloadLink =
            await uploadPdfToFirebase(_fileName!, _pickedFile!);
        final docRef = await _fireStoreRef.collection("files").add({
          "name": _fileName,
          "url": fileDownloadLink,
        });

        documentId = docRef.id;

        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          final userDocRef = _fireStoreRef.collection('sessions').doc(userId);
          final docSnapshot = await userDocRef.get();

          if (docSnapshot.exists &&
              docSnapshot.data()?.containsKey('sessions') == true) {
            List<dynamic> sessions = List.from(docSnapshot.data()!['sessions']);
            if (sessions.isNotEmpty) {
              sessions.last['filePath'] = fileDownloadLink;
              sessions.last['status'] = StatusOption.fileUploaded.name;
              await userDocRef.update({'sessions': sessions});
            }
          }
        }

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
          '/generated_questions',
          arguments: {
            "id": documentId,
          },
        );
      }
    } else {
      showErrorDialog("Please attach a file before uploading.");
      return;
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
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  widget.isPresentation
                      ? Text(
                          "Upload your presentation",
                          style: Styles.displayXlBoldStyle,
                        )
                      : Text(
                          "Attach your resume",
                          style: Styles.displayLargeNormalStyle,
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Allowed Formats: .pptx & .pdf"),
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
