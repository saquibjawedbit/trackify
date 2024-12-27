import 'package:get/get.dart';
import '../models/log_model.dart';

class LogController extends GetxController {
  final _logs = <LogModel>[].obs;
  final selectedDate = DateTime.now().obs;

  List<LogModel> get logs => _logs.toList();

  // CRUD Operations
  void addLog(LogModel log) {
    _logs.add(log);
    _sortLogs();
    _saveLogs(); // TODO: Implement persistence
  }

  void deleteLog(String logId) {
    _logs.removeWhere((log) => log.id == logId);
    _logs.refresh();
    _saveLogs();
  }

  void deleteLogs(String subjectId) {
    _logs.removeWhere((log) => log.subjectId == subjectId);
    _logs.refresh();
    _saveLogs();
  }

  void clearAllLogs() {
    _logs.clear();
    _saveLogs();
  }

  // Query Methods
  List<LogModel> getLogsForSubject(String subjectId) {
    return _logs
        .where((log) => log.subjectId == subjectId)
        .toList()
        .reversed
        .toList();
  }

  List<LogModel> getLogsForDate(DateTime date) {
    return _logs
        .where((log) =>
            log.date.year == date.year &&
            log.date.month == date.month &&
            log.date.day == date.day)
        .toList();
  }

  List<LogModel> getLogsBetweenDates(DateTime start, DateTime end) {
    return _logs
        .where((log) =>
            log.date.isAfter(start.subtract(const Duration(days: 1))) &&
            log.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  // Statistics Methods
  Map<AttendanceType, int> getAttendanceStats(String subjectId) {
    final stats = <AttendanceType, int>{};
    final subjectLogs = getLogsForSubject(subjectId);

    for (var type in AttendanceType.values) {
      stats[type] = subjectLogs.where((log) => log.type == type).length;
    }
    return stats;
  }

  double getAttendancePercentage(String subjectId) {
    final stats = getAttendanceStats(subjectId);
    final total = stats.values.fold(0, (sum, count) => sum + count);
    if (total == 0) return 0;

    final present = stats[AttendanceType.present] ?? 0;
    return (present / total) * 100;
  }

  // Calendar View Methods
  Map<DateTime, List<LogModel>> getLogsGroupedByDate(String subjectId) {
    final subjectLogs = getLogsForSubject(subjectId);
    final groupedLogs = <DateTime, List<LogModel>>{};

    for (var log in subjectLogs) {
      final date = DateTime(log.date.year, log.date.month, log.date.day);
      if (!groupedLogs.containsKey(date)) {
        groupedLogs[date] = [];
      }
      groupedLogs[date]!.add(log);
    }
    return groupedLogs;
  }

  // Helper Methods
  void _sortLogs() {
    _logs.sort((a, b) => b.date.compareTo(a.date));
    _logs.refresh();
  }

  // Persistence Methods - TODO: Implement these
  Future<void> _saveLogs() async {
    // Save logs to local storage
  }

  Future<void> _loadLogs() async {
    // Load logs from local storage
  }

  @override
  void onInit() {
    super.onInit();
    _loadLogs();
  }

  @override
  void onClose() {
    _saveLogs();
    super.onClose();
  }
}
