import 'package:shared_preferences/shared_preferences.dart';

/// 对 SharedPreferences 的一层薄封装，统一管理本地存储的 key。
/// 收藏 / 历史 / 主题 / 语言 全部只存在设备本地，不上传任何服务器。
class LocalStorageService {
  final SharedPreferences prefs;
  LocalStorageService(this.prefs);

  static const _kTheme = 'settings_theme_mode';
  static const _kLocale = 'settings_locale_code';
  static const _kFavorites = 'favorites_tool_ids';
  static const _kHistory = 'history_entries';
  static const _kOnboardingDone = 'onboarding_done';

  // 主题
  String? get themeMode => prefs.getString(_kTheme);
  Future<void> setThemeMode(String value) => prefs.setString(_kTheme, value);

  // 语言
  String? get localeCode => prefs.getString(_kLocale);
  Future<void> setLocaleCode(String value) => prefs.setString(_kLocale, value);

  // 收藏（工具 id 列表）
  List<String> get favorites => prefs.getStringList(_kFavorites) ?? [];
  Future<void> setFavorites(List<String> ids) => prefs.setStringList(_kFavorites, ids);

  // 历史（JSON 字符串数组，每条形如 "toolId|timestampMillis"）
  List<String> get historyRaw => prefs.getStringList(_kHistory) ?? [];
  Future<void> setHistoryRaw(List<String> entries) => prefs.setStringList(_kHistory, entries);

  // 新手引导是否已完成
  bool get onboardingDone => prefs.getBool(_kOnboardingDone) ?? false;
  Future<void> setOnboardingDone(bool value) => prefs.setBool(_kOnboardingDone, value);

  /// 清理缓存：目前仅清空历史记录，保留收藏与设置。
  Future<void> clearCache() async {
    await prefs.remove(_kHistory);
  }
}
