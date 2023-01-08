import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:user_management/resources/borderDesigns.dart';
import 'package:user_management/resources/colors.dart';
import 'package:user_management/routers/router.dart';
import 'package:user_management/screens/fireStore/dots.dart';
import 'package:user_management/screens/fireStore/entity/Admin.dart';
import 'package:user_management/screens/fireStore/entity/InviteTracker.dart';
import 'package:user_management/screens/fireStore/entity/User.dart';
import 'package:user_management/screens/fireStore/entity/orgTypes.dart';
import 'package:user_management/screens/fireStore/sendMail.dart';

class UserAdd extends StatefulWidget {
  const UserAdd({Key? key}) : super(key: key);

  @override
  State<UserAdd> createState() => _UserAddState();
}

class _UserAddState extends State<UserAdd> with BorderDesign {
  double borderRadius = 8;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String strPassword;
  late String strName;
  late String strEmail;
  late String strPhone;
  late String strBusinessName;
  late String strIncorporationType;
  late String strYear;
  late String strKeyFunctionary;
  late String strServicesOrProducts;
  late String strLocation;
  late String strWebsite;
  late String strDescription;
  late String strVision;
  String strOrgName = "";
  List<OrgType> orgTypes = [];

  @override
  void initState() {
    // TODO: implement initState
    getOrgType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add User",
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          showNameTextField("Name"),
                          showEmailTextField("Email"),
                          showPhoneTextField("Phone Number"),
                          showPasswordTextField("Password"),
                          Text(
                            "Organization Type",
                            style: TextStyle(fontSize: 18, color: primaryColor),
                          ),
                          showOrgTypeDropdown(),
                          showBusinessNameTextField("Business Name"),
                          showIncorporationTypeTextField("Incorporation Type"),
                          showYearTextField("Year"),
                          showKeyFunctionaryTextField("Key Functionary"),
                          showServicesOrProductsTextField("Services or Products"),
                          showLocationTextField("Location"),
                          showWebsiteTextField("Website"),
                          showDescriptionTextField("Description"),
                          showVisionTextField("Vision"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              callSaveMethod();
                            }
                          },
                          child: const Text(
                            "Save",
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
    );
  }

  Widget showTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
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
            return "Enter Name";
          }
          return null;
        },
      ),
    );
  }

  Widget showNameTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.name,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        textCapitalization: TextCapitalization.words,
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
            return "Enter Name";
          }
          return null;
        },
        onSaved: (value) {
          strBusinessName = value ?? "";
        },
      ),
    );
  }

  Widget showEmailTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        keyboardType: TextInputType.emailAddress,
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

  Widget showPhoneTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
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
            return "Enter Phone";
          }
          return null;
        },
        onSaved: (value) {
          strPhone = value ?? "";
        },
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

  Widget showBusinessNameTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.text,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        textCapitalization: TextCapitalization.words,
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
            return "Enter Business Name";
          }
          return null;
        },
        onSaved: (value) {
          strName = value ?? "";
        },
      ),
    );
  }

  Widget showIncorporationTypeTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.text,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        textCapitalization: TextCapitalization.words,
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
            return "Enter IncorporationType";
          }
          return null;
        },
        onSaved: (value) {
          strIncorporationType = value ?? "";
        },
      ),
    );
  }

  Widget showYearTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.datetime,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        textCapitalization: TextCapitalization.words,
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
            return "Enter Year";
          }
          return null;
        },
        onSaved: (value) {
          strYear = value ?? "";
        },
      ),
    );
  }

  Widget showKeyFunctionaryTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.text,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        textCapitalization: TextCapitalization.words,
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
            return "Enter Key Functionary";
          }
          return null;
        },
        onSaved: (value) {
          strKeyFunctionary = value ?? "";
        },
      ),
    );
  }

  Widget showServicesOrProductsTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.text,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        textCapitalization: TextCapitalization.words,
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
            return "Enter Services or Products";
          }
          return null;
        },
        onSaved: (value) {
          strServicesOrProducts = value ?? "";
        },
      ),
    );
  }

  Widget showLocationTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.text,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        textCapitalization: TextCapitalization.words,
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
            return "Enter Location";
          }
          return null;
        },
        onSaved: (value) {
          strLocation = value ?? "";
        },
      ),
    );
  }

  Widget showWebsiteTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.url,
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        textCapitalization: TextCapitalization.words,
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
            return "Enter a website";
          }
          return null;
        },
        onSaved: (value) {
          strWebsite = value ?? "";
        },
      ),
    );
  }

  Widget showDescriptionTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        inputFormatters: [LengthLimitingTextInputFormatter(100)],
        textCapitalization: TextCapitalization.words,
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
            return "Enter Description";
          }
          return null;
        },
        onSaved: (value) {
          strDescription = value ?? "";
        },
      ),
    );
  }

  Widget showVisionTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        keyboardType: TextInputType.text,
        inputFormatters: [LengthLimitingTextInputFormatter(100)],
        textCapitalization: TextCapitalization.words,
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
            return "Enter Vision";
          }
          return null;
        },
        onSaved: (value) {
          strVision = value ?? "";
        },
      ),
    );
  }

  void callSaveMethod() async {
    try {
      var data =
          await FirebaseFirestore.instance.collection(FireStoreDots.inviteTrackerCollection).where("emailId", isEqualTo: strEmail).limit(1).get();
      if (data.docs.isNotEmpty) {
        await ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
              content: Text("Mail Id already Exist"),
            ))
            .closed;
        return;
      }
      User user = User(strOrgName, strName, strEmail, strPassword, strPhone, strBusinessName, strIncorporationType, strYear, strKeyFunctionary,
          strServicesOrProducts, strLocation, strWebsite, strDescription, strVision, "", "");
      await FirebaseFirestore.instance.collection(FireStoreDots.userCollection).add(user.toMap());

      SendMail sendmail = SendMail();
      data = await FirebaseFirestore.instance.collection(FireStoreDots.adminCollection).limit(1).get();
      if (data.docs.isNotEmpty) {
        Admin admin = Admin.fromMap(data.docs[0].data());
        String adminMail = admin.emailId;
        sendmail.sendAMailTo(adminMail, user.name, strOrgName);
        InviteTracker tracker = InviteTracker(0, strEmail, 0);
        await FirebaseFirestore.instance.collection(FireStoreDots.inviteTrackerCollection).add(tracker.toMap());
      }
    } catch (e) {
      Logger().e(e);
    } finally {
      Get.offNamed(GetPageRouter.loginPageRoute);
    }
  }

  Widget showOrgTypeDropdown() {
    return DropdownButtonFormField(
      items: orgTypes.map((OrgType value) {
        return DropdownMenuItem<String>(
          value: value.orgName,
          child: Text(value.orgName),
        );
      }).toList(),
      onChanged: (String? value) {
        strOrgName = value ?? "";
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  void getOrgType() async {
    var data = await FirebaseFirestore.instance.collection(FireStoreDots.orgTypesCollection).get();
    for (var element in data.docs) {
      OrgType orgType = OrgType.fromMap(element.data());
      orgTypes.add(orgType);
    }
  }
}
