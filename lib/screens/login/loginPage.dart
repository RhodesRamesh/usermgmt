import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:user_management/resources/borderDesigns.dart';
import 'package:user_management/resources/colors.dart';
import 'package:user_management/resources/dimen.dart';
import 'package:user_management/routers/router.dart';
import 'package:user_management/screens/fireStore/dots.dart';
import 'package:user_management/screens/fireStore/entity/User.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with BorderDesign, Dimension {
  double borderRadius = 12;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String strPassword;
  late String strEmail;
  RxBool showPwsd = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Login",
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.w800, fontSize: 32),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: SvgPicture.asset("assets/logo/usermgmt.svg", fit: BoxFit.fitHeight),
                    ),
                    showEmailTextField("Email"),
                    Obx(() => showPasswordTextField("Password")),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    callLoginAuth();
                                  }
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white, fontSize: 22),
                                )),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                      child: InkWell(
                          onTap: () => Get.dialog(showEmailDialog()),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w400, fontSize: 16),
                          )),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
                onTap: () => Get.toNamed(GetPageRouter.userAddRoute),
                child: Text(
                  "New user? Click Here",
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.w800, fontSize: 22),
                ))
          ],
        ),
      ),
    );
  }

  Widget showPasswordTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.text,
        inputFormatters: [LengthLimitingTextInputFormatter(15)],
        obscureText: showPwsd.value,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.only(left: 15, top: 15, bottom: 10, right: 15),
            hintText: label,
            hintStyle: const TextStyle(color: Colors.black),
            border: inputdecBorderStyle(borderRadius),
            enabledBorder: inputdecEnableborderStyle(borderRadius),
            focusedBorder: inputdecFocusedborderStyle(borderRadius),
            suffix: showPwsd.value
                ? InkWell(onTap: () => showPwsd.value = !showPwsd.value, child: const Icon(Icons.visibility))
                : InkWell(onTap: () => showPwsd.value = !showPwsd.value, child: const Icon(Icons.visibility_off))),
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Password";
          }
          return null;
        },
        onSaved: (value) {
          strPassword = value ?? "";
        },
      ),
    );
  }

  Widget showEmailTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(left: 15, top: 15, bottom: 10, right: 15),
          hintText: label,
          hintStyle: const TextStyle(color: Colors.black),
          border: inputdecBorderStyle(borderRadius),
          enabledBorder: inputdecEnableborderStyle(borderRadius),
          focusedBorder: inputdecFocusedborderStyle(borderRadius),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Email";
          }
          return null;
        },
        onSaved: (value) {
          strEmail = value ?? "";
        },
      ),
    );
  }

  void callLoginAuth() {
    var data = FirebaseFirestore.instance.collection(FireStoreDots.userCollection).where("emailId", isEqualTo: strEmail).limit(1).get();
    User user;
    data.then((value) {
      if (value.docs.isNotEmpty) {
        user = User.fromMap(value.docs[0].data());
        if (user.password == strPassword) {
          Get.toNamed(GetPageRouter.userListRoute);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Password wrong"),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Mail ID not found"),
        ));
      }
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    });
  }

  Widget showEmailDialog() {
    final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
    return AlertDialog(
      title: const Text("Enter mailId"),
      content: TextFormField(
        key: _emailKey,
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(left: 15, top: 15, bottom: 10, right: 15),
          hintText: "Email Id",
          hintStyle: const TextStyle(color: Colors.black),
          border: inputdecBorderStyle(borderRadius),
          enabledBorder: inputdecEnableborderStyle(borderRadius),
          focusedBorder: inputdecFocusedborderStyle(borderRadius),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Email";
          }
          return null;
        },
        onSaved: (value) {
          strEmail = value ?? "";
        },
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              if (_emailKey.currentState!.validate()) {
                _emailKey.currentState!.save();
                callForgotPswd();
              }
            },
            child: const Text(
              "Continue",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ))
      ],
    );
  }

  void callForgotPswd() {
    var data = FirebaseFirestore.instance.collection(FireStoreDots.userCollection).where("emailId", isEqualTo: strEmail).limit(1).get();
    data.then((value) {
      if (value.docs.isNotEmpty) {
        User user = User.fromMap(value.docs[0].data());
        Get.back();
        Logger().i(user.toMap());
        Get.toNamed(GetPageRouter.forgotPswdPageRoute, arguments: value.docs[0].id);
      } else {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Mail ID not found"),
        ));
      }
    });
  }
}
