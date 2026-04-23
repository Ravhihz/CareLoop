import 'package:careloop/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/illness_provider.dart';
import '../models/illness.dart';
import '../models/medicine.dart';
import 'add_illness_screen.dart';
import 'history_screen.dart';
import 'morning_checkin_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IllnessProvider>().loadActiveIllnesses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IllnessProvider>();
    final illnesses = provider.activeIllnesses;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CareLoop',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.activeConditions,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
        actions: [
          if (provider.getPendingCount() > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Badge(
                label: Text('${provider.getPendingCount()}'),
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MorningCheckinScreen(),
                    ),
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MorningCheckinScreen()),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.history_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: illnesses.isEmpty ? _buildEmpty() : _buildList(illnesses, provider),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, scrollController) => const AddIllnessScreen(),
          ),
        ),
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.addCondition),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.health_and_safety_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noActiveConditions,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.tapToAdd,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Illness> illnesses, IllnessProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: illnesses.length,
      itemBuilder: (context, index) {
        final illness = illnesses[index];
        final medicines = provider.getMedicines(illness.id!);
        return _IllnessCard(
          illness: illness,
          medicines: medicines,
          provider: provider,
        );
      },
    );
  }
}

class _IllnessCard extends StatelessWidget {
  final Illness illness;
  final List<Medicine> medicines;
  final IllnessProvider provider;

  const _IllnessCard({
    required this.illness,
    required this.medicines,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final daysActive = DateTime.now().difference(illness.createdAt).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.sick_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        illness.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        daysActive == 0
                            ? AppLocalizations.of(context)!.startedToday
                            : '${AppLocalizations.of(context)!.day} $daysActive',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'cured',
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, size: 18),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.markAsCured),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.delete,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) async {
                    if (value == 'edit') {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => DraggableScrollableSheet(
                          initialChildSize: 0.85,
                          minChildSize: 0.5,
                          maxChildSize: 0.95,
                          builder: (_, __) =>
                              AddIllnessScreen(illness: illness),
                        ),
                      );
                    } else if (value == 'cured') {
                      await provider.markAsCured(illness);
                    } else if (value == 'delete') {
                      await provider.deleteIllness(illness.id!);
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...medicines.map(
            (medicine) => _MedicineRow(medicine: medicine, provider: provider),
          ),
          if (medicines.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context)!.noMedicinesAdded,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MedicineRow extends StatelessWidget {
  final Medicine medicine;
  final IllnessProvider provider;

  const _MedicineRow({required this.medicine, required this.provider});

  @override
  Widget build(BuildContext context) {
    final isLow = medicine.stock <= 2 && medicine.stock > 0;
    final isEmpty = medicine.stock == 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          Icon(
            Icons.medication_outlined,
            size: 18,
            color: isEmpty
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3)
                : Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: isEmpty ? TextDecoration.lineThrough : null,
                    color: isEmpty
                        ? Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3)
                        : null,
                  ),
                ),
                Text(
                  '${medicine.frequency}x ${AppLocalizations.of(context)!.daily} · ${medicine.times.join(', ')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isEmpty
                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.08)
                  : isLow
                  ? Colors.orange.withOpacity(0.15)
                  : Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isEmpty
                  ? AppLocalizations.of(context)!.empty
                  : '${medicine.stock} ${AppLocalizations.of(context)!.left}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isEmpty
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3)
                    : isLow
                    ? Colors.orange
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isEmpty ? null : () => provider.decreaseStock(medicine),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isEmpty
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.05)
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.check,
                size: 16,
                color: isEmpty
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.2)
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
