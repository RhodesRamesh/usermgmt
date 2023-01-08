import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:user_management/resources/colors.dart';
import 'package:user_management/screens/fireStore/dots.dart';
import 'package:user_management/screens/fireStore/entity/InviteTracker.dart';
import 'package:user_management/screens/fireStore/entity/User.dart';
import 'package:user_management/screens/fireStore/entity/userRoles.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late User user;
  bool isEdit = false;

  late InviteTracker tracker;

  late UserRoles role;

  @override
  void initState() {
    // TODO: implement initState
    user = Get.arguments[0];
    isEdit = Get.arguments[1];
    role = Get.find<UserRoles>();
    Logger().i(user.toMap());
    Logger().i(role);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          leading: InkWell(onTap: () => Get.back(), child: const Icon(Icons.arrow_back)),
          title: const Text("User Profile"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: getInvitationData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Could not load"),
              );
            } else {
              return showData();
            }
          },
        ),
      ),
    );
  }

  Widget showImageAvatar() {
    if (user.imageUrl.isEmpty) {
      return CircleAvatar(
        backgroundColor: primaryColor,
        radius: MediaQuery.of(context).size.width * 0.125,
        child: Transform.scale(
          scale: 2,
          child: const Icon(
            Icons.person,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
        child: ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromRadius(48),
            child: CachedNetworkImage(imageUrl: user.imageUrl, fit: BoxFit.cover),
          ),
        ),
      );
    }
  }

  pickFileAndUpload() async {
    final FilePickerResult? res = await FilePicker.platform.pickFiles();
    if (res != null) {
      PlatformFile file = res.files.first;
      if (file.path!.isNotEmpty) {
        FirebaseStorage.instance.ref().child(file.name).putFile(File(file.path ?? "")).then((p0) async {
          user.imageUrl = await p0.ref.getDownloadURL();
          FirebaseFirestore.instance.collection(FireStoreDots.userCollection).doc(user.documentId).update({
            "imageUrl": user.imageUrl,
          }).then((value) async {
            await ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(
                  content: Text("Profile Updated"),
                ))
                .closed;
            Get.back();
          });
        });
      }
    }
  }

  Widget showAdminButtons() {
    if (tracker.status == 0) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                updateUser(1);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
              child: const Text(
                "Approved",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                updateUser(2);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text(
                "Reject",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else {
      return tracker.status == 1
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Approved",
                style: TextStyle(color: Colors.lightGreen, fontSize: 18),
              ),
            )
          : const Text(
              "Rejected",
              style: TextStyle(color: Colors.redAccent, fontSize: 18),
            );
    }
  }

  Future getInvitationData() async {
    var data =
        await FirebaseFirestore.instance.collection(FireStoreDots.inviteTrackerCollection).where("emailId", isEqualTo: user.emailId).limit(1).get();
    if (data.docs.isEmpty) {
      return Future.error("Not found");
    }
    tracker = InviteTracker.fromMap(data.docs[0].data());
    tracker.documentId = data.docs[0].id;
    return Future.value();
  }

  Widget showData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      showImageAvatar(),
                      if (isEdit)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () => pickFileAndUpload(),
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.black87,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    user.name.capitalizeFirst ?? "",
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email,
                        color: primaryColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        user.emailId,
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        role == UserRoles.Admin ? showAdminButtons() : const SizedBox.shrink(),
      ],
    );
  }

  void updateUser(int status) {
    FirebaseFirestore.instance.collection(FireStoreDots.inviteTrackerCollection).doc(tracker.documentId).update({
      "status": status,
    }).then((value) async {
      await ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
            content: status == 1 ? const Text("User Approved") : const Text("User Rejected"),
          ))
          .closed;
      Get.back();
    });
  }
}
