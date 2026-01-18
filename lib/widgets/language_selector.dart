import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data.dart';
import '../utils/colors.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, appData, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            height: 32,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                _buildSegmentButton(
                  context,
                  appData,
                  'EN',
                  'en',
                  isFirst: true,
                  isLast: false,
                ),
                _buildSegmentButton(
                  context,
                  appData,
                  'GE',
                  'ge',
                  isFirst: false,
                  isLast: false,
                ),
                _buildSegmentButton(
                  context,
                  appData,
                  'GER',
                  'ger',
                  isFirst: false,
                  isLast: true,
                ),
              ],
            ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSegmentButton(
    BuildContext context,
    AppData appData,
    String label,
    String languageCode, {
    required bool isFirst,
    required bool isLast,
  }) {
    final isSelected = appData.currentLanguage == languageCode;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          appData.setLanguage(languageCode);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isFirst ? 6 : 0),
              bottomLeft: Radius.circular(isFirst ? 6 : 0),
              topRight: Radius.circular(isLast ? 6 : 0),
              bottomRight: Radius.circular(isLast ? 6 : 0),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
