import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/tool_registry.dart';
import '../../core/providers/history_providers.dart';
import '../../core/providers/settings_providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  String _fmtTime(DateTime t) {
    final now = DateTime.now();
    if (t.year == now.year && t.month == now.month && t.day == now.day) {
      return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    }
    return '${t.month}-${t.day} ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('nav_history')),
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: ref.tr('clear_history'),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(ref.tr('clear_history')),
                    content: Text(ref.tr('clear_history_confirm')),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: Text(ref.tr('common_cancel'))),
                      FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(ref.tr('common_confirm'))),
                    ],
                  ),
                );
                if (confirm == true) ref.read(historyProvider.notifier).clear();
              },
            ),
        ],
      ),
      body: history.isEmpty
          ? Center(child: Text(ref.tr('no_history'), style: const TextStyle(color: Colors.grey)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final entry = history[i];
                final tool = findTool(entry.toolId);
                if (tool == null) return const SizedBox.shrink();
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(tool.icon)),
                    title: Text(ref.tr(tool.titleKey)),
                    trailing: Text(_fmtTime(entry.time), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    onTap: () => context.push('/tool/${tool.id}'),
                  ),
                );
              },
            ),
    );
  }
}
