class MessageMailEntity{
  String subject;
  String html;

  MessageMailEntity(this.subject, this.html);

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'html': html,
    };
  }

  factory MessageMailEntity.fromMap(Map<String, dynamic> map) {
    return MessageMailEntity(
       map['subject'] as String,
       map['html'] as String,
    );
  }
}