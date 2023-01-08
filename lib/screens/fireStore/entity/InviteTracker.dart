class InviteTracker{
  int id;
  String emailId;

  /// 0 -> Pending
  /// 1 -> Approved
  /// 2-> Rejected
  int status;
  String? documentId;

  InviteTracker(this.id, this.emailId, this.status);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emailId': emailId,
      'status': status,
    };
  }

  factory InviteTracker.fromMap(Map<String, dynamic> map) {
    return InviteTracker(
      map['id'] as int,
       map['emailId'] as String,
       map['status'] as int,
    );
  }
}