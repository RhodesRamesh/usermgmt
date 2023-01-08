class Admin{
  int id;
  String name;
  String emailId;
  String password;
  String documentId;

  Admin(this.id, this.name, this.emailId,this.password,this.documentId);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'emailId': emailId,
      'password': password,
      'documentId': documentId,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
       map['id'] as int,
       map['name'] as String,
       map['emailId'] as String,
       map['password'] as String,
       map['documentId'] as String,
    );
  }
}