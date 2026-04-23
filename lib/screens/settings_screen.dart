import 'package:careloop/l10n.dart';
import 'package:careloop/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = 'en';
  String _notifStyle = 'heads_up';
  String _notifSound = 'gentle';
  bool _vibrate = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = prefs.getString('language') ?? 'en';
      _notifStyle = prefs.getString('notif_style') ?? 'heads_up';
      _notifSound = prefs.getString('notif_sound') ?? 'gentle';
      _vibrate = prefs.getBool('vibrate') ?? true;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) await prefs.setString(key, value);
    if (value is bool) await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionLabel(AppLocalizations.of(context)!.language),
          _buildLanguageSelector(),
          const SizedBox(height: 24),
          _buildSectionLabel(AppLocalizations.of(context)!.notificationStyle),
          _buildNotifStyleSelector(),
          const SizedBox(height: 24),
          _buildSectionLabel(AppLocalizations.of(context)!.reminderSound),
          _buildSoundSelector(),
          const SizedBox(height: 24),
          _buildSectionLabel(AppLocalizations.of(context)!.vibration),
          _buildVibrateToggle(),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final options = <Map<String, String>>[
      {'value': 'en', 'label': 'English', 'flag': '🇺🇸'},
      {'value': 'id', 'label': 'Indonesia', 'flag': '🇮🇩'},
    ];

    return Row(
      children: options.map((opt) {
        final isSelected = _language == opt['value'];
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => _language = opt['value']!);
              _saveSetting('language', opt['value']!);
              context.read<AppLocale>().setLocale(Locale(opt['value']!));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                    : Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                ),
              ),
              child: Column(
                children: [
                  Text(opt['flag']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 6),
                  Text(
                    opt['label']!,
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
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotifStyleSelector() {
    final values = ['status_bar', 'heads_up', 'full_screen'];
    final l10n = AppLocalizations.of(context)!;
    final labels = [l10n.statusBar, l10n.popup, l10n.fullScreen];
    final icons = [
      Icons.notifications_outlined,
      Icons.notification_important_outlined,
      Icons.fullscreen_outlined,
    ];

    return Column(
      children: List.generate(values.length, (i) {
        final isSelected = _notifStyle == values[i];
        return GestureDetector(
          onTap: () {
            setState(() => _notifStyle = values[i]);
            _saveSetting('notif_style', values[i]);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icons[i],
                  size: 20,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 12),
                Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSoundSelector() {
    final values = ['gentle', 'chime', 'silent'];
    final l10n = AppLocalizations.of(context)!;
    final labels = [l10n.gentle, l10n.chime, l10n.silent];
    final icons = [
      Icons.volume_down_outlined,
      Icons.music_note_outlined,
      Icons.volume_off_outlined,
    ];

    return Column(
      children: List.generate(values.length, (i) {
        final isSelected = _notifSound == values[i];
        return GestureDetector(
          onTap: () {
            setState(() => _notifSound = values[i]);
            _saveSetting('notif_sound', values[i]);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icons[i],
                  size: 20,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 12),
                Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVibrateToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          AppLocalizations.of(context)!.vibrateOnReminder,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        secondary: Icon(
          Icons.vibration_outlined,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        value: _vibrate,
        activeColor: Theme.of(context).colorScheme.primary,
        onChanged: (val) {
          setState(() => _vibrate = val);
          _saveSetting('vibrate', val);
        },
      ),
    );
  }
}
