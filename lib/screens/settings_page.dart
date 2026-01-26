import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data.dart';
import '../utils/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AppData>(
          builder: (context, appData, _) {
            return Text(appData.t('settings'));
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Consumer<AppData>(
        builder: (context, appData, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            children: [
              // Theme Section
              _buildSection(
                context,
                appData.t('theme'),
                _buildThemeCard(context, appData),
              ),
              const SizedBox(height: 16),

              // Language Section
              _buildSection(
                context,
                appData.t('language'),
                _buildLanguageCard(context, appData),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    Widget child,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildThemeCard(BuildContext context, AppData appData) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                isDarkMode ? const Color(0xFF252525) : Colors.white,
                isDarkMode ? const Color(0xFF1F1F1F) : const Color(0xFFFAFAFA),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          appData.t('darkMode'),
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                    Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        appData.setThemeBrightness(
                          value ? Brightness.dark : Brightness.light,
                        );
                      },
                      activeColor: AppColors.primary,
                      inactiveTrackColor:
                          Colors.grey.withOpacity(0.3),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  appData.t('themeDescription'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode
                            ? Colors.white70
                            : AppColors.textSecondary,
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, AppData appData) {
    final languages = appData.getAvailableLanguages();
    final currentLanguage = appData.currentLanguage;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                isDarkMode ? const Color(0xFF252525) : Colors.white,
                isDarkMode ? const Color(0xFF1F1F1F) : const Color(0xFFFAFAFA),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: currentLanguage,
              underline: const SizedBox(),
              icon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.language,
                  color: AppColors.primary,
                ),
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  appData.setLanguage(newValue);
                }
              },
              items: languages.map((String language) {
                final isSelected = language == currentLanguage;
                return DropdownMenuItem<String>(
                  value: language,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Text(
                          _getLanguageName(language),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.primary
                                    : null,
                              ),
                        ),
                        if (isSelected)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    const Map<String, String> languageNames = {
      'en': '🇺🇸 English',
      'ge': '🇬🇪 ქართული',
      'ger': '🇩🇪 Deutsch',
      'de': '🇩🇪 Deutsch',
    };
    return languageNames[languageCode] ?? languageCode.toUpperCase();
  }
}
