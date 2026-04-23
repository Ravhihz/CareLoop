import 'package:careloop/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/illness_provider.dart';
import '../models/illness.dart';
import '../models/medicine.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IllnessProvider>().loadInactiveIllnesses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IllnessProvider>();
    final illnesses = provider.inactiveIllnesses;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.history,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: illnesses.isEmpty ? _buildEmpty() : _buildList(illnesses, provider),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noHistoryYet,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.completedConditions,
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: illnesses.length,
      itemBuilder: (context, index) {
        final illness = illnesses[index];
        return _HistoryCard(illness: illness, provider: provider);
      },
    );
  }
}

class _HistoryCard extends StatefulWidget {
  final Illness illness;
  final IllnessProvider provider;

  const _HistoryCard({required this.illness, required this.provider});

  @override
  State<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard> {
  bool _expanded = false;
  List<Medicine> _medicines = [];

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    await widget.provider.loadMedicines(widget.illness.id!);
    setState(() {
      _medicines = widget.provider.getMedicines(widget.illness.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final createdAt = widget.illness.createdAt;
    final formattedDate =
        '${createdAt.day}/${createdAt.month}/${createdAt.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.illness.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.started} $formattedDate · ${_medicines.length} medicine${_medicines.length != 1 ? 's' : ''}',
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
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.4),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded && _medicines.isNotEmpty) ...[
            const Divider(height: 1),
            ..._medicines.map(
              (medicine) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.medication_outlined,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        medicine.name,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Text(
                      '${medicine.frequency}x ${AppLocalizations.of(context)!.daily}',
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
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
