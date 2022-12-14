import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user_management/resources/borderDesigns.dart';
import 'package:user_management/screens/fireStore/dots.dart';

class ForgotPswdPage extends StatefulWidget {
  const ForgotPswdPage({Key? key}) : super(key: key);

  @override
  State<ForgotPswdPage> createState() => _ForgotPswdPageState();
}

class _ForgotPswdPageState extends State<ForgotPswdPage>with BorderDesign {
  String strPassword = "";
  String strConfirmPassword= "";
  double borderRadius = 12;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String docId = "";

  @override
  void initState() {
    // TODO: implement initState
    docId = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children:[
              showPasswordTextField("New Password"),
              showConfirmPasswordTextField("Confirm Password"),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              changePassword();
                            }
                          },
                          child: const Text(
                            "Change Password",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          )),
                    ),
                  ),
                ],
              )

            ]
          ),
        ),
      )
    );
  }
  Widget showPasswordTextField(String label) {
    RxBool showPwsd = false.obs;
    return Obx(
      ()=> Padding(
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
                  : InkWell(onTap: () => showPwsd.value = !showPwsd.value, child: const Icon(Icons.visibility_off))
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
      ),
    );
  }

  Widget showConfirmPasswordTextField(String label) {
    RxBool showPwsd = false.obs;
    return Obx(
      ()=>Padding(
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
                  : InkWell(onTap: () => showPwsd.value = !showPwsd.value, child: const Icon(Icons.visibility_off))
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "Enter Password";
            }
            return null;
          },
          onSaved: (value) {
            strConfirmPassword = value ?? "";
          },
        ),
      ),
    );
  }

  void changePassword(){
    if(strPassword==strConfirmPassword){
      FirebaseFirestore.instance.collection(FireStoreDots.userCollection).doc(docId).update({
        "password":strConfirmPassword
      }).then((value) async {
        await ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password Updated"),
        )).closed;
        Get.back();
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password Incorrect"),
      )).closed;
    }
  }

}
