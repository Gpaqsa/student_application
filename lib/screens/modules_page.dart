// lib/screens/modules_page.dart
// Displays list of all enrolled modules/courses
// Shows module cards with grades and quick navigation to details

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../models/module.dart';
import 'module_details_page.dart';

class ModulesPage extends StatelessWidget {
  const ModulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Modules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppData>(
        builder: (context, appData, child) {
          if (appData.modules.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: appData.modules.length,
            itemBuilder: (context, index) {
              final module = appData.modules[index];
              return _buildModuleCard(context, module, appData);
            },
          );
        },
      ),
    );
  }

  Widget _buildModuleCard(
      BuildContext context, Module module, AppData appData) {
    final moduleTasks = appData.getModuleTasks(module.code);
    final pendingTasks = moduleTasks.where((t) => !t.isCompleted).length;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ModuleDetailsPage(module: module),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              // Module icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: module.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                child: Icon(
                  Icons.book,
                  color: module.color,
                  size: 30,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              // Module info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.code,
                      style: TextStyle(
                        color: module.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.instructor,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.assignment,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$pendingTasks pending tasks',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Grade display
              Column(
                children: [
                  Text(
                    '${module.grade}%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: module.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Grade',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 80,
              color: AppColors.textHint,
            ),
            SizedBox(height: 16),
            Text(
              'No Modules Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your enrolled modules will appear here',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
