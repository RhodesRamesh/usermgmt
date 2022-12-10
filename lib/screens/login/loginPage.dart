import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user_management/resources/borderDesigns.dart';
import 'package:user_management/resources/colors.dart';
import 'package:user_management/routers/router.dart';
import 'package:user_management/screens/fireStore/dots.dart';
import 'package:user_management/screens/fireStore/entity/User.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with BorderDesign {
  double borderRadius = 12;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String strPassword;
  late String strEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("Login",style: TextStyle(color: primaryColor,fontWeight: FontWeight.w800,fontSize: 32),),
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  showPhoneTextField("Email"),
                  showPasswordTextField("Password"),
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
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: ()=>Get.toNamed(GetPageRouter.userAddRoute),
              child: Text("New user? Click Here",style: TextStyle(color: primaryColor,fontWeight: FontWeight.w800,fontSize: 22),))
        ],
      ),
    );
  }

  Widget showPasswordTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.text,
        inputFormatters: [LengthLimitingTextInputFormatter(15)],
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

  Widget showPhoneTextField(String label) {
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
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Mail ID not found"),
        ));
      }
    }).onError((error, stackTrace){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    });
  }
}
