import 'package:flutter/material.dart';
import '../models/day_plan.dart';
import '../models/exercise.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class _ExerciseControllers {
  final TextEditingController name;
  final TextEditingController sets;
  final TextEditingController reps;

  _ExerciseControllers({Exercise? exercise})
      : name = TextEditingController(text: exercise?.name ?? ''),
        sets = TextEditingController(text: (exercise?.sets ?? 3).toString()),
        reps = TextEditingController(text: (exercise?.reps ?? 12).toString());

  void dispose() {
    name.dispose();
    sets.dispose();
    reps.dispose();
  }

  Exercise toExercise() => Exercise(
        name: name.text.trim().isEmpty ? 'Exercício' : name.text.trim(),
        sets: int.tryParse(sets.text) ?? 0,
        reps: int.tryParse(reps.text) ?? 0,
      );
}

class _DayEditState {
  final int weekday;
  bool isRestDay;
  final TextEditingController workoutType;
  List<_ExerciseControllers> exercises;

  _DayEditState({
    required this.weekday,
    required this.isRestDay,
    required String workoutType,
    List<_ExerciseControllers>? exercises,
  })  : workoutType = TextEditingController(text: workoutType),
        exercises = exercises ?? [];

  void dispose() {
    workoutType.dispose();
    for (final e in exercises) {
      e.dispose();
    }
  }

  DayPlan toDayPlan() => DayPlan(
        weekday: weekday,
        isRestDay: isRestDay,
        workoutType: workoutType.text.trim(),
        exercises: exercises.map((e) => e.toExercise()).toList(),
      );
}

class EditScheduleScreen extends StatefulWidget {
  final List<DayPlan>? currentSchedule;

  const EditScheduleScreen({super.key, this.currentSchedule});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final StorageService _storage = StorageService();
  late final List<_DayEditState> _days;

  @override
  void initState() {
    super.initState();
    _days = List.generate(7, (index) {
      final weekday = index + 1;
      final existing = widget.currentSchedule?.firstWhere(
        (d) => d.weekday == weekday,
        orElse: () => DayPlan(weekday: weekday),
      );
      return _DayEditState(
        weekday: weekday,
        isRestDay: existing?.isRestDay ?? true,
        workoutType: existing?.workoutType ?? '',
        exercises: (existing?.exercises ?? [])
            .map((e) => _ExerciseControllers(exercise: e))
            .toList(),
      );
    });
  }

  @override
  void dispose() {
    for (final d in _days) {
      d.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final plans = _days.map((d) => d.toDayPlan()).toList();
    await _storage.saveSchedule(plans);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agenda salva com sucesso!')),
      );
      Navigator.of(context).pop();
    }
  }

  void _addExercise(_DayEditState day) {
    setState(() {
      day.exercises.add(_ExerciseControllers());
    });
  }

  void _removeExercise(_DayEditState day, int index) {
    setState(() {
      day.exercises[index].dispose();
      day.exercises.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha agenda'),
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.check),
            tooltip: 'Salvar agenda',
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _days.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildDayCard(_days[index]),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Salvar agenda'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard(_DayEditState day) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          title: Text(
            DayPlan.weekdayNames[day.weekday] ?? '',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            day.isRestDay
                ? 'Descanso'
                : (day.workoutType.text.isEmpty
                    ? 'Treino'
                    : day.workoutType.text),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Dia de descanso'),
                    value: day.isRestDay,
                    onChanged: (value) => setState(() => day.isRestDay = value),
                  ),
                  if (!day.isRestDay) ...[
                    const SizedBox(height: 4),
                    TextField(
                      controller: day.workoutType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de treino (ex: Peito e tríceps)',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Exercícios',
                            style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => _addExercise(day),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Adicionar'),
                        ),
                      ],
                    ),
                    if (day.exercises.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Nenhum exercício adicionado ainda.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    else
                      ...List.generate(
                        day.exercises.length,
                        (i) => _buildExerciseRow(day, i),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseRow(_DayEditState day, int index) {
    final ex = day.exercises[index];
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: ex.name,
              decoration: const InputDecoration(labelText: 'Exercício'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: TextField(
              controller: ex.sets,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Séries'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: TextField(
              controller: ex.reps,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Reps'),
            ),
          ),
          IconButton(
            onPressed: () => _removeExercise(day, index),
            icon: const Icon(Icons.close, color: AppTheme.textSecondary),
            tooltip: 'Remover exercício',
          ),
        ],
      ),
    );
  }
}
