// lib/screens/home_page.dart
// Dashboard showing overview, stats, and upcoming tasks
// First screen users see when opening the app

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_data.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../models/task.dart';

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
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(),
                const SizedBox(height: 24),
                _buildStatsRow(appData),
                const SizedBox(height: 24),
                _buildSectionHeader('Upcoming Tasks'),
                const SizedBox(height: 12),
                ...appData.upcomingTasks.take(5).map(
                      (task) => _buildTaskCard(context, task, appData),
                    ),
                if (appData.upcomingTasks.isEmpty) _buildEmptyState(),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('View All Tasks →'),
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
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
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
              DateFormat(AppConstants.dateFormatFull).format(DateTime.now()),
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

  Widget _buildStatsRow(AppData appData) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Active Modules',
            '${appData.modules.length}',
            Icons.book,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Pending Tasks',
            '${appData.pendingTasksCount}',
            Icons.assignment,
            AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getTaskColor(task.type),
          child: Text(
            task.type[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${task.moduleCode} • Due in $daysLeft days',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to task details
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.check_circle_outline,
                size: 64, color: AppColors.success),
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
