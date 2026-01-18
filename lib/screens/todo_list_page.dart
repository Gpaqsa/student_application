import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_data.dart';
import '../models/task.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Global key to access TodoListPage state
final GlobalKey<_TodoListPageState> todoListPageKey =
    GlobalKey<_TodoListPageState>();

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  String _filter = 'All';

  // Public method to change filter
  void setFilter(String newFilter) {
    print('Setting filter to: $newFilter');
    setState(() => _filter = newFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, appData, child) {
        final tasks = _getFilteredTasks(appData);

        if (tasks.isEmpty) {
          return _buildEmptyState(appData);
        }

        return Column(
          children: [
            _buildFilterChips(appData),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _buildTaskCard(task, appData);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<Task> _getFilteredTasks(AppData appData) {
    switch (_filter) {
      case 'Pending':
        return appData.tasks.where((t) => !t.isCompleted).toList()
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      case 'Completed':
        return appData.tasks.where((t) => t.isCompleted).toList()
          ..sort((a, b) => b.dueDate.compareTo(a.dueDate));
      case 'Overdue':
        return appData.tasks.where((t) => t.isOverdue).toList()
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      default:
        return appData.tasks..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    }
  }

  Widget _buildFilterChips(AppData appData) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterChip('All', appData.t('all')),
            const SizedBox(width: 12),
            _buildFilterChip('Pending', appData.t('pending')),
            const SizedBox(width: 12),
            _buildFilterChip('Completed', appData.t('completed')),
            const SizedBox(width: 12),
            _buildFilterChip('Overdue', appData.t('overdue')),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filter = value);
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildTaskCard(Task task, AppData appData) {
    final module = appData.getModuleByCode(task.moduleCode);
    final daysRemaining = task.daysRemaining;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (val) {
            appData.toggleTaskCompletion(task.id);
          },
          activeColor: module?.color ?? AppColors.primary,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
            color: task.isCompleted
                ? AppColors.textSecondary
                : AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: module?.color.withOpacity(0.2) ??
                        Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.moduleCode,
                    style: TextStyle(
                      fontSize: 11,
                      color: module?.color ?? Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getTaskColor(task.type).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.type,
                    style: TextStyle(
                      fontSize: 11,
                      color: _getTaskColor(task.type),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: task.isOverdue
                      ? AppColors.error
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  task.isCompleted
                      ? 'Completed'
                      : task.isOverdue
                          ? 'Overdue by ${-daysRemaining} days'
                          : daysRemaining == 0
                              ? 'Due today'
                              : 'Due in $daysRemaining days',
                  style: TextStyle(
                    fontSize: 12,
                    color: task.isOverdue
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            if (task.isCompleted && task.earnedScore != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 14,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Score: ${task.earnedScore?.toStringAsFixed(0)}/${task.maxScore?.toStringAsFixed(0)} (${task.percentage?.toStringAsFixed(1)}%)',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: task.isOverdue && !task.isCompleted
            ? const Icon(Icons.warning, color: AppColors.error)
            : null,
        onTap: () {
          _showTaskDetails(task, appData);
        },
      ),
    );
  }

  void _showTaskDetails(Task task, AppData appData) {
    final module = appData.getModuleByCode(task.moduleCode);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
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
                      color: _getTaskColor(task.type).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getTaskIcon(task.type),
                      color: _getTaskColor(task.type),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.type,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getTaskColor(task.type),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow(
                Icons.school,
                'Module',
                task.moduleCode,
                module?.color,
              ),
              _buildDetailRow(
                Icons.calendar_today,
                'Due Date',
                DateFormat(AppConstants.dateFormatFull).format(task.dueDate),
                null,
              ),
              _buildDetailRow(
                Icons.priority_high,
                'Priority',
                task.priority == 3
                    ? 'High'
                    : task.priority == 2
                        ? 'Medium'
                        : 'Low',
                null,
              ),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Mark task as complete/incomplete
                    await appData.toggleTaskCompletion(task.id);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: task.isCompleted
                        ? AppColors.textSecondary
                        : AppColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    task.isCompleted
                        ? 'Mark as Incomplete'
                        : 'Mark as Complete',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildEmptyState(AppData appData) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _filter == 'Completed'
                  ? Icons.inbox_outlined
                  : Icons.check_circle_outline,
              size: 80,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              _filter == 'Completed'
                  ? appData.t('completedOnly')
                  : _filter == 'Overdue'
                      ? appData.t('overdue')
                      : appData.t('allTasks'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _filter == 'Completed'
                  ? 'Complete some tasks to see them here'
                  : _filter == 'Overdue'
                      ? 'Great! You\'re all caught up'
                      : 'Your tasks will appear here',
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getTaskColor(String type) {
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

  IconData _getTaskIcon(String type) {
    switch (type) {
      case AppConstants.typeAssignment:
        return Icons.assignment;
      case AppConstants.typeQuiz:
        return Icons.quiz;
      case AppConstants.typeExam:
        return Icons.school;
      case AppConstants.typeProject:
        return Icons.work;
      default:
        return Icons.task;
    }
  }

  void _showTaskScoreDialog(BuildContext context, Task task, AppData appData) {
    final scoreController =
        TextEditingController(text: task.earnedScore?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Score'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Task: ${task.title}'),
            const SizedBox(height: 16),
            TextField(
              controller: scoreController,
              decoration: InputDecoration(
                labelText: 'Score Earned',
                hintText: 'e.g., 85',
                suffixText: '/ ${task.maxScore ?? 100}',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final score = double.tryParse(scoreController.text);
              if (score != null) {
                final updatedTask = task.copyWith(earnedScore: score);
                appData.updateTask(updatedTask);
                appData.updateModuleGrade(task.moduleCode);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
