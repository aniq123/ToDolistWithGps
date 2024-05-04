import 'dart:convert';

class GeoFancing {
  int Gid;
  int UserId;
  String Title;
  double? Longitude;
  double? Latitude;
  int? GeofenceStatus;
  bool ShareGeofenceStatus;
  int? createdby;
  int? Radius;
  int Friends;
  String polygone;
  bool Reached;
  GeoFancing({
    required this.Gid,
    required this.UserId,
    required this.Title,
    this.Longitude,
    this.Latitude,
    this.GeofenceStatus,
    required this.ShareGeofenceStatus,
    this.createdby,
    required this.Radius,
    required this.Friends,
    required this.polygone,
    required this.Reached,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'Gid': Gid});
    result.addAll({'UserId': UserId});
    result.addAll({'Title': Title});
    if (Longitude != null) {
      result.addAll({'Longitude': Longitude});
    }
    if (Latitude != null) {
      result.addAll({'Latitude': Latitude});
    }
    if (GeofenceStatus != null) {
      result.addAll({'GeofenceStatus': GeofenceStatus});
    }
    result.addAll({'ShareGeofenceStatus': ShareGeofenceStatus});
    if (createdby != null) {
      result.addAll({'createdby': createdby});
    }
    if (Radius != null) {
      result.addAll({'Radius': Radius});
    }
    result.addAll({'Friends': Friends});
    result.addAll({'polygone': polygone});
    result.addAll({'Reached': Reached});

    return result;
  }

  factory GeoFancing.fromMap(Map<String, dynamic> map) {
    return GeoFancing(
      Gid: map['Gid']?.toInt() ?? 0,
      UserId: map['UserId']?.toInt() ?? 0,
      Title: map['Title'] ?? '',
      Longitude: map['Longitude']?.toDouble(),
      Latitude: map['Latitude']?.toDouble(),
      GeofenceStatus: map['GeofenceStatus']?.toInt(),
      ShareGeofenceStatus: map['ShareGeofenceStatus'] ?? false,
      createdby: map['createdby']?.toInt(),
      Radius: map['Radius']?.toInt(),
      Friends: map['Friends']?.toInt() ?? 0,
      polygone: map['polygone'] ?? '',
      Reached: map['Reached'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory GeoFancing.fromJson(String source) =>
      GeoFancing.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GeoFancing(Gid: $Gid, UserId: $UserId, Title: $Title, Longitude: $Longitude, Latitude: $Latitude, GeofenceStatus: $GeofenceStatus, ShareGeofenceStatus: $ShareGeofenceStatus, createdby: $createdby, Radius: $Radius, Friends: $Friends, polygone: $polygone, Reached: $Reached)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeoFancing &&
        other.Gid == Gid &&
        other.UserId == UserId &&
        other.Title == Title &&
        other.Longitude == Longitude &&
        other.Latitude == Latitude &&
        other.GeofenceStatus == GeofenceStatus &&
        other.ShareGeofenceStatus == ShareGeofenceStatus &&
        other.createdby == createdby &&
        other.Radius == Radius &&
        other.Friends == Friends &&
        other.polygone == polygone &&
        other.Reached == Reached;
  }

  @override
  int get hashCode {
    return Gid.hashCode ^
        UserId.hashCode ^
        Title.hashCode ^
        Longitude.hashCode ^
        Latitude.hashCode ^
        GeofenceStatus.hashCode ^
        ShareGeofenceStatus.hashCode ^
        createdby.hashCode ^
        Radius.hashCode ^
        Friends.hashCode ^
        polygone.hashCode ^
        Reached.hashCode;
  }

  GeoFancing copyWith({
    int? Gid,
    int? UserId,
    String? Title,
    double? Longitude,
    double? Latitude,
    int? GeofenceStatus,
    bool? ShareGeofenceStatus,
    int? createdby,
    int? Radius,
    int? Friends,
    String? polygone,
    bool? Reached,
  }) {
    return GeoFancing(
      Gid: Gid ?? this.Gid,
      UserId: UserId ?? this.UserId,
      Title: Title ?? this.Title,
      Longitude: Longitude ?? this.Longitude,
      Latitude: Latitude ?? this.Latitude,
      GeofenceStatus: GeofenceStatus ?? this.GeofenceStatus,
      ShareGeofenceStatus: ShareGeofenceStatus ?? this.ShareGeofenceStatus,
      createdby: createdby ?? this.createdby,
      Radius: Radius ?? this.Radius,
      Friends: Friends ?? this.Friends,
      polygone: polygone ?? this.polygone,
      Reached: Reached ?? this.Reached,
    );
  }
}
