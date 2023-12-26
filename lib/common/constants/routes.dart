import 'package:get/get.dart';
import 'package:prepvrse/screens/audio_upload/ui_audio_upload_screen.dart';
import 'package:prepvrse/screens/feedback/ui_feedback_screen.dart';
import 'package:prepvrse/screens/start_session/widgets/industry_selection/ui_industry_selection.dart';
import 'package:prepvrse/screens/login/ui_login_screen.dart';
import 'package:prepvrse/screens/start_session/widgets/mode_type/ui_mode_type_screen.dart';
import 'package:prepvrse/screens/signup/ui_signup_screen.dart';
import 'package:prepvrse/screens/fetched_questions/ui_fetch_questions_screen.dart';

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
    ];
