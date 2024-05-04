import 'dart:convert';

class geofancingmodel {
  int TaskId;
  String TaskTitle;
  int? UserId;
  int? GeofenceStatus;
  int? Radius;
  int? createdby;
  int? Friends;
  bool ShareGeofenceStatus;
  bool complete;
  double? TaskLongitude;
  double? TaskLatitude;
  geofancingmodel({
    required this.TaskId,
    required this.TaskTitle,
    this.UserId,
    this.GeofenceStatus,
    this.Radius,
    this.createdby,
    this.Friends,
    required this.ShareGeofenceStatus,
    required this.complete,
    this.TaskLongitude,
    this.TaskLatitude,
  });

  geofancingmodel copyWith({
    int? TaskId,
    String? TaskTitle,
    int? UserId,
    int? GeofenceStatus,
    int? Radius,
    int? createdby,
    int? Friends,
    bool? ShareGeofenceStatus,
    bool? complete,
    double? TaskLongitude,
    double? TaskLatitude,
  }) {
    return geofancingmodel(
      TaskId: TaskId ?? this.TaskId,
      TaskTitle: TaskTitle ?? this.TaskTitle,
      UserId: UserId ?? this.UserId,
      GeofenceStatus: GeofenceStatus ?? this.GeofenceStatus,
      Radius: Radius ?? this.Radius,
      createdby: createdby ?? this.createdby,
      Friends: Friends ?? this.Friends,
      ShareGeofenceStatus: ShareGeofenceStatus ?? this.ShareGeofenceStatus,
      complete: complete ?? this.complete,
      TaskLongitude: TaskLongitude ?? this.TaskLongitude,
      TaskLatitude: TaskLatitude ?? this.TaskLatitude,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'TaskId': TaskId});
    result.addAll({'TaskTitle': TaskTitle});
    if(UserId != null){
      result.addAll({'UserId': UserId});
    }
    if(GeofenceStatus != null){
      result.addAll({'GeofenceStatus': GeofenceStatus});
    }
    if(Radius != null){
      result.addAll({'Radius': Radius});
    }
    if(createdby != null){
      result.addAll({'createdby': createdby});
    }
    if(Friends != null){
      result.addAll({'Friends': Friends});
    }
    result.addAll({'ShareGeofenceStatus': ShareGeofenceStatus});
    result.addAll({'complete': complete});
    if(TaskLongitude != null){
      result.addAll({'TaskLongitude': TaskLongitude});
    }
    if(TaskLatitude != null){
      result.addAll({'TaskLatitude': TaskLatitude});
    }
  
    return result;
  }

  factory geofancingmodel.fromMap(Map<String, dynamic> map) {
    return geofancingmodel(
      TaskId: map['TaskId']?.toInt() ?? 0,
      TaskTitle: map['TaskTitle'] ?? '',
      UserId: map['UserId']?.toInt(),
      GeofenceStatus: map['GeofenceStatus']?.toInt(),
      Radius: map['Radius']?.toInt(),
      createdby: map['createdby']?.toInt(),
      Friends: map['Friends']?.toInt(),
      ShareGeofenceStatus: map['ShareGeofenceStatus'] ?? false,
      complete: map['complete'] ?? false,
      TaskLongitude: map['TaskLongitude']?.toDouble(),
      TaskLatitude: map['TaskLatitude']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory geofancingmodel.fromJson(String source) => geofancingmodel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'geofancingmodel(TaskId: $TaskId, TaskTitle: $TaskTitle, UserId: $UserId, GeofenceStatus: $GeofenceStatus, Radius: $Radius, createdby: $createdby, Friends: $Friends, ShareGeofenceStatus: $ShareGeofenceStatus, complete: $complete, TaskLongitude: $TaskLongitude, TaskLatitude: $TaskLatitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is geofancingmodel &&
      other.TaskId == TaskId &&
      other.TaskTitle == TaskTitle &&
      other.UserId == UserId &&
      other.GeofenceStatus == GeofenceStatus &&
      other.Radius == Radius &&
      other.createdby == createdby &&
      other.Friends == Friends &&
      other.ShareGeofenceStatus == ShareGeofenceStatus &&
      other.complete == complete &&
      other.TaskLongitude == TaskLongitude &&
      other.TaskLatitude == TaskLatitude;
  }

  @override
  int get hashCode {
    return TaskId.hashCode ^
      TaskTitle.hashCode ^
      UserId.hashCode ^
      GeofenceStatus.hashCode ^
      Radius.hashCode ^
      createdby.hashCode ^
      Friends.hashCode ^
      ShareGeofenceStatus.hashCode ^
      complete.hashCode ^
      TaskLongitude.hashCode ^
      TaskLatitude.hashCode;
  }
}
