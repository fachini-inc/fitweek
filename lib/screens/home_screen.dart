import 'package:flutter/material.dart';
import '../models/day_plan.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'edit_schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storage = StorageService();
  List<DayPlan>? _schedule;
  bool _loading = true;

  static const List<String> _months = [
    'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
    'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
  ];

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    final schedule = await _storage.loadSchedule();
    setState(() {
      _schedule = schedule;
      _loading = false;
    });
  }

  Future<void> _openEditor() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditScheduleScreen(currentSchedule: _schedule),
      ),
    );
    _loadSchedule();
  }

  String _formatToday(DateTime now) {
    return '${now.day} de ${_months[now.month - 1]}';
  }

  DayPlan? _todayPlan() {
    if (_schedule == null) return null;
    final todayWeekday = DateTime.now().weekday;
    for (final day in _schedule!) {
      if (day.weekday == todayWeekday) return day;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = _todayPlan();

    return Scaffold(
      appBar: AppBar(title: const Text('FitWeek')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _schedule == null
                    ? _buildEmptyState()
                    : _buildTodayView(now, today),
              ),
            ),
      floatingActionButton: _schedule == null
          ? null
          : FloatingActionButton.extended(
              onPressed: _openEditor,
              icon: const Icon(Icons.edit_calendar_outlined),
              label: const Text('Editar agenda'),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.fitness_center,
              size: 64, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text(
            'Você ainda não criou sua agenda de treinos.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Monte sua semana definindo os dias de treino,\n'
            'o tipo de treino e os exercícios de cada um.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _openEditor,
            icon: const Icon(Icons.add),
            label: const Text('Criar agenda'),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayView(DateTime now, DayPlan? today) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('lula morra', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            '${today?.weekdayName ?? ''} · ${_formatToday(now)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          if (today == null)
            _infoCard(
              icon: Icons.help_outline,
              iconColor: AppTheme.textSecondary,
              title: 'Dia não configurado',
              subtitle: 'Edite a agenda para definir este dia.',
            )
          else if (today.isRestDay)
            _infoCard(
              icon: Icons.self_improvement,
              iconColor: AppTheme.restColor,
              title: 'Dia de descanso',
              subtitle: 'Aproveite para recuperar as energias hoje.',
            )
          else
            _buildWorkoutCard(today),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(DayPlan today) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.fitness_center, color: AppTheme.primaryDark),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    today.workoutType.isEmpty
                        ? 'Treino do dia'
                        : today.workoutType,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (today.exercises.isEmpty)
              Text('Nenhum exercício cadastrado para este treino.',
                  style: Theme.of(context).textTheme.bodyMedium)
            else
              ...today.exercises.map(
                (ex) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          ex.name,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '${ex.sets}x${ex.reps}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
