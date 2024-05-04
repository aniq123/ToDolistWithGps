import 'dart:convert';

class sharedTaskmodel {
  int TaskId;
  String TaskTitle;

  DateTime? TaskDueDate;
  DateTime? TaskDueTime; // Updated to DateTime
  double? TaskLongitude;
  double? TaskLatitude;
  String? TaskLocArea;
  String TaskBeforeTime;
  String TaskRepeat;
  int? TasksStatus;
  int? Gid;
  int? Radius;
  int? createdby;
  DateTime? Firstdate;
  DateTime? Lastdate;
  DateTime? FirstTime; // Updated to DateTime
  DateTime? LastTime;
  int? Friends;
  bool isEditing;
  int? Sharedid;
  int? UserId;
  bool ShareTaskStatus;
  bool ShareDateTime;
  sharedTaskmodel({
    required this.TaskId,
    required this.TaskTitle,
    this.TaskDueDate,
    this.TaskDueTime,
    this.TaskLongitude,
    this.TaskLatitude,
    this.TaskLocArea,
    required this.TaskBeforeTime,
    required this.TaskRepeat,
    this.TasksStatus,
    this.Gid,
    this.Radius,
    this.createdby,
    this.Firstdate,
    this.Lastdate,
    this.FirstTime,
    this.LastTime,
    this.Friends,
    required this.isEditing,
    this.Sharedid,
    this.UserId,
    required this.ShareTaskStatus,
    required this.ShareDateTime,
  });

  sharedTaskmodel copyWith({
    int? TaskId,
    String? TaskTitle,
    DateTime? TaskDueDate,
    DateTime? TaskDueTime,
    double? TaskLongitude,
    double? TaskLatitude,
    String? TaskLocArea,
    String? TaskBeforeTime,
    String? TaskRepeat,
    int? TasksStatus,
    int? Gid,
    int? Radius,
    int? createdby,
    DateTime? Firstdate,
    DateTime? Lastdate,
    DateTime? FirstTime,
    DateTime? LastTime,
    int? Friends,
    bool? isEditing,
    int? Sharedid,
    int? UserId,
    bool? ShareTaskStatus,
    bool? ShareDateTime,
  }) {
    return sharedTaskmodel(
      TaskId: TaskId ?? this.TaskId,
      TaskTitle: TaskTitle ?? this.TaskTitle,
      TaskDueDate: TaskDueDate ?? this.TaskDueDate,
      TaskDueTime: TaskDueTime ?? this.TaskDueTime,
      TaskLongitude: TaskLongitude ?? this.TaskLongitude,
      TaskLatitude: TaskLatitude ?? this.TaskLatitude,
      TaskLocArea: TaskLocArea ?? this.TaskLocArea,
      TaskBeforeTime: TaskBeforeTime ?? this.TaskBeforeTime,
      TaskRepeat: TaskRepeat ?? this.TaskRepeat,
      TasksStatus: TasksStatus ?? this.TasksStatus,
      Gid: Gid ?? this.Gid,
      Radius: Radius ?? this.Radius,
      createdby: createdby ?? this.createdby,
      Firstdate: Firstdate ?? this.Firstdate,
      Lastdate: Lastdate ?? this.Lastdate,
      FirstTime: FirstTime ?? this.FirstTime,
      LastTime: LastTime ?? this.LastTime,
      Friends: Friends ?? this.Friends,
      isEditing: isEditing ?? this.isEditing,
      Sharedid: Sharedid ?? this.Sharedid,
      UserId: UserId ?? this.UserId,
      ShareTaskStatus: ShareTaskStatus ?? this.ShareTaskStatus,
      ShareDateTime: ShareDateTime ?? this.ShareDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'TaskId': TaskId});
    result.addAll({'TaskTitle': TaskTitle});
    if (TaskDueDate != null) {
      result.addAll({'TaskDueDate': TaskDueDate?.toIso8601String()});
    }
    if (TaskDueTime != null) {
      result.addAll({'TaskDueTime': TaskDueTime?.toString()});
    }
    //'TaskDueDate':
    //    TaskDueDate?.toIso8601String(), // Convert DateTime to String
    // 'TaskDueTime': TaskDueTime.toString(),
    //
    if (TaskLongitude != null) {
      result.addAll({'TaskLongitude': TaskLongitude});
    }
    if (TaskLatitude != null) {
      result.addAll({'TaskLatitude': TaskLatitude});
    }
    if (TaskLocArea != null) {
      result.addAll({'TaskLocArea': TaskLocArea});
    }
    result.addAll({'TaskBeforeTime': TaskBeforeTime});
    result.addAll({'TaskRepeat': TaskRepeat});
    if (TasksStatus != null) {
      result.addAll({'TasksStatus': TasksStatus});
    }
    if (Gid != null) {
      result.addAll({'Gid': Gid});
    }
    if (Radius != null) {
      result.addAll({'Radius': Radius});
    }
    if (createdby != null) {
      result.addAll({'createdby': createdby});
    }
    if (Firstdate != null) {
      result.addAll({'Firstdate': Firstdate?.toIso8601String()});
    }
    if (Lastdate != null) {
      result.addAll({'Lastdate': Lastdate?.toIso8601String()});
    }
    if (FirstTime != null) {
      result.addAll({'FirstTime': FirstTime?.toIso8601String()});
    }
    if (LastTime != null) {
      result.addAll({'LastTime': LastTime?.toIso8601String()});
    }
    if (Friends != null) {
      result.addAll({'Friends': Friends});
    }
    result.addAll({'isEditing': isEditing});
    if (Sharedid != null) {
      result.addAll({'Sharedid': Sharedid});
    }
    if (UserId != null) {
      result.addAll({'UserId': UserId});
    }
    result.addAll({'ShareTaskStatus': ShareTaskStatus});
    result.addAll({'ShareDateTime': ShareDateTime});

