import 'dart:convert';

class contactsAdding {
  int? Friend;
  int? Friendof;
  String? Type;
  contactsAdding({
    this.Friend,
    this.Friendof,
    this.Type,
  });

  contactsAdding copyWith({
    int? Friend,
    int? Friendof,
    String? Type,
  }) {
    return contactsAdding(
      Friend: Friend ?? this.Friend,
      Friendof: Friendof ?? this.Friendof,
      Type: Type ?? this.Type,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(Friend != null){
      result.addAll({'Friend': Friend});
    }
    if(Friendof != null){
      result.addAll({'Friendof': Friendof});
    }
    if(Type != null){
      result.addAll({'Type': Type});
    }
  
    return result;
  }

  factory contactsAdding.fromMap(Map<String, dynamic> map) {
    return contactsAdding(
      Friend: map['Friend']?.toInt(),
      Friendof: map['Friendof']?.toInt(),
      Type: map['Type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory contactsAdding.fromJson(String source) => contactsAdding.fromMap(json.decode(source));

  @override
  String toString() => 'contactsAdding(Friend: $Friend, Friendof: $Friendof, Type: $Type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is contactsAdding &&
      other.Friend == Friend &&
      other.Friendof == Friendof &&
      other.Type == Type;
  }

  @override
  int get hashCode => Friend.hashCode ^ Friendof.hashCode ^ Type.hashCode;
}
