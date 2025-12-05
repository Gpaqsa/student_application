// lib/screens/module_details_page.dart
// Detailed view of a single module with tabs
// Shows Overview, Tasks, and Materials for the module

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_data.dart';
import '../models/module.dart';
import '../models/task.dart';
import '../models/study_material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class ModuleDetailsPage extends StatefulWidget {
  final Module module;

  const ModuleDetailsPage({
    Key? key,
    required this.module,
  }) : super(key: key);

  @override
  State<ModuleDetailsPage> createState() => _ModuleDetailsPageState();
}

class _ModuleDetailsPageState extends State<ModuleDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.module.code),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Tasks'),
            Tab(text: 'Materials'),
          ],
        ),
      ),
      body: Consumer<AppData>(
        builder: (context, appData, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(),
              _buildTasksTab(appData),
              _buildMaterialsTab(appData),
            ],
          );
        },
      ),
    );
  }

  // Overview Tab
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module header card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.module.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.module.code,
                          style: TextStyle(
                            color: widget.module.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.module.grade}%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: widget.module.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.module.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                      Icons.person, 'Instructor', widget.module.instructor),
                  _buildInfoRow(Icons.description, 'Description',
                      widget.module.description),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Syllabus section
          const Text(
            'Course Syllabus',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.module.syllabus.map((topic) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 16)),
                        Expanded(child: Text(topic)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tasks Tab
  Widget _buildTasksTab(AppData appData) {
    final tasks = appData.getModuleTasks(widget.module.code);

    if (tasks.isEmpty) {
      return _buildEmptyTasksState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task, appData);
      },
    );
  }

  Widget _buildTaskCard(Task task, AppData appData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (val) {
            appData.toggleTaskCompletion(task.id);
          },
          activeColor: widget.module.color,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Due: ${DateFormat(AppConstants.dateFormatShort).format(task.dueDate)}',
              style: TextStyle(
                fontSize: 12,
                color:
                    task.isOverdue ? AppColors.error : AppColors.textSecondary,
              ),
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                task.description,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getTaskColor(task.type).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            task.type,
            style: TextStyle(
              fontSize: 10,
              color: _getTaskColor(task.type),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Materials Tab
  Widget _buildMaterialsTab(AppData appData) {
    final materials = appData.getModuleMaterials(widget.module.code);

    if (materials.isEmpty) {
      return _buildEmptyMaterialsState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: materials.length,
      itemBuilder: (context, index) {
        final material = materials[index];
        return _buildMaterialCard(material);
      },
    );
  }

  Widget _buildMaterialCard(StudyMaterial material) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: widget.module.color.withOpacity(0.2),
          child: Icon(
            _getMaterialIcon(material.type),
            color: widget.module.color,
          ),
        ),
        title: Text(
          material.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Uploaded: ${DateFormat(AppConstants.dateFormatShort).format(material.uploadDate)}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Size: ${material.formattedSize}',
              style: const TextStyle(fontSize: 12),
            ),
            if (material.uploadedBy.isNotEmpty)
              Text(
                'By: ${material.uploadedBy}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Downloading ${material.title}...')),
            );
          },
        ),
      ),
    );
  }

  // Helper methods
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: AppColors.textPrimary),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTasksState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined,
                size: 64, color: AppColors.textHint),
            SizedBox(height: 16),
            Text(
              'No Tasks Yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Tasks and assignments will appear here',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyMaterialsState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_outlined, size: 64, color: AppColors.textHint),
            SizedBox(height: 16),
            Text(
              'No Materials Yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Study materials will be available here',
              style: TextStyle(color: AppColors.textSecondary),
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

  IconData _getMaterialIcon(String type) {
    switch (type) {
      case AppConstants.materialPDF:
        return Icons.picture_as_pdf;
      case AppConstants.materialVideo:
        return Icons.video_library;
      case AppConstants.materialSlides:
        return Icons.slideshow;
      default:
        return Icons.insert_drive_file;
    }
  }
}
