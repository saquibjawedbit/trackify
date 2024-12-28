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
      Get.snackbar('Error', 'Failed to load attendance: $e');
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
      Get.snackbar('Error', 'Failed to update attendance: $e');
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

      Get.snackbar('Success', 'Subject added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add subject: $e');
    }
  }

  Future<void> deleteSubject(String uid) async {
    await FirebaseFirestore.instance.collection('attendance').doc(uid).delete();
    attendanceList.removeWhere((s) => s.uid == uid);

    // Delete associated logs
    final batch = FirebaseFirestore.instance.batch();
    final logs = await FirebaseFirestore.instance
        .collection('logs')
        .where('subjectId', isEqualTo: uid)
        .get();

    for (var doc in logs.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    attendanceList.refresh();
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
