class User {

  String orgType;
  String name;
  String emailId;
  String password;
  String phoneNo;
  String businessName;
  String incorporationType;
  String year;
  String keyFunctionary;
  String servicesOrProducts;
  String location;
  String website;
  String description;
  String vision;
  String documentId;
  String imageUrl;

  User(
      this.orgType,
      this.name,
      this.emailId,
      this.password,
      this.phoneNo,
      this.businessName,
      this.incorporationType,
      this.year,
      this.keyFunctionary,
      this.servicesOrProducts,
      this.location,
      this.website,
      this.description,
      this.vision,
      this.documentId,
      this.imageUrl
      );

  Map<String, dynamic> toMap() {
    return {
      'orgType': orgType,
      'name': name,
      'emailId': emailId,
      'password': password,
      'phoneNo': phoneNo,
      'businessName': businessName,
      'incorporationType': incorporationType,
      'year': year,
      'keyFunctionary': keyFunctionary,
      'servicesOrProducts': servicesOrProducts,
      'location': location,
      'website': website,
      'description': description,
      'vision': vision,
      'documentId': documentId,
      'imageUrl': imageUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['orgType'] as String,
      map['name'] as String,
      map['emailId'] as String,
      map['password'] as String,
      map['phoneNo'] as String,
      map['businessName'] as String,
      map['incorporationType'] as String,
      map['year'] as String,
      map['keyFunctionary'] as String,
      map['servicesOrProducts'] as String,
      map['location'] as String,
      map['website'] as String,
      map['description'] as String,
      map['vision'] as String,
      map['documentId'] as String,
      map['imageUrl'] as String,
    );
  }
}
