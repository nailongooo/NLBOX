import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/tool_registry.dart';
import '../../core/models/tool_info.dart';
import '../../core/providers/favorites_providers.dart';
import '../../core/providers/settings_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favIds = ref.watch(favoritesProvider);
    final tools = favIds.map(findTool).whereType<ToolInfo>().toList();
    return Scaffold(
      appBar: AppBar(title: Text(ref.tr('nav_favorites'))),
      body: tools.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(ref.tr('no_favorites'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: tools.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final tool = tools[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(tool.icon)),
                    title: Text(ref.tr(tool.titleKey)),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.redAccent, size: 20),
                      onPressed: () => ref.read(favoritesProvider.notifier).toggle(tool.id),
                    ),
                    onTap: () => context.push('/tool/${tool.id}'),
                  ),
                );
              },
            ),
    );
  }
}
