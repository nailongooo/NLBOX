import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_translations.dart';
import '../../core/providers/settings_providers.dart';
import '../../core/storage/local_storage_service.dart';
import 'about_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeCodeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(ref.tr('nav_settings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(context, ref.tr('settings_appearance')),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(ref.tr('settings_theme')),
                  trailing: SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment(value: ThemeMode.light, label: Text(ref.tr('settings_theme_light'))),
                      ButtonSegment(value: ThemeMode.dark, label: Text(ref.tr('settings_theme_dark'))),
                      ButtonSegment(value: ThemeMode.system, label: Text(ref.tr('settings_theme_system'))),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (s) => ref.read(themeModeProvider.notifier).setMode(s.first),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(ref.tr('settings_language')),
                  trailing: DropdownButton<String>(
                    value: locale,
                    underline: const SizedBox(),
                    items: AppText.supportedCodes.map((c) => DropdownMenuItem(value: c, child: Text(AppText.labelForCode(c)))).toList(),
                    onChanged: (v) {
                      if (v != null) ref.read(localeCodeProvider.notifier).setLocale(v);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle(context, ref.tr('settings_general')),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cleaning_services_outlined),
                  title: Text(ref.tr('settings_clear_cache')),
                  onTap: () async {
                    await ref.read(localStorageProvider).clearCache();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ref.tr('settings_clear_cache_done'))));
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: Text(ref.tr('settings_help')),
                  onTap: () => _showHelp(context, ref),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.replay),
                  title: Text(ref.tr('settings_onboarding_replay')),
                  onTap: () async {
                    await ref.read(localStorageProvider).setOnboardingDone(false);
                    if (context.mounted) context.go('/');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle(context, ref.tr('settings_others')),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(ref.tr('settings_about')),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutScreen())),
                ),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.feedback_outlined), title: Text(ref.tr('settings_feedback')), onTap: () => _showTextDialog(context, ref.tr('settings_feedback'), '欢迎通过 GitHub Issues 反馈问题与建议～')),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.privacy_tip_outlined), title: Text(ref.tr('settings_privacy')), onTap: () => _showTextDialog(context, ref.tr('settings_privacy'), '奶龙工具箱所有工具均在本地设备上处理数据，不会收集、上传或存储你的任何文件与输入内容。')),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.description_outlined), title: Text(ref.tr('settings_agreement')), onTap: () => _showTextDialog(context, ref.tr('settings_agreement'), '本软件完全免费，仅供个人学习与日常使用，请遵守当地法律法规合理使用。')),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.system_update_alt), title: Text(ref.tr('settings_check_update')), onTap: () => _showTextDialog(context, ref.tr('settings_check_update'), '当前已是本地最新版本。')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
    );
  }

  void _showTextDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('好的'))],
      ),
    );
  }

  void _showHelp(BuildContext context, WidgetRef ref) {
    _showTextDialog(context, ref.tr('settings_help'),
        '在首页选择分类，点击工具进入使用；工具页面右上角的爱心可以收藏；使用过的工具会自动出现在“历史”里；所有处理都在本机完成，无需担心隐私问题。');
  }
}
