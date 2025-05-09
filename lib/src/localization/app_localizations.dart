import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings = {};
  
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('vi', ''), // Vietnamese
  ];
  
  // Helper method to keep the code in the widgets concise
  static String? getTranslation(BuildContext context, String key) {
    return AppLocalizations.of(context).translate(key);
  }
  
  // Static method to get the user's saved locale from SharedPreferences
  static Future<Locale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    return languageCode != null 
        ? Locale(languageCode, '') 
        : const Locale('en', ''); // Default to English
  }
  
  // Static method to save the user's locale choice to SharedPreferences
  static Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }
  
  Future<bool> load() async {
    // Load the language JSON file from the "assets/lang" folder
    String jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    
    return true;
  }
  
  // This method will be called from every widget that needs localized text
  String? translate(String key) {
    return _localizedStrings[key];
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    // Include all supported language codes here
    return ['en', 'vi'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually occurs
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }
  
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
} 