import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'package:user_management/routers/router.dart';

final sendBird = SendbirdSdk(appId: "C5752D21-333C-4A8C-A583-AD49AD76DEE8");

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AppInit());
}


class AppInit extends StatefulWidget {
  const AppInit({Key? key}) : super(key: key);

  @override
  State<AppInit> createState() => _AppInitState();
}

class _AppInitState extends State<AppInit> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: GetPageRouter.loginPageRoute,
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      getPages: GetPageRouter.routes,
    );
  }
}
