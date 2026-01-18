import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/grade_calculator.dart';
import '../models/module.dart';
import 'module_details_page.dart';

class ModulesPage extends StatelessWidget {
  const ModulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          '$pendingTasks ${appData.t('pending')}',
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
                    GradeCalculator.getLetterGrade(module.grade),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: GradeCalculator.getGradeColor(module.grade),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${module.grade.toStringAsFixed(1)}%',
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Consumer<AppData>(
      builder: (context, appData, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school_outlined,
                size: 80,
                color: AppColors.textHint,
              ),
              const SizedBox(height: 16),
              Text(
                appData.t('noModules'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                appData.t('applicationDescription'),
                style: const TextStyle(
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
}
