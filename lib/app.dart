import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/providers/settings_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class NaiLongApp extends ConsumerWidget {
  const NaiLongApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final localeCode = ref.watch(localeCodeProvider);

    // 应用内自定义字典使用的 code 和 Flutter 官方 Locale 略有差异（zh_Hant vs zh-Hant）
    final locale = localeCode == 'zh_Hant' ? const Locale('zh', 'Hant') : Locale(localeCode);

    return MaterialApp.router(
      title: '奶龙工具箱',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: locale,
      supportedLocales: const [Locale('zh'), Locale('zh', 'Hant'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
    );
  }
}
