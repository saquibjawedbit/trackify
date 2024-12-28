import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attendance_model.dart';
import '../models/log_model.dart';

class CacheService {
  static const String _attendanceKey = 'attendance_cache';
  static const String _logsKey = 'logs_cache';

  static Future<void> cacheAttendance(List<AttendanceModel> attendance) async {
    final prefs = await SharedPreferences.getInstance();
    final data = attendance.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_attendanceKey, data);
  }

  static Future<List<AttendanceModel>> getCachedAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_attendanceKey) ?? [];
    return data.map((str) => AttendanceModel.fromMap(jsonDecode(str))).toList();
  }

  static Future<void> cacheLogs(List<LogModel> logs) async {
    final prefs = await SharedPreferences.getInstance();
    final data = logs.map((log) => jsonEncode(log.toMap())).toList();
    await prefs.setStringList(_logsKey, data);
  }

  static Future<List<LogModel>> getCachedLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_logsKey) ?? [];
    return data.map((str) => LogModel.fromMap(jsonDecode(str))).toList();
  }

  static Future<void> clearLogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_logsKey);
  }

  static Future<void> clearAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_attendanceKey);
  }

  static Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_logsKey);
    await prefs.remove(_attendanceKey);
  }
}
