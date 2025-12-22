import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_data.dart';
import '../models/calendar_event.dart';
import '../models/task.dart';
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
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
            DateFormat('MMMM yyyy').format(_focusedDate),
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

  Widget _buildWeekdayHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _buildCalendarGrid(AppData appData) {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final lastDayOfMonth =
        DateTime(_focusedDate.year, _focusedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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

                final eventsForDay = appData.calendarEvents
                    .where((e) =>
                    e.date.year == date.year &&
                    e.date.month == date.month &&
                        e.date.day == date.day)
                    .toList();

                final hasEvents = eventsForDay.isNotEmpty;
                final hasExam = eventsForDay.any((e) => e.type == 'Exam');

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
                              : hasExam
                                  ? AppColors.error.withOpacity(0.1)
                                  : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: isToday && !isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : hasExam && !isSelected
                              ? Border.all(color: AppColors.error, width: 2)
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
                                    : hasExam
                                        ? AppColors.error
                                        : AppColors.textPrimary,
                            fontWeight: (isToday || hasExam)
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (hasEvents && !isSelected)
                          Positioned(
                            bottom: 4,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: hasExam
                                    ? AppColors.error
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

  Widget _buildEventsList(AppData appData) {
    final eventsForDay = appData.calendarEvents
        .where((e) =>
            e.date.year == _selectedDate.year &&
            e.date.month == _selectedDate.month &&
            e.date.day == _selectedDate.day)
        .toList();

    eventsForDay.sort((a, b) {
      if (a.type == 'Exam' && b.type != 'Exam') return -1;
      if (a.type != 'Exam' && b.type == 'Exam') return 1;
      return a.date.compareTo(b.date);
    });

    if (eventsForDay.isEmpty) {
      return _buildEmptyEventsState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: eventsForDay.length,
      itemBuilder: (context, index) {
        final event = eventsForDay[index];
        return _buildEventCard(event, appData);
      },
    );
  }

  Widget _buildEventCard(CalendarEvent event, AppData appData) {
    final module = appData.getModuleByCode(event.moduleCode);
    final isExam = event.type == 'Exam';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isExam ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isExam
            ? const BorderSide(color: AppColors.error, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: _getEventColor(event.type),
          child: Icon(
            _getEventIcon(event.type),
            color: Colors.white,
          ),
        ),
        title: Text(
          event.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isExam ? 16 : 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.school,
                  size: 14,
                  color: module?.color ?? AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  event.moduleCode,
                  style: TextStyle(
                    fontSize: 13,
                    color: module?.color ?? AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('h:mm a').format(event.date),
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            if (event.location.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    event.location,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ],
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                event.description,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: isExam
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'EXAM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        onTap: () => _showEventDetails(event, appData),
      ),
    );
  }

  void _showEventDetails(CalendarEvent event, AppData appData) {
    final module = appData.getModuleByCode(event.moduleCode);
    final isExam = event.type == 'Exam';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getEventColor(event.type).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getEventIcon(event.type),
                    color: _getEventColor(event.type),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getEventColor(event.type).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          event.type,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getEventColor(event.type),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow(
              Icons.school,
              'Module',
              event.moduleCode,
              module?.color,
            ),
            _buildDetailRow(
              Icons.calendar_today,
              'Date',
              DateFormat('EEEE, MMMM d, yyyy').format(event.date),
              null,
            ),
            _buildDetailRow(
              Icons.access_time,
              'Time',
              DateFormat('h:mm a').format(event.date),
              null,
            ),
            if (event.location.isNotEmpty)
              _buildDetailRow(
                Icons.location_on,
                'Location',
                event.location,
                null,
              ),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: const TextStyle(fontSize: 14),
              ),
            ],
            if (isExam) ...[
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error, width: 2),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: AppColors.error),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Important: Don\'t forget to prepare for this exam!',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedModule;
    String selectedType = 'Assignment'; // Default type
    TimeOfDay selectedTime = TimeOfDay.now();
    int selectedPriority = 2; // Default: Medium

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final taskColor = _getEventColor(selectedType);

          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  _getEventIcon(selectedType),
                  color: taskColor,
                ),
                const SizedBox(width: 8),
                const Text('Create New Task'),
              ],
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Title
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        hintText: 'e.g., Midterm Exam, Assignment 1',
                        prefixIcon: const Icon(Icons.title),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: taskColor, width: 2),
                        ),
                        labelStyle: TextStyle(color: taskColor),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter task title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Task Type Selection
                    const Text(
                      'Task Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildTaskTypeChip(
                          'Assignment',
                          Icons.assignment,
                          selectedType,
                          (type) => setDialogState(() => selectedType = type),
                        ),
                        _buildTaskTypeChip(
                          'Quiz',
                          Icons.quiz,
                          selectedType,
                          (type) => setDialogState(() => selectedType = type),
                        ),
                        _buildTaskTypeChip(
                          'Exam',
                          Icons.school,
                          selectedType,
                          (type) => setDialogState(() => selectedType = type),
                        ),
                        _buildTaskTypeChip(
                          'Project',
                          Icons.work,
                          selectedType,
                          (type) => setDialogState(() => selectedType = type),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Module Selection
                    DropdownButtonFormField<String>(
                      initialValue: selectedModule,
                      decoration: InputDecoration(
                        labelText: 'Module',
                        prefixIcon: const Icon(Icons.book),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: taskColor, width: 2),
                        ),
                        labelStyle: TextStyle(color: taskColor),
                      ),
                      hint: const Text('Select module'),
                      items: Provider.of<AppData>(context, listen: false)
                          .modules
                          .map((module) {
                        return DropdownMenuItem(
                          value: module.code,
                          child: Text('${module.code} - ${module.name}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() => selectedModule = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a module';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Date Picker
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.calendar_today, color: taskColor),
                      title: const Text('Due Date'),
                      subtitle: Text(
                        DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
                      ),
                      trailing: const Icon(Icons.edit),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setDialogState(() => _selectedDate = picked);
                        }
                      },
                    ),
                    const Divider(),

                    // Time Picker
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.access_time, color: taskColor),
                      title: const Text('Time'),
                      subtitle: Text(selectedTime.format(context)),
                      trailing: const Icon(Icons.edit),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          setDialogState(() => selectedTime = picked);
                        }
                      },
                    ),
                    const Divider(),

                    // Priority Selection
                    const SizedBox(height: 8),
                    const Text(
                      'Priority',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPriorityChip(
                            'Low',
                            1,
                            selectedPriority,
                            Colors.green,
                            (priority) => setDialogState(
                                () => selectedPriority = priority),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildPriorityChip(
                            'Medium',
                            2,
                            selectedPriority,
                            Colors.orange,
                            (priority) => setDialogState(
                                () => selectedPriority = priority),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildPriorityChip(
                            'High',
                            3,
                            selectedPriority,
                            Colors.red,
                            (priority) => setDialogState(
                                () => selectedPriority = priority),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Location (Optional)
                    TextFormField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'Location (Optional)',
                        hintText: 'e.g., Room 201',
                        prefixIcon: const Icon(Icons.location_on),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: taskColor, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description (Optional)
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText: 'Additional details...',
                        prefixIcon: const Icon(Icons.description),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: taskColor, width: 2),
                        ),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final appData =
                        Provider.of<AppData>(context, listen: false);
                    
                    final taskDateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    final newTask = Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      moduleCode: selectedModule!,
                      dueDate: taskDateTime,
                      type: selectedType,
                      description: descriptionController.text,
                      priority: selectedPriority,
                    );

                    appData.addTask(newTask);

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$selectedType added successfully!'),
                        backgroundColor: AppColors.success,
                      ),
                    );

                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: taskColor,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add),
                label: Text('Create $selectedType'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTaskTypeChip(
    String label,
    IconData icon,
    String selectedType,
    Function(String) onSelected,
  ) {
    final isSelected = selectedType == label;
    final chipColor = _getEventColor(label);

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? chipColor : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) onSelected(label);
      },
      selectedColor: chipColor.withOpacity(0.2),
      checkmarkColor: chipColor,
      labelStyle: TextStyle(
        color: isSelected ? chipColor : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildPriorityChip(
    String label,
    int priority,
    int selectedPriority,
    Color color,
    Function(int) onSelected,
  ) {
    final isSelected = selectedPriority == priority;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) onSelected(priority);
      },
      selectedColor: color.withOpacity(0.2),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value, Color? color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: AppColors.textPrimary),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 14,
                      color: color ?? AppColors.textPrimary,
                      fontWeight:
                          color != null ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
              'No events on ${DateFormat('MMM d, yyyy').format(_selectedDate)}',
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
      case 'Assignment':
        return AppColors.assignment;
      case 'Quiz':
        return AppColors.quiz;
      case 'Exam':
        return AppColors.exam;
      case 'Project':
        return AppColors.project;
      default:
        return Colors.grey;
    }
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'Assignment':
        return Icons.assignment;
      case 'Quiz':
        return Icons.quiz;
      case 'Exam':
        return Icons.school;
      case 'Project':
        return Icons.work;
      default:
        return Icons.event;
    }
  }
}
