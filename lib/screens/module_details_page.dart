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

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
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
              padding: const EdgeInsets.all(16),
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

  Widget _buildTasksTab(AppData appData) {
    final tasks = appData.getModuleTasks(widget.module.code);

    if (tasks.isEmpty) {
      return _buildEmptyTasksState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
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
              'Due: ${DateFormat('MMM d, yyyy').format(task.dueDate)}',
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

  Widget _buildMaterialsTab(AppData appData) {
    final materials = appData.getModuleMaterials(widget.module.code);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => _showUploadMaterialDialog(context, appData),
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Material'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.module.color,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: materials.isEmpty
              ? _buildEmptyMaterialsState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: materials.length,
                  itemBuilder: (context, index) {
                    final material = materials[index];
                    return _buildMaterialCard(material, appData);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMaterialCard(StudyMaterial material, AppData appData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getMaterialColor(material.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getMaterialIcon(material.type),
            color: _getMaterialColor(material.type),
            size: 28,
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
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getMaterialColor(material.type).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    material.type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: _getMaterialColor(material.type),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  material.formattedSize,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Uploaded: ${DateFormat('MMM d, yyyy').format(material.uploadDate)}',
              style: const TextStyle(fontSize: 11),
            ),
            if (material.uploadedBy.isNotEmpty)
              Text(
                'By: ${material.uploadedBy}',
                style: const TextStyle(fontSize: 11),
              ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'download',
              child: Row(
                children: [
                  Icon(Icons.download, size: 20),
                  SizedBox(width: 8),
                  Text('Download'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: AppColors.error),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'download') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Downloading ${material.title}...')),
              );
            } else if (value == 'delete') {
              _confirmDeleteMaterial(context, material.id, appData);
            }
          },
        ),
      ),
    );
  }

  void _showUploadMaterialDialog(BuildContext context, AppData appData) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    String selectedType = 'PDF';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.upload_file, color: widget.module.color),
              const SizedBox(width: 8),
              const Text('Upload Material'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Material Title',
                      hintText: 'e.g., Lecture 5 Slides',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'File Type',
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
                      _buildTypeChip(
                          'PDF', Icons.picture_as_pdf, Colors.red, selectedType,
                          (type) {
                        setDialogState(() => selectedType = type);
                      }),
                      _buildTypeChip(
                          'PPTX', Icons.slideshow, Colors.orange, selectedType,
                          (type) {
                        setDialogState(() => selectedType = type);
                      }),
                      _buildTypeChip(
                          'DOCX', Icons.description, Colors.blue, selectedType,
                          (type) {
                        setDialogState(() => selectedType = type);
                      }),
                      _buildTypeChip(
                          'XLSX', Icons.table_chart, Colors.green, selectedType,
                          (type) {
                        setDialogState(() => selectedType = type);
                      }),
                      _buildTypeChip('Video', Icons.video_library,
                          Colors.purple, selectedType, (type) {
                        setDialogState(() => selectedType = type);
                      }),
                      _buildTypeChip(
                          'ZIP', Icons.folder_zip, Colors.grey, selectedType,
                          (type) {
                        setDialogState(() => selectedType = type);
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.module.color,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: widget.module.color.withOpacity(0.05),
                    ),
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('File picker will be implemented here'),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload,
                            size: 40,
                            color: widget.module.color,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Click to select file',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: widget.module.color,
                            ),
                          ),
                        ],
                      ),
                    ),
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
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newMaterial = StudyMaterial(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    type: selectedType,
                    moduleCode: widget.module.code,
                    uploadDate: DateTime.now(),
                    sizeInBytes: 2048576, // Demo: 2 MB
                    uploadedBy: 'Current User',
                  );

                  appData.addMaterial(newMaterial);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('${newMaterial.title} uploaded successfully!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.module.color,
              ),
              child: const Text(
                'Upload',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(
    String label,
    IconData icon,
    Color color,
    String selectedType,
    Function(String) onSelected,
  ) {
    final isSelected = selectedType == label;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? color : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) onSelected(label);
      },
      selectedColor: color.withOpacity(0.2),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  void _confirmDeleteMaterial(
      BuildContext context, String materialId, AppData appData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Material'),
        content: const Text(
          'Are you sure you want to delete this material? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appData.deleteMaterial(materialId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Material deleted successfully'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

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
              'Upload study materials to share with students',
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

  IconData _getMaterialIcon(String type) {
    switch (type.toUpperCase()) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'PPTX':
      case 'PPT':
        return Icons.slideshow;
      case 'DOCX':
      case 'DOC':
        return Icons.description;
      case 'XLSX':
      case 'XLS':
        return Icons.table_chart;
      case 'VIDEO':
      case 'MP4':
      case 'AVI':
        return Icons.video_library;
      case 'ZIP':
      case 'RAR':
        return Icons.folder_zip;
      case 'TXT':
        return Icons.text_snippet;
      case 'IMAGE':
      case 'JPG':
      case 'PNG':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getMaterialColor(String type) {
    switch (type.toUpperCase()) {
      case 'PDF':
        return Colors.red;
      case 'PPTX':
      case 'PPT':
        return Colors.orange;
      case 'DOCX':
      case 'DOC':
        return Colors.blue;
      case 'XLSX':
      case 'XLS':
        return Colors.green;
      case 'VIDEO':
      case 'MP4':
      case 'AVI':
        return Colors.purple;
      case 'ZIP':
      case 'RAR':
        return Colors.grey;
      case 'TXT':
        return Colors.blueGrey;
      case 'IMAGE':
      case 'JPG':
      case 'PNG':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
