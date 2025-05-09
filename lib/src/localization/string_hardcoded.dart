import 'package:flutter/material.dart';
import 'app_localizations.dart';

/// A simple placeholder that can be used to search all the hardcoded strings
/// in the code (useful to identify strings that need to be localized).
/// Extension to simplify localization in the codebase
/// Provides backward compatibility with existing 'hardcoded' pattern
/// while adding support for proper localization
extension StringHardcoded on String {
  // Original hardcoded method for compatibility
  String get hardcoded => this;
  
  // New method to get localized string
  String tr(BuildContext context) {
    final translated = AppLocalizations.getTranslation(context, this);
    return translated ?? this; // Fallback to the key if translation not found
  }
}
