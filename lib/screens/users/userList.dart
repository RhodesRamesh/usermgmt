import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/resources/colors.dart';
import 'package:user_management/routers/router.dart';
import 'package:user_management/screens/fireStore/dots.dart';
import 'package:user_management/screens/fireStore/entity/User.dart';
import 'package:user_management/screens/fireStore/entity/orgTypes.dart';
import 'package:user_management/screens/fireStore/sendMail.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList>{
  var _future = FirebaseFirestore.instance.collection(FireStoreDots.userCollection).get();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Users List"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  Get.toNamed(GetPageRouter.userProfilePageRoute, arguments: [user, true])!.then((value) {
                    setState(() {
                      _future = FirebaseFirestore.instance.collection(FireStoreDots.userCollection).get();
                    });
                  });
                },
                child: const Icon(Icons.person,size: 26,)),
          )
        ],
      ),
      body: Column(
        children: [
          showFilter(),
          Expanded(
            child: FutureBuilder(
              future: _future,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return generateUserData(snapshot.data);
                  } else {
                    return const SizedBox.shrink();
                  }
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    ));
  }

  late User user;

  @override
  void initState() {
    user = Get.arguments;
    getOrgType();
    super.initState();
  }

  List<OrgType> orgTypes = [];

  Widget generateUserData(QuerySnapshot<Map<String, dynamic>>? sData) {
    List<User> users = [];
    for (var element in sData!.docs) {
      User user = User.fromMap(element.data());
      user.documentId = element.id;
      users.add(user);
    }
    if (users.isEmpty) {
      return Center(
          child: Text(
        "No users Found",
        style: TextStyle(color: primaryColor, fontSize: 20),
      ));
    } else {
      return showList(users);
    }
  }

  Widget showList(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(onTap: () => Get.toNamed(GetPageRouter.userProfilePageRoute, arguments: [users[index], false]),
            child: showSingleUser(users[index]));
      },
    );
  }

  Widget showSingleUser(User user) {
    return Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                user.imageUrl.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(18),
                            child: CachedNetworkImage(imageUrl: user.imageUrl, fit: BoxFit.cover),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 18,
                        child: Transform.scale(
                          scale: 1,
                          child: const Icon(
                            Icons.person,
                          ),
                        ),
                      ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(color: primaryColor, fontSize: 18),
                    ),
                    Text(
                      user.emailId,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                user.orgType,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ));
  }

  Widget showFilter() {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection(FireStoreDots.orgTypesCollection).get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            orgTypes = [];
            orgTypes.add(OrgType(0, "All"));
            for (var element in snapshot.data.docs) {
              OrgType orgType = OrgType.fromMap(element.data());
              orgTypes.add(orgType);
            }
            return Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Organization Type",
                    style: TextStyle(fontSize: 16, color: primaryColor),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField(
                    items: orgTypes.map((OrgType value) {
                      return DropdownMenuItem<String>(
                        value: value.orgName,
                        child: Text(value.orgName),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        if (value == "All") {
                          _future = FirebaseFirestore.instance.collection(FireStoreDots.userCollection).get();
                        } else {
                          _future = FirebaseFirestore.instance.collection(FireStoreDots.userCollection).where("orgType", isEqualTo: value).get();
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void getOrgType() async {
    orgTypes = [];
    orgTypes.add(OrgType(0, "All"));
    var data = await FirebaseFirestore.instance.collection(FireStoreDots.orgTypesCollection).get();
    for (var element in data.docs) {
      OrgType orgType = OrgType.fromMap(element.data());
      orgTypes.add(orgType);
    }
  }
}
