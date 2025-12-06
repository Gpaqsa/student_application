import 'package:flutter/material.dart';
import '../providers/app_data.dart';
import '../models/study_material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class UploadPage extends StatefulWidget {
  final AppData appData;

  const UploadPage({
    Key? key,
    required this.appData,
  }) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String? _selectedModule;
  String _selectedType = AppConstants.materialPDF;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Materials'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              Card(
                color: AppColors.primary.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Row(
                    children: const [
                      Icon(Icons.upload_file,
                          color: AppColors.primary, size: 32),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Upload study materials to share with students',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Material title
              const Text(
                'Material Title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g., Lecture 5: Data Structures',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.buttonRadius),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Material type
              const Text(
                'Material Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildTypeChip(
                      AppConstants.materialPDF, Icons.picture_as_pdf),
                  _buildTypeChip(
                      AppConstants.materialVideo, Icons.video_library),
                  _buildTypeChip(AppConstants.materialSlides, Icons.slideshow),
                  _buildTypeChip(
                      AppConstants.materialDocument, Icons.insert_drive_file),
                ],
              ),
              const SizedBox(height: 20),

              // Module selection
              const Text(
                'Assign to Module',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedModule,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.buttonRadius),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                hint: const Text('Select a module'),
                items: widget.appData.modules.map((module) {
                  return DropdownMenuItem(
                    value: module.code,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: module.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${module.code} - ${module.name}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedModule = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a module';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // File upload button
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  color: AppColors.primary.withOpacity(0.05),
                ),
                child: InkWell(
                  onTap: () {
                    // TODO: Implement file picker
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('File picker will be implemented here'),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Click to select file',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Supported formats: PDF, MP4, PPTX, DOCX',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Upload button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleUpload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.buttonRadius),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Upload Material',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Recent uploads section
              const SizedBox(height: 24),
              const Text(
                'Recent Uploads',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...widget.appData.materials.take(5).map((material) {
                final module =
                    widget.appData.getModuleByCode(material.moduleCode);
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: module?.color.withOpacity(0.2) ??
                          Colors.grey.withOpacity(0.2),
                      child: Icon(
                        _getMaterialIcon(material.type),
                        color: module?.color ?? Colors.grey,
                      ),
                    ),
                    title: Text(material.title),
                    subtitle: Text(
                      '${material.moduleCode} • ${material.formattedSize}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                      ),
                      onPressed: () {
                        _confirmDelete(material.id);
                      },
                    ),
                  ),
                );
              }),
              if (widget.appData.materials.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: const [
                        Icon(
                          Icons.folder_open,
                          size: 48,
                          color: AppColors.textHint,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No materials uploaded yet',
                          style: TextStyle(
                            color: AppColors.textSecondary,
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
    );
  }

  Widget _buildTypeChip(String type, IconData icon) {
    final isSelected = _selectedType == type;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(type),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedType = type);
        }
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  void _handleUpload() {
    if (_formKey.currentState!.validate()) {
      // Create new material
      final newMaterial = StudyMaterial(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        type: _selectedType,
        moduleCode: _selectedModule!,
        uploadDate: DateTime.now(),
        sizeInBytes: 2048576, // Demo size (2 MB)
        uploadedBy: 'Current User',
      );

      // Add to data provider
      widget.appData.addMaterial(newMaterial);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newMaterial.title} uploaded successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Clear form
      _titleController.clear();
      setState(() {
        _selectedModule = null;
        _selectedType = AppConstants.materialPDF;
      });
    }
  }

  void _confirmDelete(String materialId) {
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
              widget.appData.deleteMaterial(materialId);
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
