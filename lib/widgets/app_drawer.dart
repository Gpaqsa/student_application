import 'package:flutter/material.dart';
import '../providers/app_data.dart';
import '../screens/upload_page.dart';
import '../utils/colors.dart';

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final AppData appData;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.appData,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: 'Home',
            index: 0,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.book,
            title: 'My Modules',
            index: 1,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.calendar_today,
            title: 'Calendar',
            index: 2,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.checklist,
            title: 'To-Do List',
            index: 3,
          ),
          const Divider(),
          // _buildUploadItem(context),
          _buildSettingsItem(context),
          const Divider(),
          _buildAboutItem(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return const DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'John Doe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'john.doe@university.edu',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
      onTap: () {
        onItemSelected(index);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildUploadItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.upload_file, color: AppColors.textSecondary),
      title: const Text('Upload Materials'),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UploadPage(appData: appData),
          ),
        );
      },
    );
  }

  Widget _buildSettingsItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.settings, color: AppColors.textSecondary),
      title: const Text('Settings'),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings page coming soon!')),
        );
      },
    );
  }

  Widget _buildAboutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline, color: AppColors.textSecondary),
      title: const Text('About'),
      onTap: () {
        Navigator.pop(context);
        showAboutDialog(
          context: context,
          applicationName: 'ScholarSync',
          applicationVersion: '1.0.0',
          applicationIcon: const Icon(Icons.school, size: 48),
          children: const [
            Text('A comprehensive student management application'),
            Text('for university students and educators.'),
          ],
        );
      },
    );
  }
}
