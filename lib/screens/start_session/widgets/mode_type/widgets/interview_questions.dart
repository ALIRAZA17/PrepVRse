import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';
import 'package:prepvrse/common/resources/widgets/textfields/app_text_field.dart';
import 'package:prepvrse/screens/start_session/ui_start_session.dart';
import 'package:prepvrse/screens/start_session/widgets/mode_type/providers/interview_position_experience_text_controller_provider.dart';
import 'package:prepvrse/screens/start_session/widgets/mode_type/providers/interview_position_text_controller_provider.dart';
import 'package:prepvrse/screens/start_session/widgets/mode_type/providers/job_description_text_controller_provider.dart';

class InterviewQuestions extends ConsumerStatefulWidget {
  const InterviewQuestions({super.key});

  @override
  ConsumerState<InterviewQuestions> createState() => _InterviewQuestionsState();
}

class _InterviewQuestionsState extends ConsumerState<InterviewQuestions> {
  @override
  Widget build(BuildContext context) {
    final positionController =
        ref.watch(interviewPositionTextControllerProvider);
    final positionExperienceController =
        ref.watch(interviewPositionExperienceTextControllerProvider);
    final jobDescriptionController =
        ref.watch(jobDescriptionTextControllerProvider);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Questions'),
        backgroundColor: Styles.primaryColor,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Positioned.fill(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    AppTextField(
                      label: "Position you're applying for?",
                      keyboardType: TextInputType.text,
                      controller: positionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Position is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    AppTextField(
                      label: "Experience in the particular field?",
                      keyboardType: TextInputType.text,
                      controller: positionExperienceController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Experience is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    AppTextField(
                      label: "Job Description?",
                      keyboardType: TextInputType.multiline,
                      controller: jobDescriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Job Description is required';
                        }
                        return null;
                      },
                      maxLines: null,
                      minLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            left: 10,
            child: AppTextButton(
              text: 'Next',
              onTap: () {
                if (formKey.currentState!.validate()) {
                  Get.to(
                    () => const StartSessionScreen(
                      isPresentation: false,
                    ),
                    arguments: {
                      'position': positionController.text,
                      'experience': positionExperienceController.text,
                      'jd': jobDescriptionController.text,
                    },
                  );
                }
              },
              color: Styles.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
