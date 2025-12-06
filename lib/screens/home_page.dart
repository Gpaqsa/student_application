import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_data.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../models/task.dart';
import 'module_details_page.dart';
import 'main_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Consumer<AppData>(
        builder: (context, appData, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(),
                const SizedBox(height: 24),
                _buildStatsRow(appData, context),
                const SizedBox(height: 24),
                _buildSectionHeader('Upcoming Tasks'),
                const SizedBox(height: 12),
                ...appData.upcomingTasks.take(5).map(
                      (task) => _buildTaskCard(context, task, appData),
                    ),
                if (appData.upcomingTasks.isEmpty) _buildEmptyState(),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to To-Do List page (index 3) using global key
                      mainScreenKey.currentState?.navigateToPage(3);
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('View All Tasks'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(AppData appData, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Active Modules',
            '${appData.modules.length}',
            Icons.book,
            AppColors.primary,
            () {
              // Navigate to Modules page (index 1) using global key
              mainScreenKey.currentState?.navigateToPage(1);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Pending Tasks',
            '${appData.pendingTasksCount}',
            Icons.assignment,
            AppColors.warning,
            () {
              // Navigate to To-Do List page (index 3) using global key
              mainScreenKey.currentState?.navigateToPage(3);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task, AppData appData) {
    final daysLeft = task.daysRemaining;
    final module = appData.getModuleByCode(task.moduleCode);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showTaskDetails(context, task, appData);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: _getTaskColor(task.type),
                child: Icon(
                  _getTaskIcon(task.type),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
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
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: task.isOverdue
                              ? AppColors.error
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task.isOverdue
                              ? 'Overdue'
                              : daysLeft == 0
                                  ? 'Due today'
                                  : 'Due in $daysLeft days',
                          style: TextStyle(
                            fontSize: 12,
                            color: task.isOverdue
                                ? AppColors.error
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskDetails(BuildContext context, Task task, AppData appData) {
    final module = appData.getModuleByCode(task.moduleCode);

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
              DateFormat('EEEE, MMMM d, yyyy').format(task.dueDate),
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
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (module != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ModuleDetailsPage(module: module),
                          ),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side:
                          BorderSide(color: module?.color ?? AppColors.primary),
                    ),
                    child: Text(
                      'View Module',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: module?.color ?? AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      appData.toggleTaskCompletion(task.id);
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
                      task.isCompleted ? 'Incomplete' : 'Complete',
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
          ],
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: const [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.success,
            ),
            SizedBox(height: 16),
            Text(
              'All caught up!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'No upcoming tasks at the moment',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTaskColor(String type) {
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

  IconData _getTaskIcon(String type) {
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
        return Icons.task;
    }
  }
}
