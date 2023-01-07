import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_management/screens/fireStore/entity/MessageMailEntity.dart';
import 'package:user_management/screens/fireStore/entity/mailEntity.dart';

class SendMail{
  
  void sendAMailTo(String mailId,String receptientName,String orgType){
    String bodyOfMail = prepareContent(receptientName,orgType);
    MessageMailEntity msgEntity = MessageMailEntity("New User Registered", bodyOfMail);
    MailEntity entity = MailEntity(mailId,msgEntity);
    FirebaseFirestore.instance.collection("mail").add(entity.toMap());
  }

  String prepareContent(String name,String orgName) {
    String body = "";
    body = "<mark>$name</mark> is Registered in the application as <mark>$orgName</mark>";
    return body;
  }
}