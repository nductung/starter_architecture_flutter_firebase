import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/localization/app_locale_provider.dart';
import 'package:starter_architecture_flutter_firebase/src/localization/string_hardcoded.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'language'.tr(context),
                        style: theme.textTheme.headlineMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Language selection container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'select_language'.tr(context),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // English option
                          _buildLanguageOption(
                            context,
                            ref,
                            languageCode: 'en',
                            languageName: 'English',
                            countryCode: 'US',
                            isSelected: ref.watch(isLanguageSelectedProvider('en')),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Vietnamese option
                          _buildLanguageOption(
                            context,
                            ref,
                            languageCode: 'vi',
                            languageName: 'Tiếng Việt',
                            countryCode: 'VN',
                            isSelected: ref.watch(isLanguageSelectedProvider('vi')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref, {
    required String languageCode,
    required String languageName,
    required String countryCode,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () {
        // Change app locale
        ref.read(appLocaleProvider.notifier).changeLocale(languageCode);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.primaryColor : theme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Country flag (simplified with circle for now)
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                countryCode,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Language name
            Expanded(
              child: Text(
                languageName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            
            // Selected indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
} 