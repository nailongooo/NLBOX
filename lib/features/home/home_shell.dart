import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/settings_providers.dart';
import 'home_screen.dart';
import '../favorites/favorites_screen.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';
import '../onboarding/onboarding_screen.dart';

/// App 主壳：底部导航切换 首页 / 收藏 / 历史 / 我的 四个一级页面。
/// 首次启动时会先展示新手引导。
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});
  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _showOnboarding = !ref.read(localStorageProvider).onboardingDone;
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingScreen(
        onFinish: () async {
          await ref.read(localStorageProvider).setOnboardingDone(true);
          setState(() => _showOnboarding = false);
        },
      );
    }
    final pages = const [HomeScreen(), FavoritesScreen(), HistoryScreen(), SettingsScreen()];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: ref.tr('nav_home')),
          NavigationDestination(icon: const Icon(Icons.favorite_border), selectedIcon: const Icon(Icons.favorite), label: ref.tr('nav_favorites')),
          NavigationDestination(icon: const Icon(Icons.history_outlined), selectedIcon: const Icon(Icons.history), label: ref.tr('nav_history')),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: ref.tr('nav_settings')),
        ],
      ),
    );
  }
}
