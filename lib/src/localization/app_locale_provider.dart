import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_localizations.dart';

// State notifier for locale changes
class AppLocaleNotifier extends StateNotifier<Locale> {
  AppLocaleNotifier() : super(const Locale('en', ''));
  
  // Initialize with the saved locale
  Future<void> init() async {
    final savedLocale = await AppLocalizations.getSavedLocale();
    state = savedLocale;
  }
  
  // Change language and save to preferences
  Future<void> changeLocale(String languageCode) async {
    await AppLocalizations.setLocale(languageCode);
    state = Locale(languageCode, '');
  }
  
  bool isCurrentLocale(String languageCode) {
    return state.languageCode == languageCode;
  }
}

// Provider for the current locale
final appLocaleProvider = StateNotifierProvider<AppLocaleNotifier, Locale>((ref) {
  final notifier = AppLocaleNotifier();
  // Initialize the notifier with the saved locale
  notifier.init();
  return notifier;
});

// Provider for checking if a specific language is currently selected
final isLanguageSelectedProvider = Provider.family<bool, String>((ref, languageCode) {
  final currentLocale = ref.watch(appLocaleProvider);
  return currentLocale.languageCode == languageCode;
}); 