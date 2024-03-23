import 'package:flutter/material.dart';
import 'package:task_manager_app/presentation/controllers/auth_controller.dart';
import 'package:task_manager_app/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager_app/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_app/presentation/widgets/app_logo.dart';
import 'package:task_manager_app/presentation/widgets/background_widget.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }
  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    bool isLoggedIn = await AuthController.isUserLoggedIn();

    if (mounted) {
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainBottomNavScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: BackgroundWidget(
          child: Center(
            child: AppLogo(),
          ),
        )
    );
  }
}
