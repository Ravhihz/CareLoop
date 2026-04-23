import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter/foundation.dart';
import '../models/illness.dart';
import '../models/medicine.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class IllnessProvider with ChangeNotifier {
  List<Illness> _activeIllnesses = [];
  List<Illness> _inactiveIllnesses = [];
  Map<int, List<Medicine>> _medicinesMap = {};

  List<Illness> get activeIllnesses => _activeIllnesses;
  List<Illness> get inactiveIllnesses => _inactiveIllnesses;

  List<Medicine> getMedicines(int illnessId) {
    return _medicinesMap[illnessId] ?? [];
  }

  int getPendingCount() {
    int count = 0;
    _medicinesMap.forEach((_, medicines) {
      for (var m in medicines) {
        if (m.stock > 0) count++;
      }
    });
    return count;
  }

  Future<void> loadActiveIllnesses() async {
    _activeIllnesses = await DatabaseService.instance.getActiveIllnesses();
    for (var illness in _activeIllnesses) {
      await loadMedicines(illness.id!);
    }
    notifyListeners();
    await _updateBadge();
  }

  Future<void> loadInactiveIllnesses() async {
    _inactiveIllnesses = await DatabaseService.instance.getInactiveIllnesses();
    notifyListeners();
  }

  Future<void> loadMedicines(int illnessId) async {
    _medicinesMap[illnessId] = await DatabaseService.instance
        .getMedicinesByIllness(illnessId);
    notifyListeners();
  }

  Future<void> addIllness(Illness illness, List<Medicine> medicines) async {
    final saved = await DatabaseService.instance.createIllness(illness);
    for (var medicine in medicines) {
      final savedMedicine = await DatabaseService.instance.createMedicine(
        medicine.copyWith(illnessId: saved.id),
      );
      await NotificationService.instance.scheduleMedicineReminders(
        savedMedicine,
      );
    }
    await loadActiveIllnesses();
  }

  Future<void> updateIllness(Illness illness, List<Medicine> medicines) async {
    await DatabaseService.instance.updateIllness(illness);
    final existing = await DatabaseService.instance.getMedicinesByIllness(
      illness.id!,
    );
    for (var m in existing) {
      await DatabaseService.instance.deleteMedicine(m.id!);
      await NotificationService.instance.cancelMedicineReminders(m.id!);
    }
    for (var m in medicines) {
      final saved = await DatabaseService.instance.createMedicine(
        m.copyWith(illnessId: illness.id),
      );
      await NotificationService.instance.scheduleMedicineReminders(saved);
    }
    await loadActiveIllnesses();
  }

  Future<void> deleteIllness(int id) async {
    final medicines = await DatabaseService.instance.getMedicinesByIllness(id);
    for (var m in medicines) {
      await NotificationService.instance.cancelMedicineReminders(m.id!);
    }
    await DatabaseService.instance.deleteIllness(id);
    await loadActiveIllnesses();
  }

  Future<void> markAsCured(Illness illness) async {
    final medicines = _medicinesMap[illness.id] ?? [];
    for (var m in medicines) {
      await NotificationService.instance.cancelMedicineReminders(m.id!);
    }
    final updated = illness.copyWith(isActive: false);
    await DatabaseService.instance.updateIllness(updated);
    await loadActiveIllnesses();
    await loadInactiveIllnesses();
  }

  Future<void> decreaseStock(Medicine medicine) async {
    if (medicine.stock <= 0) return;
    final newStock = medicine.stock - 1;
    await DatabaseService.instance.updateStock(medicine.id!, newStock);
    await loadMedicines(medicine.illnessId);
    await _updateBadge();

    if (newStock == 0) {
      final medicines = _medicinesMap[medicine.illnessId] ?? [];
      final allEmpty = medicines.every((m) => m.stock == 0);
      if (allEmpty) {
        final illness = _activeIllnesses.firstWhere(
          (i) => i.id == medicine.illnessId,
        );
        await markAsCured(illness);
      }
    }
  }

  Future<void> _updateBadge() async {
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS)
      return;
    final count = _activeIllnesses
        .expand((i) => _medicinesMap[i.id] ?? [])
        .where((m) => m.stock > 0)
        .length;
    await AppBadgePlus.updateBadge(count);
  }
}
