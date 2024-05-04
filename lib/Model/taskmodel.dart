import 'dart:convert';

class Taskmodel {
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
  List<int>? Friends;
  bool isEditing; // Updated to DateTime
  bool complete;

  Taskmodel({
    required this.TaskId,
    required this.TaskTitle,
    this.TaskDueDate,
    required this.TaskDueTime,
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
    this.isEditing = false,
    required this.complete,
  });

  Taskmodel copyWith({
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
    List<int>? Friends,
    bool? isEditing,
    bool? complete,
  }) {
    return Taskmodel(
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
      complete: complete ?? this.complete,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'TaskId': TaskId,
      'TaskTitle': TaskTitle,
      'TaskDueDate':
          TaskDueDate?.toIso8601String(), // Convert DateTime to String
      'TaskDueTime': TaskDueTime.toString(), // Convert TimeOfDay to String
      'TaskLongitude': TaskLongitude,
      'TaskLatitude': TaskLatitude,
      'TaskLocArea': TaskLocArea,
      'TaskBeforeTime': TaskBeforeTime,
      'TaskRepeat': TaskRepeat,
      'TasksStatus': TasksStatus,
      'Gid': Gid,
      'Radius': Radius,
      'createdby': createdby,
      'Firstdate': Firstdate?.toIso8601String(),
      'Lastdate': Lastdate?.toIso8601String(),
      'FirstTime': FirstTime.toString(),
      'LastTime': LastTime.toString(),
      'Friends': Friends
    };
  }

  factory Taskmodel.fromMap(Map<String, dynamic> map) {
    return Taskmodel(
      TaskId: map['TaskId']?.toInt() ?? 0,
      TaskTitle: map['TaskTitle'] ?? '',
      TaskDueDate: map['TaskDueDate'] != null
          ? DateTime.parse(map['TaskDueDate'])
          : null,
      TaskDueTime: map['TaskDueTime'] != null
          ? DateTime.parse(map['TaskDueTime'])
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
      FirstTime:
          map['FirstTime'] != null ? DateTime.parse(map['FirstTime']) : null,
      LastTime:
          map['LastTime'] != null ? DateTime.parse(map['LastTime']) : null,
      Friends: map['Friends'] is List
          ? map['Friends']?.map<int>((item) => item as int).toList()
          : [],
      isEditing: map['isEditing'] ?? false,
      complete: map['complete'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Taskmodel.fromJson(String source) =>
      Taskmodel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Taskmodel(TaskId: $TaskId, TaskTitle: $TaskTitle, TaskDueDate: $TaskDueDate, TaskDueTime: $TaskDueTime, TaskLongitude: $TaskLongitude, TaskLatitude: $TaskLatitude, TaskLocArea: $TaskLocArea, TaskBeforeTime: $TaskBeforeTime, TaskRepeat: $TaskRepeat, TasksStatus: $TasksStatus, Gid: $Gid, Radius: $Radius, createdby: $createdby, Firstdate: $Firstdate, Lastdate: $Lastdate, FirstTime: $FirstTime, LastTime: $LastTime, Friends: $Friends, isEditing: $isEditing, complete: $complete)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Taskmodel &&
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
        other.complete == complete;
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
        complete.hashCode;
  }

  bool isLocationBeingEdited() {
    return isEditing;
  }
}
