import 'package:careloop/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/illness_provider.dart';
import '../models/illness.dart';
import '../models/medicine.dart';

class AddIllnessScreen extends StatefulWidget {
  final Illness? illness;

  const AddIllnessScreen({super.key, this.illness});

  @override
  State<AddIllnessScreen> createState() => _AddIllnessScreenState();
}

class _AddIllnessScreenState extends State<AddIllnessScreen> {
  final _illnessController = TextEditingController();
  final List<_MedicineFormData> _forms = [];
  bool get isEdit => widget.illness != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _illnessController.text = widget.illness!.name;
      final medicines = context.read<IllnessProvider>().getMedicines(
        widget.illness!.id!,
      );
      for (var m in medicines) {
        _forms.add(_MedicineFormData.fromMedicine(m));
      }
    } else {
      _forms.add(_MedicineFormData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEdit
                      ? AppLocalizations.of(context)!.editCondition
                      : AppLocalizations.of(context)!.addCondition,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _save,
                  child: Text(
                    AppLocalizations.of(context)!.save,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _illnessController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.conditionName,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.sick_outlined),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.medicines,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () =>
                              setState(() => _forms.add(_MedicineFormData())),
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(AppLocalizations.of(context)!.addMore),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._forms.asMap().entries.map((entry) {
                      return _MedicineFormWidget(
                        key: ValueKey(entry.key),
                        data: entry.value,
                        index: entry.key,
                        onRemove: _forms.length > 1
                            ? () => setState(() => _forms.removeAt(entry.key))
                            : null,
                        onFrequencyChanged: () => setState(() {}),
                      );
                    }),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isEdit
                              ? AppLocalizations.of(context)!.updateCondition
                              : AppLocalizations.of(context)!.saveCondition,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_illnessController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a condition name')),
      );
      return;
    }

    final validForms = _forms
        .where((f) => f.nameController.text.trim().isNotEmpty)
        .toList();
    if (validForms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one medicine')),
      );
      return;
    }

    final provider = context.read<IllnessProvider>();

    if (isEdit) {
      final updated = widget.illness!.copyWith(
        name: _illnessController.text.trim(),
      );
      await provider.updateIllness(
        updated,
        validForms.map((f) => f.toMedicine(widget.illness!.id!)).toList(),
      );
    } else {
      final illness = Illness(
        name: _illnessController.text.trim(),
        createdAt: DateTime.now(),
      );
      final medicines = validForms.map((f) => f.toMedicine(0)).toList();
      await provider.addIllness(illness, medicines);
    }

    if (mounted) Navigator.pop(context);
  }
}

class _MedicineFormData {
  final TextEditingController nameController;
  final TextEditingController stockController;
  int frequency;
  List<TimeOfDay> times;
  int? existingId;

  _MedicineFormData()
    : nameController = TextEditingController(),
      stockController = TextEditingController(),
      frequency = 1,
      times = [const TimeOfDay(hour: 7, minute: 0)];

  factory _MedicineFormData.fromMedicine(Medicine m) {
    final parsedTimes = m.times.map((t) {
      final parts = t.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }).toList();

    return _MedicineFormData()
      ..nameController.text = m.name
      ..stockController.text = m.stock.toString()
      ..frequency = m.frequency
      ..times = parsedTimes
      ..existingId = m.id;
  }

  void updateFrequency(int newFreq) {
    frequency = newFreq;
    switch (newFreq) {
      case 1:
        times = [const TimeOfDay(hour: 7, minute: 0)];
        break;
      case 2:
        times = [
          const TimeOfDay(hour: 7, minute: 0),
          const TimeOfDay(hour: 19, minute: 0),
        ];
        break;
      case 3:
        times = [
          const TimeOfDay(hour: 7, minute: 0),
          const TimeOfDay(hour: 13, minute: 0),
          const TimeOfDay(hour: 19, minute: 0),
        ];
        break;
      default:
        times = List.generate(
          newFreq,
          (_) => const TimeOfDay(hour: 7, minute: 0),
        );
    }
  }

  Medicine toMedicine(int illnessId) {
    return Medicine(
      id: existingId,
      illnessId: illnessId,
      name: nameController.text.trim(),
      stock: int.tryParse(stockController.text) ?? 0,
      frequency: frequency,
      times: times
          .map(
            (t) =>
                '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
          )
          .toList(),
    );
  }
}

class _MedicineFormWidget extends StatefulWidget {
  final _MedicineFormData data;
  final int index;
  final VoidCallback? onRemove;
  final VoidCallback onFrequencyChanged;

  const _MedicineFormWidget({
    super.key,
    required this.data,
    required this.index,
    this.onRemove,
    required this.onFrequencyChanged,
  });

  @override
  State<_MedicineFormWidget> createState() => _MedicineFormWidgetState();
}

class _MedicineFormWidgetState extends State<_MedicineFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Medicine ${widget.index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              if (widget.onRemove != null)
                GestureDetector(
                  onTap: widget.onRemove,
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: widget.data.nameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.medicineName,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.data.stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.stockTablets,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: widget.data.frequency,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.frequencyDay,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    isDense: true,
                  ),
                  items: [1, 2, 3, 4]
                      .map(
                        (f) => DropdownMenuItem(
                          value: f,
                          child: Text('${f}x / day'),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => widget.data.updateFrequency(val));
                      widget.onFrequencyChanged();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.reminderTimes,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: widget.data.times.asMap().entries.map((entry) {
              final i = entry.key;
              final time = entry.value;
              return GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: time,
                  );
                  if (picked != null) {
                    setState(() => widget.data.times[i] = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
