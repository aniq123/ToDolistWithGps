import 'dart:convert';

class Contactmodel {
  int? UserId;
  String? UserName;
  String? PhoneNumber;
  Contactmodel({
    this.UserId,
    this.UserName,
    this.PhoneNumber,
  });

  Contactmodel copyWith({
    int? UserId,
    String? UserName,
    String? PhoneNumber,
  }) {
    return Contactmodel(
      UserId: UserId ?? this.UserId,
      UserName: UserName ?? this.UserName,
      PhoneNumber: PhoneNumber ?? this.PhoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (UserId != null) {
      result.addAll({'UserId': UserId});
    }
    if (UserName != null) {
      result.addAll({'UserName': UserName});
    }
    if (PhoneNumber != null) {
      result.addAll({'PhoneNumber': PhoneNumber});
    }

    return result;
  }

  factory Contactmodel.fromMap(Map<String, dynamic> map) {
    return Contactmodel(
      UserId: map['UserId']?.toInt(),
      UserName: map['UserName'],
      PhoneNumber: map['PhoneNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Contactmodel.fromJson(String source) =>
      Contactmodel.fromMap(json.decode(source));

  @override
  String toString() =>
      'Contactmodel(UserId: $UserId, UserName: $UserName, PhoneNumber: $PhoneNumber)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Contactmodel &&
        other.UserId == UserId &&
        other.UserName == UserName &&
        other.PhoneNumber == PhoneNumber;
  }

  @override
  int get hashCode =>
      UserId.hashCode ^ UserName.hashCode ^ PhoneNumber.hashCode;
}
