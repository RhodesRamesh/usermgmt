class OrgType{
  int id;
  String orgName;

  OrgType(this.id, this.orgName);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orgName': orgName,
    };
  }

  factory OrgType.fromMap(Map<String, dynamic> map) {
    return OrgType(
       map['id'] as int,
       map['orgName'] as String,
    );
  }
}