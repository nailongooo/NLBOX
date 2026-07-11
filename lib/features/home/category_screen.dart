import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/tool_registry.dart';
import '../../core/models/tool_info.dart';
import '../../core/providers/favorites_providers.dart';
import '../../core/providers/settings_providers.dart';

class CategoryScreen extends ConsumerWidget {
  final ToolCategory category;
  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tools = toolsByCategory(category);
    final favorites = ref.watch(favoritesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(ref.tr(category.key))),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final tool = tools[i];
          final isFav = favorites.contains(tool.id);
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(tool.icon)),
              title: Text(ref.tr(tool.titleKey)),
              trailing: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.redAccent : null, size: 20),
              onTap: () => context.push('/tool/${tool.id}'),
            ),
          );
        },
      ),
    );
  }
}
