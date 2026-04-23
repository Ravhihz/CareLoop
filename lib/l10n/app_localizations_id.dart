// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'CareLoop';

  @override
  String get activeConditions => 'Kondisi Aktif';

  @override
  String get noActiveConditions => 'Tidak ada kondisi aktif';

  @override
  String get tapToAdd => 'Ketuk + untuk menambah kondisi dan obat';

  @override
  String get addCondition => 'Tambah Kondisi';

  @override
  String get editCondition => 'Edit Kondisi';

  @override
  String get conditionName => 'Nama kondisi (mis. Flu, Demam)';

  @override
  String get medicines => 'Obat-obatan';

  @override
  String get addMore => 'Tambah Lagi';

  @override
  String get medicineName => 'Nama obat';

  @override
  String get stockTablets => 'Stok (tablet)';

  @override
  String get frequencyDay => 'Frekuensi/hari';

  @override
  String get reminderTimes => 'Waktu pengingat';

  @override
  String get save => 'Simpan';

  @override
  String get saveCondition => 'Simpan Kondisi';

  @override
  String get updateCondition => 'Perbarui Kondisi';

  @override
  String get edit => 'Edit';

  @override
  String get markAsCured => 'Tandai Sembuh';

  @override
  String get delete => 'Hapus';

  @override
  String get startedToday => 'Mulai hari ini';

  @override
  String get day => 'Hari';

  @override
  String get noMedicinesAdded => 'Belum ada obat';

  @override
  String get left => 'tersisa';

  @override
  String get empty => 'Habis';

  @override
  String get history => 'Riwayat';

  @override
  String get noHistoryYet => 'Belum ada riwayat';

  @override
  String get completedConditions => 'Kondisi yang selesai akan muncul di sini';

  @override
  String get started => 'Mulai';

  @override
  String get daily => 'sehari';

  @override
  String get settings => 'Pengaturan';

  @override
  String get language => 'Bahasa';

  @override
  String get notificationStyle => 'Gaya Notifikasi';

  @override
  String get reminderSound => 'Suara Pengingat';

  @override
  String get vibration => 'Getar';

  @override
  String get vibrateOnReminder => 'Getar saat pengingat';

  @override
  String get statusBar => 'Status Bar';

  @override
  String get popup => 'Pop-up';

  @override
  String get fullScreen => 'Layar Penuh';

  @override
  String get gentle => 'Lembut';

  @override
  String get chime => 'Lonceng';

  @override
  String get silent => 'Senyap';

  @override
  String get goodMorning => 'Selamat Pagi!';

  @override
  String get goodAfternoon => 'Selamat Siang!';

  @override
  String get goodEvening => 'Selamat Malam!';

  @override
  String get howAreYou => 'Bagaimana kondisimu hari ini?';

  @override
  String get overallCondition => 'Kondisi keseluruhan';

  @override
  String get currentSymptoms => 'Gejala saat ini';

  @override
  String get selectAllThatApply => 'Pilih semua yang sesuai';

  @override
  String get morningMedicines => 'Obat pagi';

  @override
  String get markAsTaken => 'Tandai sudah diminum';

  @override
  String get doneForToday => 'Selesai untuk hari ini';

  @override
  String get worse => 'Memburuk';

  @override
  String get okay => 'Biasa';

  @override
  String get better => 'Membaik';

  @override
  String get great => 'Sangat Baik';

  @override
  String get fever => 'Demam';

  @override
  String get cough => 'Batuk';

  @override
  String get runnyNose => 'Pilek';

  @override
  String get headache => 'Sakit Kepala';

  @override
  String get soreThroat => 'Sakit Tenggorokan';

  @override
  String get fatigue => 'Kelelahan';

  @override
  String get nausea => 'Mual';

  @override
  String tabletsLeft(int count) {
    return '$count tablet tersisa';
  }
}
