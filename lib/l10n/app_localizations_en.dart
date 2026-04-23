// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CareLoop';

  @override
  String get activeConditions => 'Active Conditions';

  @override
  String get noActiveConditions => 'No active conditions';

  @override
  String get tapToAdd => 'Tap + to add a condition and medicines';

  @override
  String get addCondition => 'Add Condition';

  @override
  String get editCondition => 'Edit Condition';

  @override
  String get conditionName => 'Condition name (e.g. Flu, Fever)';

  @override
  String get medicines => 'Medicines';

  @override
  String get addMore => 'Add More';

  @override
  String get medicineName => 'Medicine name';

  @override
  String get stockTablets => 'Stock (tablets)';

  @override
  String get frequencyDay => 'Frequency/day';

  @override
  String get reminderTimes => 'Reminder times';

  @override
  String get save => 'Save';

  @override
  String get saveCondition => 'Save Condition';

  @override
  String get updateCondition => 'Update Condition';

  @override
  String get edit => 'Edit';

  @override
  String get markAsCured => 'Mark as Cured';

  @override
  String get delete => 'Delete';

  @override
  String get startedToday => 'Started today';

  @override
  String get day => 'Day';

  @override
  String get noMedicinesAdded => 'No medicines added';

  @override
  String get left => 'left';

  @override
  String get empty => 'Empty';

  @override
  String get history => 'History';

  @override
  String get noHistoryYet => 'No history yet';

  @override
  String get completedConditions => 'Completed conditions will appear here';

  @override
  String get started => 'Started';

  @override
  String get daily => 'daily';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get notificationStyle => 'Notification Style';

  @override
  String get reminderSound => 'Reminder Sound';

  @override
  String get vibration => 'Vibration';

  @override
  String get vibrateOnReminder => 'Vibrate on reminder';

  @override
  String get statusBar => 'Status Bar';

  @override
  String get popup => 'Pop-up';

  @override
  String get fullScreen => 'Full Screen';

  @override
  String get gentle => 'Gentle';

  @override
  String get chime => 'Chime';

  @override
  String get silent => 'Silent';

  @override
  String get goodMorning => 'Good Morning!';

  @override
  String get goodAfternoon => 'Good Afternoon!';

  @override
  String get goodEvening => 'Good Evening!';

  @override
  String get howAreYou => 'How are you feeling today?';

  @override
  String get overallCondition => 'Overall condition';

  @override
  String get currentSymptoms => 'Current symptoms';

  @override
  String get selectAllThatApply => 'Select all that apply';

  @override
  String get morningMedicines => 'Morning medicines';

  @override
  String get markAsTaken => 'Mark as taken';

  @override
  String get doneForToday => 'Done for today';

  @override
  String get worse => 'Worse';

  @override
  String get okay => 'Okay';

  @override
  String get better => 'Better';

  @override
  String get great => 'Great';

  @override
  String get fever => 'Fever';

  @override
  String get cough => 'Cough';

  @override
  String get runnyNose => 'Runny Nose';

  @override
  String get headache => 'Headache';

  @override
  String get soreThroat => 'Sore Throat';

  @override
  String get fatigue => 'Fatigue';

  @override
  String get nausea => 'Nausea';

  @override
  String tabletsLeft(int count) {
    return '$count tablets left';
  }
}
