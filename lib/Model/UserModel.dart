import 'dart:convert';

class User {

 int? id;
  String? name;
  String? password;
  String? email;
 
  String? phonenumber;
  User({
    this.id,
    this.name,
    this.password,
    this.email,
    this.phonenumber,
  });
  

  User copyWith({
    int? id,
    String? name,
    String? password,
    String? email,
    String? phonenumber,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      email: email ?? this.email,
      phonenumber: phonenumber ?? this.phonenumber,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'id': id});
    }
    if(name != null){
      result.addAll({'name': name});
    }
    if(password != null){
      result.addAll({'password': password});
    }
    if(email != null){
      result.addAll({'email': email});
    }
    if(phonenumber != null){
      result.addAll({'phonenumber': phonenumber});
    }
  
    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt(),
      name: map['name'],
      password: map['password'],
      email: map['email'],
      phonenumber: map['phonenumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, password: $password, email: $email, phonenumber: $phonenumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.id == id &&
      other.name == name &&
      other.password == password &&
      other.email == email &&
      other.phonenumber == phonenumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      password.hashCode ^
      email.hashCode ^
      phonenumber.hashCode;
  }
}
