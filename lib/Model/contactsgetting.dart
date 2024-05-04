import 'dart:convert';

class FriendDetails {
  final int FriendId;
  final String FriendName;
  final String FriendPhoneNumber;
  bool isSelected;
  FriendDetails({
    required this.FriendId,
    required this.FriendName,
    required this.FriendPhoneNumber,
    this.isSelected = false,
  });

  FriendDetails copyWith({
    int? FriendId,
    String? FriendName,
    String? FriendPhoneNumber,
  }) {
    return FriendDetails(
      FriendId: FriendId ?? this.FriendId,
      FriendName: FriendName ?? this.FriendName,
      FriendPhoneNumber: FriendPhoneNumber ?? this.FriendPhoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'FriendId': FriendId});
    result.addAll({'FriendName': FriendName});
    result.addAll({'FriendPhoneNumber': FriendPhoneNumber});

    return result;
  }

  factory FriendDetails.fromMap(Map<String, dynamic> map) {
    return FriendDetails(
      FriendId: map['FriendId']?.toInt() ?? 0,
      FriendName: map['FriendName'] ?? '',
      FriendPhoneNumber: map['FriendPhoneNumber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendDetails.fromJson(String source) =>
      FriendDetails.fromMap(json.decode(source));

  @override
  String toString() =>
      'FriendDetails(FriendId: $FriendId, FriendName: $FriendName, FriendPhoneNumber: $FriendPhoneNumber)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FriendDetails &&
        other.FriendId == FriendId &&
        other.FriendName == FriendName &&
        other.FriendPhoneNumber == FriendPhoneNumber;
  }

  @override
  int get hashCode =>
      FriendId.hashCode ^ FriendName.hashCode ^ FriendPhoneNumber.hashCode;
}
