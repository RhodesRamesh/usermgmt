

class User {

  String orgType;
  String name;
  String emailId;
  String password;
  String description;

  User(this.orgType, this.name, this.emailId, this.password, this.description);

  Map<String, dynamic> toMap() {
    return {
      'orgType': orgType,
      'name': name,
      'emailId': emailId,
      'password': password,
      'description': description,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
       map['orgType'] as String,
       map['name'] as String,
       map['emailId'] as String,
       map['password'] as String,
       map['description'] as String,
    );
  }
}
