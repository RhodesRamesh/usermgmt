import 'package:user_management/screens/fireStore/entity/MessageMailEntity.dart';

class MailEntity {
  String to;
  MessageMailEntity message;

  MailEntity(this.to, this.message);

  Map<String, dynamic> toMap() {
    return {
      'to': to,
      'message': message.toMap(),
    };
  }

  factory MailEntity.fromMap(Map<String, dynamic> map) {
    return MailEntity(
       map['to'] as String,
       map['message'] as MessageMailEntity,
    );
  }
}
