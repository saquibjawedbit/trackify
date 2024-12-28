import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/log_model.dart';
import '../services/cache_service.dart';

class LogController extends GetxController {
  final _logs = <LogModel>[].obs;
  final selectedDate = DateTime.now().obs;
  List<LogModel> get logs => _logs.toList();

  // CRUD Operations
  Future<void> addLog(LogModel log) async {
    try {
      await log.saveToFirestore();
      await _loadLogs(); // Refresh logs from Firestore
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add log: $e',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  Future<void> deleteLog(String logId) async {
    try {
      await LogModel.deleteLog(logId);
      await CacheService.clearLogs(); // Clear cache
      await _loadLogs(); // Refresh logs from Firestore
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete log: $e',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  Future<void> deleteLogs(String subjectId) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final logsToDelete = await FirebaseFirestore.instance
          .collection('logs')
          .where('subjectId', isEqualTo: subjectId)
          .get();

      for (var doc in logsToDelete.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Clear cache
      await CacheService.clearLogs();
      await _loadLogs(); // Refresh logs from Firestore
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete logs: $e',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  void clearAllLogs() async {
    try {
      _logs.clear();
      await CacheService.clearLogs();
      Get.snackbar(
        'Success',
        'All logs cleared',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear logs: $e',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  // Query Methods
  Future<List<LogModel>> getLogsForSubject(String subjectId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await FirebaseFirestore.instance
          .collection('logs')
          .where('userId', isEqualTo: userId)
          .where('subjectId', isEqualTo: subjectId)
          .orderBy('date',
              descending: true) // Sort by date instead of createdAt
          .get();

      final logs =
          snapshot.docs.map((doc) => LogModel.fromMap(doc.data())).toList();

      // Sort locally to ensure correct order
      logs.sort((a, b) => b.date.compareTo(a.date));
      return logs;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load subject logs: $e');
      return [];
    }
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
  Future<Map<AttendanceType, int>> getAttendanceStats(String subjectId) async {
    final stats = <AttendanceType, int>{};
    final subjectLogs = await getLogsForSubject(subjectId);

    for (var type in AttendanceType.values) {
      stats[type] = subjectLogs.where((log) => log.type == type).length;
    }
    return stats;
  }

  Future<double> getAttendancePercentage(String subjectId) async {
    final stats = await getAttendanceStats(subjectId);
    // ignore: avoid_types_as_parameter_names
    final total = stats.values.fold(0, (sum, count) => sum + count);
    if (total == 0) return 0;

    final present = stats[AttendanceType.present] ?? 0;
    return (present / total) * 100;
  }

  // Calendar View Methods
  Future<Map<DateTime, List<LogModel>>> getLogsGroupedByDate(
      String subjectId) async {
    final subjectLogs = await getLogsForSubject(subjectId);
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

  Future<void> _saveLogs() async {
    // No need to implement as we're using Firestore directly
  }

  Future<void> _loadLogs() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _logs.clear();
        return;
      }

      // First load from cache
      final cachedLogs = await CacheService.getCachedLogs();
      if (cachedLogs.isNotEmpty) {
        _logs.value = cachedLogs;
        _sortLogs();
      }

      // Then try to load from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('logs')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final fireStoreLogs =
          snapshot.docs.map((doc) => LogModel.fromMap(doc.data())).toList();
      if (fireStoreLogs.isNotEmpty) {
        _logs.value = fireStoreLogs;
        _sortLogs();
        // Update cache with new data
        await CacheService.cacheLogs(fireStoreLogs);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load logs: $e',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _loadLogs();
      } else {
        _logs.clear();
      }
    });
  }

  @override
  void onClose() {
    _saveLogs();
    super.onClose();
  }
}
