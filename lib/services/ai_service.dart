import 'dart:convert';
import 'package:f_star/controllers/attendance_list_controller.dart';
import 'package:f_star/models/attendance_model.dart';
import 'package:f_star/models/log_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../controllers/log_controller.dart';

class AIService {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  Map<String, dynamic> attendanceData = {};
  List<AttendanceModel> get subjects =>
      Get.find<AttendanceListController>().attendanceList;

  AIService() {
    initData();
  }

  void initData() async {
    final logController = Get.find<LogController>();

    // Prepare detailed subject data with stats
    List<Map<String, dynamic>> subjectDetails = [];
    for (var subject in subjects) {
      final stats = await logController.getAttendanceStats(subject.subject);
      final history = await logController.getLogsForSubject(subject.subject);
      subjectDetails.add({
        'name': subject.subject,
        'attendance': subject.attendancePercentage,
        'total_classes': subject.totalClasses,
        'present': stats[AttendanceType.present] ?? 0,
        'absent': stats[AttendanceType.absent] ?? 0,
        'leaves': stats[AttendanceType.leave] ?? 0,
        'required': subject.requiredPercentage,
        'is_passing': subject.isPassing,
        'history': history.map((log) => log.toMap()).toList(),
      });
    }

    // Calculate overall statistics
    final overallAttendance = subjects.isEmpty
        ? 0.0
        : subjects.fold<double>(0, (sum, s) => sum + s.attendancePercentage) /
            subjects.length;
    final subjectsAtRisk = subjects.where((s) => !s.isPassing).length;

    // Prepare attendance data
    attendanceData = {
      'overall_attendance': overallAttendance,
      'total_subjects': subjects.length,
      'subjects_at_risk': subjectsAtRisk,
      'subjects': subjectDetails,
    };
  }

  Future<String> getAIResponse(String query) async {
    try {
      final url = Uri.parse('$_baseUrl?key=$_apiKey');

      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text':
                    '''Prompt: answer the query as accurately as possible. If context lacks relevant data, use your general knowledge. (Give answers and dont say provided data is missing)\n\n,
                Query: $query
                
                Context:
                Overall Attendance: ${(attendanceData['overall_attendance'] as double).toStringAsFixed(1)}%
                Total Subjects: ${attendanceData['total_subjects']}
                Subjects at Risk: ${attendanceData['subjects_at_risk']}
                
                Subject Details:
                ${_formatSubjects(attendanceData['subjects'] as List<Map<String, dynamic>>)}
                '''
              }
            ]
          }
        ]
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _extractResponse(data) ?? _getFallbackResponse(attendanceData);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      return _getFallbackResponse({
        'overall_attendance': subjects.isEmpty
            ? 0.0
            : subjects.fold<double>(
                    0, (sum, s) => sum + s.attendancePercentage) /
                subjects.length,
        'total_subjects': subjects.length,
        'subjects_at_risk': subjects.where((s) => !s.isPassing).length,
      });
    }
  }

  static String _formatSubjects(List<Map<String, dynamic>> subjects) {
    return subjects
        .map((s) => '- ${s['name']}: ${s['attendance'].toStringAsFixed(1)}% '
            '(Present: ${s['present']}, Absent: ${s['absent']}, Leaves: ${s['leaves']}, '
            'Required: ${s['required']}%, Status: ${s['is_passing'] ? 'Passing' : 'At Risk'}) ${s['history']}')
        .join('\n');
  }

  static String? _extractResponse(Map<String, dynamic> data) {
    try {
      return data['candidates'][0]['content']['parts'][0]['text'] as String;
    } catch (e) {
      return null;
    }
  }

  static String _getFallbackResponse(Map<String, dynamic> data) {
    final overallAttendance = data['overall_attendance'] as double;
    final atRisk = data['subjects_at_risk'] as int;

    if (atRisk > 0) {
      return "Based on your attendance data:\n\n"
          "📊 Overall Attendance: ${overallAttendance.toStringAsFixed(1)}%\n"
          "⚠️ You have $atRisk subject(s) that need attention.\n"
          "💡 Consider focusing on improving attendance in these subjects.";
    } else {
      return "Great job managing your attendance!\n\n"
          "📊 Overall Attendance: ${overallAttendance.toStringAsFixed(1)}%\n"
          "✅ All your subjects are in good standing.\n"
          "🌟 Keep up the excellent work!";
    }
  }
}
