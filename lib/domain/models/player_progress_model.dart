import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class PlayerProgressModel extends HiveObject {
  @HiveField(0)
  int hearts;

  @HiveField(1)
  DateTime? lastRefillTime;

  @HiveField(2)
  int streakCount;

  @HiveField(3)
  DateTime? lastCompletedDate;

  @HiveField(4)
  List<String> weekStatus; // Store statuses for the current week as strings

  PlayerProgressModel({
    this.hearts = 26,
    this.lastRefillTime,
    this.streakCount = 0,
    this.lastCompletedDate,
    List<String>? weekStatus,
  }) : weekStatus = weekStatus ?? List.filled(7, 'pending');
}
