

class User {

  String orgType;
  String name;
  String emailId;
  String password;
  String phoneNo;

  User(this.orgType, this.name, this.emailId, this.password, this.phoneNo);

  Map<String, dynamic> toMap() {
    return {
      'orgType': orgType,
      'name': name,
      'emailId': emailId,
      'password': password,
      'phoneNo': phoneNo,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
       map['orgType'] as String,
       map['name'] as String,
       map['emailId'] as String,
       map['password'] as String,
       map['phoneNo'] as String,
    );
  }
}
