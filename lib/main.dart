import 'package:careloop/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'providers/illness_provider.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';
import 'l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await NotificationService.instance.init().timeout(
    const Duration(seconds: 3),
    onTimeout: () {},
  );
  await NotificationService.instance.scheduleMorningCheckin().timeout(
    const Duration(seconds: 3),
    onTimeout: () {},
  );

  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString('language') ?? 'en';

  runApp(CareLoopApp(initialLocale: Locale(langCode)));
}

class CareLoopApp extends StatelessWidget {
  final Locale initialLocale;
  const CareLoopApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IllnessProvider()),
        ChangeNotifierProvider(
          create: (_) => AppLocale()..setLocale(initialLocale),
        ),
      ],
      child: Consumer<AppLocale>(
        builder: (context, appLocale, _) {
          return MaterialApp(
            title: 'CareLoop',
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            locale: appLocale.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('id')],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF4CAF93),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF4CAF93),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: ThemeMode.system,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
