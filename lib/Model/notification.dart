import 'dart:convert';

class NotificationModel {
  final String TaskTitle;
  DateTime? Firstdate;
  DateTime? Lastdate;
  DateTime? FirstTime;
  DateTime? TaskDueTime;
  NotificationModel({
    required this.TaskTitle,
    this.Firstdate,
    this.Lastdate,
    this.FirstTime,
    this.TaskDueTime,
  });

  NotificationModel copyWith({
    String? TaskTitle,
    DateTime? Firstdate,
    DateTime? Lastdate,
    DateTime? FirstTime,
    DateTime? TaskDueTime,
  }) {
    return NotificationModel(
      TaskTitle: TaskTitle ?? this.TaskTitle,
      Firstdate: Firstdate ?? this.Firstdate,
      Lastdate: Lastdate ?? this.Lastdate,
      FirstTime: FirstTime ?? this.FirstTime,
      TaskDueTime: TaskDueTime ?? this.TaskDueTime,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'TaskTitle': TaskTitle});
    if(Firstdate != null){
      result.addAll({'Firstdate': Firstdate!.millisecondsSinceEpoch});
    }
    if(Lastdate != null){
      result.addAll({'Lastdate': Lastdate!.millisecondsSinceEpoch});
    }
    if(FirstTime != null){
      result.addAll({'FirstTime': FirstTime!.millisecondsSinceEpoch});
    }
    if(TaskDueTime != null){
      result.addAll({'TaskDueTime': TaskDueTime!.millisecondsSinceEpoch});
    }
  
    return result;
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      TaskTitle: map['TaskTitle'] ?? '',
      Firstdate: map['Firstdate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['Firstdate']) : null,
      Lastdate: map['Lastdate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['Lastdate']) : null,
      FirstTime: map['FirstTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['FirstTime']) : null,
      TaskDueTime: map['TaskDueTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['TaskDueTime']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationModel(TaskTitle: $TaskTitle, Firstdate: $Firstdate, Lastdate: $Lastdate, FirstTime: $FirstTime, TaskDueTime: $TaskDueTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NotificationModel &&
      other.TaskTitle == TaskTitle &&
      other.Firstdate == Firstdate &&
      other.Lastdate == Lastdate &&
      other.FirstTime == FirstTime &&
      other.TaskDueTime == TaskDueTime;
  }

  @override
  int get hashCode {
    return TaskTitle.hashCode ^
      Firstdate.hashCode ^
      Lastdate.hashCode ^
      FirstTime.hashCode ^
      TaskDueTime.hashCode;
  }
}
