import 'package:get/get.dart';
import 'package:prepvrse/screens/home/ui_home_screen.dart';
import 'package:prepvrse/screens/industry_selection/ui_industry_selection.dart';
import 'package:prepvrse/screens/login/ui_login_screen.dart';
import 'package:prepvrse/screens/signup/ui_signup_screen.dart';

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
        name: '/home',
        page: () => const HomeScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: '/industry_selection',
        page: () => const IndustrySelectionScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
      ),
    ];
