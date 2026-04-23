import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CareLoop'**
  String get appTitle;

  /// No description provided for @activeConditions.
  ///
  /// In en, this message translates to:
  /// **'Active Conditions'**
  String get activeConditions;

  /// No description provided for @noActiveConditions.
  ///
  /// In en, this message translates to:
  /// **'No active conditions'**
  String get noActiveConditions;

  /// No description provided for @tapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a condition and medicines'**
  String get tapToAdd;

  /// No description provided for @addCondition.
  ///
  /// In en, this message translates to:
  /// **'Add Condition'**
  String get addCondition;

  /// No description provided for @editCondition.
  ///
  /// In en, this message translates to:
  /// **'Edit Condition'**
  String get editCondition;

  /// No description provided for @conditionName.
  ///
  /// In en, this message translates to:
  /// **'Condition name (e.g. Flu, Fever)'**
  String get conditionName;

  /// No description provided for @medicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicines;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'Add More'**
  String get addMore;

  /// No description provided for @medicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine name'**
  String get medicineName;

  /// No description provided for @stockTablets.
  ///
  /// In en, this message translates to:
  /// **'Stock (tablets)'**
  String get stockTablets;

  /// No description provided for @frequencyDay.
  ///
  /// In en, this message translates to:
  /// **'Frequency/day'**
  String get frequencyDay;

  /// No description provided for @reminderTimes.
  ///
  /// In en, this message translates to:
  /// **'Reminder times'**
  String get reminderTimes;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveCondition.
  ///
  /// In en, this message translates to:
  /// **'Save Condition'**
  String get saveCondition;

  /// No description provided for @updateCondition.
  ///
  /// In en, this message translates to:
  /// **'Update Condition'**
  String get updateCondition;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @markAsCured.
  ///
  /// In en, this message translates to:
  /// **'Mark as Cured'**
  String get markAsCured;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @startedToday.
  ///
  /// In en, this message translates to:
  /// **'Started today'**
  String get startedToday;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @noMedicinesAdded.
  ///
  /// In en, this message translates to:
  /// **'No medicines added'**
  String get noMedicinesAdded;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get left;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @completedConditions.
  ///
  /// In en, this message translates to:
  /// **'Completed conditions will appear here'**
  String get completedConditions;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get started;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'daily'**
  String get daily;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notificationStyle.
  ///
  /// In en, this message translates to:
  /// **'Notification Style'**
  String get notificationStyle;

  /// No description provided for @reminderSound.
  ///
  /// In en, this message translates to:
  /// **'Reminder Sound'**
  String get reminderSound;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @vibrateOnReminder.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on reminder'**
  String get vibrateOnReminder;

  /// No description provided for @statusBar.
  ///
  /// In en, this message translates to:
  /// **'Status Bar'**
  String get statusBar;

  /// No description provided for @popup.
  ///
  /// In en, this message translates to:
  /// **'Pop-up'**
  String get popup;

  /// No description provided for @fullScreen.
  ///
  /// In en, this message translates to:
  /// **'Full Screen'**
  String get fullScreen;

  /// No description provided for @gentle.
  ///
  /// In en, this message translates to:
  /// **'Gentle'**
  String get gentle;

  /// No description provided for @chime.
  ///
  /// In en, this message translates to:
  /// **'Chime'**
  String get chime;

  /// No description provided for @silent.
  ///
  /// In en, this message translates to:
  /// **'Silent'**
  String get silent;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning!'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon!'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening!'**
  String get goodEvening;

  /// No description provided for @howAreYou.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get howAreYou;

  /// No description provided for @overallCondition.
  ///
  /// In en, this message translates to:
  /// **'Overall condition'**
  String get overallCondition;

  /// No description provided for @currentSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Current symptoms'**
  String get currentSymptoms;

  /// No description provided for @selectAllThatApply.
  ///
  /// In en, this message translates to:
  /// **'Select all that apply'**
  String get selectAllThatApply;

  /// No description provided for @morningMedicines.
  ///
  /// In en, this message translates to:
  /// **'Morning medicines'**
  String get morningMedicines;

  /// No description provided for @markAsTaken.
  ///
  /// In en, this message translates to:
  /// **'Mark as taken'**
  String get markAsTaken;

  /// No description provided for @doneForToday.
  ///
  /// In en, this message translates to:
  /// **'Done for today'**
  String get doneForToday;

  /// No description provided for @worse.
  ///
  /// In en, this message translates to:
  /// **'Worse'**
  String get worse;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @better.
  ///
  /// In en, this message translates to:
  /// **'Better'**
  String get better;

  /// No description provided for @great.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get great;

  /// No description provided for @fever.
  ///
  /// In en, this message translates to:
  /// **'Fever'**
  String get fever;

  /// No description provided for @cough.
  ///
  /// In en, this message translates to:
  /// **'Cough'**
  String get cough;

  /// No description provided for @runnyNose.
  ///
  /// In en, this message translates to:
  /// **'Runny Nose'**
  String get runnyNose;

  /// No description provided for @headache.
  ///
  /// In en, this message translates to:
  /// **'Headache'**
  String get headache;

  /// No description provided for @soreThroat.
  ///
  /// In en, this message translates to:
  /// **'Sore Throat'**
  String get soreThroat;

  /// No description provided for @fatigue.
  ///
  /// In en, this message translates to:
  /// **'Fatigue'**
  String get fatigue;

  /// No description provided for @nausea.
  ///
  /// In en, this message translates to:
  /// **'Nausea'**
  String get nausea;

  /// No description provided for @tabletsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} tablets left'**
  String tabletsLeft(int count);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'id': return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