    return result;
  }

  factory sharedTaskmodel.fromMap(Map<String, dynamic> map) {
    return sharedTaskmodel(
      TaskId: map['TaskId']?.toInt() ?? 0,
      TaskTitle: map['TaskTitle'] ?? '',
      TaskDueDate: map['TaskDueDate'] != null
          ? DateTime.parse(map['TaskDueDate'])
          : null,
      TaskDueTime: map['TaskDueTime'] != null
          ? DateTime.tryParse(map['TaskDueTime']!)
          : null,
      TaskLongitude: map['TaskLongitude']?.toDouble(),
      TaskLatitude: map['TaskLatitude']?.toDouble(),
      TaskLocArea: map['TaskLocArea'],
      TaskBeforeTime: map['TaskBeforeTime'] ?? '',
      TaskRepeat: map['TaskRepeat'] ?? '',
      TasksStatus: map['TasksStatus']?.toInt(),
      Gid: map['Gid']?.toInt(),
      Radius: map['Radius']?.toInt(),
      createdby: map['createdby']?.toInt(),
      Firstdate:
          map['Firstdate'] != null ? DateTime.parse(map['Firstdate']) : null,
      Lastdate:
          map['Lastdate'] != null ? DateTime.parse(map['Lastdate']) : null,
      FirstTime: map['FirstTime'] != null
          ? DateTime.tryParse(map['FirstTime']!)
          : null,
      LastTime:
          map['LastTime'] != null ? DateTime.tryParse(map['LastTime']!) : null,
      Friends: map['Friends']?.toInt(),
      isEditing: map['isEditing'] ?? false,
      Sharedid: map['Sharedid']?.toInt(),
      UserId: map['UserId']?.toInt(),
      ShareTaskStatus: map['ShareTaskStatus'] ?? false,
      ShareDateTime: map['ShareDateTime'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory sharedTaskmodel.fromJson(String source) =>
      sharedTaskmodel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'sharedTaskmodel(TaskId: $TaskId, TaskTitle: $TaskTitle, TaskDueDate: $TaskDueDate, TaskDueTime: $TaskDueTime, TaskLongitude: $TaskLongitude, TaskLatitude: $TaskLatitude, TaskLocArea: $TaskLocArea, TaskBeforeTime: $TaskBeforeTime, TaskRepeat: $TaskRepeat, TasksStatus: $TasksStatus, Gid: $Gid, Radius: $Radius, createdby: $createdby, Firstdate: $Firstdate, Lastdate: $Lastdate, FirstTime: $FirstTime, LastTime: $LastTime, Friends: $Friends, isEditing: $isEditing, Sharedid: $Sharedid, UserId: $UserId, ShareTaskStatus: $ShareTaskStatus, ShareDateTime: $ShareDateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is sharedTaskmodel &&
        other.TaskId == TaskId &&
        other.TaskTitle == TaskTitle &&
        other.TaskDueDate == TaskDueDate &&
        other.TaskDueTime == TaskDueTime &&
        other.TaskLongitude == TaskLongitude &&
        other.TaskLatitude == TaskLatitude &&
        other.TaskLocArea == TaskLocArea &&
        other.TaskBeforeTime == TaskBeforeTime &&
        other.TaskRepeat == TaskRepeat &&
        other.TasksStatus == TasksStatus &&
        other.Gid == Gid &&
        other.Radius == Radius &&
        other.createdby == createdby &&
        other.Firstdate == Firstdate &&
        other.Lastdate == Lastdate &&
        other.FirstTime == FirstTime &&
        other.LastTime == LastTime &&
        other.Friends == Friends &&
        other.isEditing == isEditing &&
        other.Sharedid == Sharedid &&
        other.UserId == UserId &&
        other.ShareTaskStatus == ShareTaskStatus &&
        other.ShareDateTime == ShareDateTime;
  }

  @override
  int get hashCode {
    return TaskId.hashCode ^
        TaskTitle.hashCode ^
        TaskDueDate.hashCode ^
        TaskDueTime.hashCode ^
        TaskLongitude.hashCode ^
        TaskLatitude.hashCode ^
        TaskLocArea.hashCode ^
        TaskBeforeTime.hashCode ^
        TaskRepeat.hashCode ^
        TasksStatus.hashCode ^
        Gid.hashCode ^
        Radius.hashCode ^
        createdby.hashCode ^
        Firstdate.hashCode ^
        Lastdate.hashCode ^
        FirstTime.hashCode ^
        LastTime.hashCode ^
        Friends.hashCode ^
        isEditing.hashCode ^
        Sharedid.hashCode ^
        UserId.hashCode ^
        ShareTaskStatus.hashCode ^
        ShareDateTime.hashCode;
  }

  bool isLocationBeingEdited() {
    return isEditing;
  }
}
