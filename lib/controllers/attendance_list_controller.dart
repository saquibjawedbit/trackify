import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/attendance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/cache_service.dart';

class AttendanceListController extends GetxController {
  final attendanceList = <AttendanceModel>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAttendance();
  }

  Future<void> loadAttendance() async {
    try {
      // First load from cache
      final cachedData = await CacheService.getCachedAttendance();
      if (cachedData.isNotEmpty) {
        attendanceList.value = cachedData;
      }

      // Then try to load from Firestore
      final subjects = await AttendanceModel.loadAllFromFirestore();

      if (subjects.isNotEmpty) {
        attendanceList.value = subjects;
        // Update cache with new data
        await CacheService.cacheAttendance(subjects);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load attendance: $e',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  Future<void> updateAttendance(AttendanceModel updatedAttendance) async {
    try {
      await updatedAttendance.saveToFirestore();
      final index =
          attendanceList.indexWhere((a) => a.uid == updatedAttendance.uid);
      if (index != -1) {
        attendanceList[index] = updatedAttendance;
        attendanceList.refresh();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update attendance: $e',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  Future<void> addSubject(AttendanceModel subject) async {
    try {
      // Create new subject without uid
      final newSubject = AttendanceModel(
        subject: subject.subject,
        requiredPercentage: subject.requiredPercentage,
      );

      // Save to Firestore (this will create new document and set uid)
      await newSubject.saveToFirestore();

      // Reload attendance list to get updated data
      await loadAttendance();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add subject: $e',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  Future<void> deleteSubject(String subjectId) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final subject = await FirebaseFirestore.instance
          .collection('attendance')
          .where('userId', isEqualTo: uid)
          .where('subject', isEqualTo: subjectId)
          // Ensure it belongs to the current user
          .get();

      // Delete the subject document
      for (var doc in subject.docs) {
        await doc.reference.delete();
      }

      attendanceList.removeWhere((s) => s.subject == subjectId);

      // Delete associated logs
      final batch = FirebaseFirestore.instance.batch();
      final logs = await FirebaseFirestore.instance
          .collection('logs')
          .where('subjectId', isEqualTo: subjectId)
          .where(
            'userId',
            isEqualTo: uid,
          ) // Ensure logs belong to the current user
          .get();

      // Add delete operations to batch
      for (var doc in logs.docs) {
        batch.delete(doc.reference);
      }

      // Execute batch
      await batch.commit();

      // Clear both caches since we've deleted logs and attendance
      await CacheService.clearAllCache();

      attendanceList.refresh();
      Get.snackbar(
        'Success',
        'Subject and related logs deleted',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete subject: $e',
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  List<AttendanceModel> get filteredAttendanceList {
    if (searchQuery.isEmpty) return attendanceList;
    return attendanceList
        .where((subject) => subject.subject
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
