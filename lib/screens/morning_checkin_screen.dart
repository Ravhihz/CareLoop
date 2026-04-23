import 'package:careloop/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/illness_provider.dart';
import '../models/medicine.dart';

class MorningCheckinScreen extends StatefulWidget {
  const MorningCheckinScreen({super.key});

  @override
  State<MorningCheckinScreen> createState() => _MorningCheckinScreenState();
}

class _MorningCheckinScreenState extends State<MorningCheckinScreen> {
  final Map<int, bool> _checkedMedicines = {};
  final List<String> _selectedSymptoms = [];
  String _feeling = 'okay';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IllnessProvider>();
    final illnesses = provider.activeIllnesses;
    final l10n = AppLocalizations.of(context)!;
    final symptoms = [
      l10n.fever,
      l10n.cough,
      l10n.runnyNose,
      l10n.headache,
      l10n.soreThroat,
      l10n.fatigue,
      l10n.nausea,
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildGreeting(l10n),
              const SizedBox(height: 28),
              _buildFeelingSection(l10n),
              const SizedBox(height: 24),
              _buildSymptomsSection(l10n, symptoms),
              const SizedBox(height: 24),
              if (illnesses.isNotEmpty)
                _buildMorningMedicines(illnesses, provider, l10n),
              const SizedBox(height: 32),
              _buildDoneButton(l10n),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = l10n.goodMorning;
    } else if (hour < 17) {
      greeting = l10n.goodAfternoon;
    } else {
      greeting = l10n.goodEvening;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.howAreYou,
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildFeelingSection(AppLocalizations l10n) {
    final options = [
      {'value': 'worse', 'label': l10n.worse, 'icon': '😞'},
      {'value': 'okay', 'label': l10n.okay, 'icon': '😐'},
      {'value': 'better', 'label': l10n.better, 'icon': '😊'},
      {'value': 'great', 'label': l10n.great, 'icon': '😄'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.overallCondition,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: options.map((opt) {
            final isSelected = _feeling == opt['value'];
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _feeling = opt['value']!),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.15)
                        : Theme.of(context).colorScheme.surfaceContainerHighest
                              .withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(opt['icon']!, style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: 4),
                      Text(
                        opt['label']!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSymptomsSection(AppLocalizations l10n, List<String> symptoms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.currentSymptoms,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.selectAllThatApply,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: symptoms.map((symptom) {
            final isSelected = _selectedSymptoms.contains(symptom);
            return GestureDetector(
              onTap: () => setState(() {
                isSelected
                    ? _selectedSymptoms.remove(symptom)
                    : _selectedSymptoms.add(symptom);
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                      : Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  symptom,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMorningMedicines(
    illnesses,
    IllnessProvider provider,
    AppLocalizations l10n,
  ) {
    final morningMedicines = <Map<String, dynamic>>[];

    for (var illness in illnesses) {
      final medicines = provider.getMedicines(illness.id!);
      for (var medicine in medicines) {
        if (medicine.stock > 0 && medicine.times.isNotEmpty) {
          if (medicine.times.first == '07:00') {
            morningMedicines.add({'illness': illness, 'medicine': medicine});
          }
        }
      }
    }

    if (morningMedicines.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.morningMedicines,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.markAsTaken,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 12),
        ...morningMedicines.map((item) {
          final medicine = item['medicine'] as Medicine;
          final isChecked = _checkedMedicines[medicine.id] ?? false;
          return GestureDetector(
            onTap: () =>
                setState(() => _checkedMedicines[medicine.id!] = !isChecked),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isChecked
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isChecked
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
                      : Theme.of(context).colorScheme.outline.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isChecked ? Icons.check_circle : Icons.circle_outlined,
                    color: isChecked
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            decoration: isChecked
                                ? TextDecoration.lineThrough
                                : null,
                            color: isChecked
                                ? Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.4)
                                : null,
                          ),
                        ),
                        Text(
                          l10n.tabletsLeft(medicine.stock),
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
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDoneButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _done,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(l10n.doneForToday, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Future<void> _done() async {
    final provider = context.read<IllnessProvider>();
    for (var entry in _checkedMedicines.entries) {
      if (entry.value) {
        final allMedicines = provider.activeIllnesses
            .expand((i) => provider.getMedicines(i.id!))
            .toList();
        final medicine = allMedicines.firstWhere((m) => m.id == entry.key);
        await provider.decreaseStock(medicine);
      }
    }
    if (mounted) Navigator.pop(context);
  }
}
