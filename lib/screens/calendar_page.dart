// lib/screens/calendar_page.dart
// Monthly calendar view showing all events and deadlines
// Allows users to select dates and view scheduled items

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_data.dart';
import '../models/calendar_event.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
                _focusedDate = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: Consumer<AppData>(
        builder: (context, appData, child) {
          return Column(
            children: [
              _buildMonthHeader(),
              _buildWeekdayHeader(),
              _buildCalendarGrid(appData),
              const Divider(height: 1),
              Expanded(child: _buildEventsList(appData)),
            ],
          );
        },
      ),
    );
  }

  // Month navigation header
  Widget _buildMonthHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _focusedDate = DateTime(
                  _focusedDate.year,
                  _focusedDate.month - 1,
                );
              });
            },
          ),
          Text(
            DateFormat(AppConstants.dateFormatMonth).format(_focusedDate),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _focusedDate = DateTime(
                  _focusedDate.year,
                  _focusedDate.month + 1,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  // Weekday labels
  Widget _buildWeekdayHeader() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
            .map((day) => SizedBox(
                  width: 40,
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  // Calendar grid
  Widget _buildCalendarGrid(AppData appData) {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final lastDayOfMonth =
        DateTime(_focusedDate.year, _focusedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: Column(
        children: List.generate(6, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - startWeekday + 1;

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const SizedBox(width: 40, height: 40);
                }

                final date = DateTime(
                  _focusedDate.year,
                  _focusedDate.month,
                  dayNumber,
                );

                final hasEvents = appData.calendarEvents.any((e) =>
                    e.date.year == date.year &&
                    e.date.month == date.month &&
                    e.date.day == date.day);

                final isSelected = _selectedDate.year == date.year &&
                    _selectedDate.month == date.month &&
                    _selectedDate.day == date.day;

                final isToday = DateTime.now().year == date.year &&
                    DateTime.now().month == date.month &&
                    DateTime.now().day == date.day;

                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isToday
                              ? AppColors.primary.withOpacity(0.2)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: isToday && !isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '$dayNumber',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isToday
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                            fontWeight:
                                isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (hasEvents)
                          Positioned(
                            bottom: 4,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }

  // Events list for selected date
  Widget _buildEventsList(AppData appData) {
    final eventsForDay = appData.calendarEvents
        .where((e) =>
            e.date.year == _selectedDate.year &&
            e.date.month == _selectedDate.month &&
            e.date.day == _selectedDate.day)
        .toList();

    if (eventsForDay.isEmpty) {
      return _buildEmptyEventsState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: eventsForDay.length,
      itemBuilder: (context, index) {
        final event = eventsForDay[index];
        return _buildEventCard(event, appData);
      },
    );
  }

  Widget _buildEventCard(CalendarEvent event, AppData appData) {
    final module = appData.getModuleByCode(event.moduleCode);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getEventColor(event.type),
          child: Text(
            event.type[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              event.moduleCode,
              style: TextStyle(
                fontSize: 12,
                color: module?.color ?? AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                event.description,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: Text(
          DateFormat(AppConstants.timeFormat).format(event.date),
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyEventsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_available,
              size: 64,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              'No events on ${DateFormat(AppConstants.dateFormatShort).format(_selectedDate)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your schedule is clear for this day',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Color _getEventColor(String type) {
    switch (type) {
      case AppConstants.typeAssignment:
        return AppColors.assignment;
      case AppConstants.typeQuiz:
        return AppColors.quiz;
      case AppConstants.typeExam:
        return AppColors.exam;
      case AppConstants.typeProject:
        return AppColors.project;
      default:
        return Colors.grey;
    }
  }
}
