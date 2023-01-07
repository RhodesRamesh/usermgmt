class User {

  String orgType;
  String name;
  String emailId;
  String password;
  String description;
  String imageUrl;
  String documentId;
  String userType;

  User(this.orgType, this.name, this.emailId, this.password, this.description,this.imageUrl,this.documentId,this.userType);

  Map<String, dynamic> toMap() {
    return {
      'orgType': orgType,
      'name': name,
      'emailId': emailId,
      'password': password,
      'description': description,
      'imageUrl': imageUrl,
      'documentId': documentId,
      'userType': userType,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
       map['orgType'] as String,
       map['name'] as String,
       map['emailId'] as String,
       map['password'] as String,
       map['description'] as String,
       map['imageUrl'] as String,
       map['documentId'] as String,
       map['userType'] as String,
    );
  }
}
