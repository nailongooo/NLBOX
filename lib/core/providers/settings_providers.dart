import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../storage/local_storage_service.dart';
import '../l10n/app_translations.dart';

/// SharedPreferences 实例（在 main.dart 中通过 overrideWithValue 注入）
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider 必须在 main.dart 中被覆盖');
});

final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService(ref.watch(sharedPreferencesProvider));
});

/// 主题模式：light / dark / system
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final LocalStorageService storage;
  ThemeModeNotifier(this.storage) : super(_fromString(storage.themeMode));

  static ThemeMode _fromString(String? v) {
    switch (v) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void setMode(ThemeMode mode) {
    state = mode;
    storage.setThemeMode(mode.name);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref.watch(localStorageProvider));
});

/// 语言：zh / zh_Hant / en
class LocaleNotifier extends StateNotifier<String> {
  final LocalStorageService storage;
  LocaleNotifier(this.storage) : super(storage.localeCode ?? _guessDefault());

  static String _guessDefault() {
    // 简单默认：跟随系统语言优先中文，其余英文。找不到就用简体中文。
    return 'zh';
  }

  void setLocale(String code) {
    state = code;
    storage.setLocaleCode(code);
  }
}

final localeCodeProvider = StateNotifierProvider<LocaleNotifier, String>((ref) {
  return LocaleNotifier(ref.watch(localStorageProvider));
});

/// 方便在 Widget 里翻译文案：ref.tr('key')
extension TrX on WidgetRef {
  String tr(String key) => AppText.t(watch(localeCodeProvider), key);
}
