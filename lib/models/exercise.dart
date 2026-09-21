class Exercise {
  String name;
  int sets;
  int reps;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'sets': sets,
        'reps': reps,
      };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        name: json['name'] as String,
        sets: json['sets'] as int,
        reps: json['reps'] as int,
      );

  Exercise copy() => Exercise(name: name, sets: sets, reps: reps);
}
