import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/tool_registry.dart';
import '../../core/models/tool_info.dart';
import '../../core/providers/history_providers.dart';
import '../../core/providers/settings_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final history = ref.watch(historyProvider);
    final recentIds = ref.read(historyProvider.notifier).recentToolIds(limit: 6);
    final recentTools = recentIds.map(findTool).whereType<ToolInfo>().toList();

    return Container(
      decoration: AppTheme.backgroundDecoration(scheme),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(ref.tr('app_name'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22)),
              actions: [
                IconButton(icon: const Icon(Icons.search), onPressed: () => context.push('/search')),
              ],
            ),
            if (recentTools.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Text(ref.tr('recent_used'), style: Theme.of(context).textTheme.titleMedium),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 56,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recentTools.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final tool = recentTools[i];
                      return ActionChip(
                        avatar: Icon(tool.icon, size: 18),
                        label: Text(ref.tr(tool.titleKey)),
                        onPressed: () => context.push('/tool/${tool.id}'),
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
            ],
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              sliver: SliverToBoxAdapter(child: Text(ref.tr('all_tools'), style: Theme.of(context).textTheme.titleMedium)),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 1.3),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final category = ToolCategory.values[i];
                    final count = toolsByCategory(category).length;
                    return GlassCard(
                      onTap: () => context.push('/category/${category.name}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(category.icon, size: 30, color: scheme.primary),
                          const Spacer(),
                          Text(ref.tr(category.key), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text('$count 个工具', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    );
                  },
                  childCount: ToolCategory.values.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
