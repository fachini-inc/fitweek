import 'exercise.dart';

class DayPlan {
  final int weekday;
  bool isRestDay;
  String workoutType;
  List<Exercise> exercises;

  DayPlan({
    required this.weekday,
    this.isRestDay = true,
    this.workoutType = '',
    List<Exercise>? exercises,
  }) : exercises = exercises ?? [];

  Map<String, dynamic> toJson() => {
        'weekday': weekday,
        'isRestDay': isRestDay,
        'workoutType': workoutType,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  factory DayPlan.fromJson(Map<String, dynamic> json) => DayPlan(
        weekday: json['weekday'] as int,
        isRestDay: json['isRestDay'] as bool,
        workoutType: json['workoutType'] as String? ?? '',
        exercises: (json['exercises'] as List<dynamic>? ?? [])
            .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  DayPlan copy() => DayPlan(
        weekday: weekday,
        isRestDay: isRestDay,
        workoutType: workoutType,
        exercises: exercises.map((e) => e.copy()).toList(),
      );

  static const Map<int, String> weekdayNames = {
    1: 'Segunda-feira',
    2: 'Terça-feira',
    3: 'Quarta-feira',
    4: 'Quinta-feira',
    5: 'Sexta-feira',
    6: 'Sábado',
    7: 'Domingo',
  };

  String get weekdayName => weekdayNames[weekday] ?? '';
}
