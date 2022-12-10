import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/routers/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3),() => Get.toNamed(GetPageRouter.loginPageRoute),);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("User Management")),
    );
  }
}
