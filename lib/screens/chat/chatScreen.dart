import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart' as sb;
import 'package:user_management/resources/borderDesigns.dart';
import 'package:user_management/resources/dimen.dart';
import 'package:user_management/routers/router.dart';
import 'package:user_management/screens/chat/ChatScreenController.dart';
import 'package:user_management/screens/fireStore/entity/User.dart' as u;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with BorderDesign, Dimension {
  late u.User user;
  late ChatScreenController chatCtrl;
  double borderRadius = 12;
  TextEditingController msgCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    user = Get.arguments[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chatCtrl = Get.put(ChatScreenController(user));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: InkWell(
              onTap: () {
                Get.toNamed(GetPageRouter.userProfilePageRoute, arguments: [chatCtrl.selUser, false]);
              },
              child: Text(user.name)),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: chatCtrl.getMessages(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (chatCtrl.messages.isEmpty) {
                      return const Center(
                        child: Text("No Messages"),
                      );
                    } else {
                      return Obx(
                        () => ListView.builder(
                          itemCount: chatCtrl.messages.length,
                          reverse: true,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            sb.BaseMessage msg = chatCtrl.messages[index];
                            return showMessage(msg);
                          },
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            TextFormField(
              controller: msgCtrl,
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.only(left: 15, top: 15, bottom: 10, right: 15),
                hintText: "Message Here...!!!",
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
              onSaved: (value) async {
                if (value?.isNotEmpty ?? false) {
                  await chatCtrl.addMessage(value ?? "");
                  msgCtrl.clear();
                }
              },
              onFieldSubmitted: (value) async {
                if (value.isNotEmpty) {
                  await chatCtrl.addMessage(value);
                  msgCtrl.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget showMessage(sb.BaseMessage msg) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: msg.sender?.userId == chatCtrl.user.userId?MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        Text(msg.message),
      ],
    );
  }
}
