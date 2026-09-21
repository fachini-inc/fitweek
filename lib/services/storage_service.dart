import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/day_plan.dart';

class StorageService {
  static const String _scheduleKey = 'fitweek_schedule';

  Future<void> saveSchedule(List<DayPlan> schedule) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = schedule.map((d) => d.toJson()).toList();
    await prefs.setString(_scheduleKey, jsonEncode(jsonList));
  }

  Future<List<DayPlan>?> loadSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_scheduleKey);
    if (raw == null) return null;

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => DayPlan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> clearSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scheduleKey);
  }
}
