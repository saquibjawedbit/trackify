import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/log_model.dart';
import '../../controllers/attendance_controller.dart';

class AttendanceCalendarScreen extends StatelessWidget {
  final AttendanceController controller;
  final Rx<CalendarFormat> calendarFormat;

  AttendanceCalendarScreen({
    super.key,
    required this.controller,
  }) : calendarFormat = CalendarFormat.month.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Calendar'),
      ),
      body: Column(
        children: [
          Obx(() {
            final events = _getEventsMap(controller.history);
            return TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.now(),
              focusedDay: DateTime.now(),
              calendarFormat: calendarFormat.value,
              onFormatChanged: (format) {
                calendarFormat.value = format;
              },
              eventLoader: (day) {
                final normalizedDay =
                    DateTime(day.year, day.month, day.day, 12);
                return events[normalizedDay] ?? [];
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isEmpty) return const SizedBox();

                  final logType = (events.first as LogModel).type;
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: logType == AttendanceType.present
                            ? Colors.green
                            : logType == AttendanceType.absent
                                ? Colors.red
                                : Colors.yellow,
                      ),
                    ),
                  );
                },
              ),
              onDaySelected: (selectedDay, focusedDay) {
                final normalizedDay = DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day, 12);
                if (events[normalizedDay]?.isNotEmpty ?? false) {
                  _showDayEvents(
                      context, normalizedDay, events[normalizedDay]!);
                }
              },
            );
          }),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LegendItem(color: Colors.green, label: 'Present'),
                _LegendItem(color: Colors.red, label: 'Absent'),
                _LegendItem(color: Colors.yellow, label: 'Leave'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<LogModel>> _getEventsMap(List<LogModel> history) {
    final events = <DateTime, List<LogModel>>{};
    for (var log in history) {
      final date = DateTime(log.date.year, log.date.month, log.date.day, 12);
      events[date] = [log]; // Simplified to always take the latest log
    }
    return events;
  }

  void _showDayEvents(
      BuildContext context, DateTime day, List<LogModel> events) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Attendance on ${day.day}/${day.month}/${day.year}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...events.map((event) => ListTile(
                  leading: Icon(
                    event.type == AttendanceType.present
                        ? Icons.check_circle
                        : event.type == AttendanceType.absent
                            ? Icons.cancel
                            : Icons.calendar_today,
                    color: event.type == AttendanceType.present
                        ? Colors.green
                        : event.type == AttendanceType.absent
                            ? Colors.red
                            : Colors.yellow,
                  ),
                  title: Text(event.type.toString().split('.').last),
                  subtitle: Text(event.reason ?? 'No reason provided'),
                )),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
