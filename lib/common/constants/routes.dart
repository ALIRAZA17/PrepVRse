import 'package:get/get.dart';
import 'package:prepvrse/screens/audio_upload/ui_audio_upload_screen.dart';
import 'package:prepvrse/screens/feedback/ui_feedback_screen.dart';
import 'package:prepvrse/screens/feedback/ui_new_feedback_screen.dart';
import 'package:prepvrse/screens/start_session/ui_start_session.dart';
import 'package:prepvrse/screens/start_session/widgets/industry_selection/ui_industry_selection.dart';
import 'package:prepvrse/screens/login/ui_login_screen.dart';
import 'package:prepvrse/screens/start_session/widgets/mode_type/ui_mode_type_screen.dart';
import 'package:prepvrse/screens/signup/ui_signup_screen.dart';
import 'package:prepvrse/screens/fetched_questions/ui_fetch_questions_screen.dart';
import 'package:prepvrse/screens/start_session/widgets/mode_type/widgets/interview_questions.dart';
import 'package:prepvrse/screens/vr_session/ui_vr_session.dart';

appRoutes() => [
      GetPage(
        name: '/signup',
        page: () => const SignUpScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/login',
        page: () => const LoginScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/industry_selection',
        page: () => const IndustrySelectionScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/mode_type',
        page: () => const ModeTypeScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/audio_upload',
        page: () => const AudioUploadScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/generated_questions',
        page: () => GeneratedQuestionsScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/feedback',
        page: () => FeedBackScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/new_feedback',
        page: () => NewFeedBackScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/migrate_to_vr',
        page: () => SessionVR(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/start_session',
        page: () => StartSessionScreen(
          isPresentation: true,
        ),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/interview_questions',
        page: () => InterviewQuestions(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
    ];
