class Admin{
  int id;
  String name;
  String mailId;

  Admin(this.id, this.name, this.mailId);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mailId': mailId,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
       map['id'] as int,
       map['name'] as String,
       map['mailId'] as String,
    );
  }
}