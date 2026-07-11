import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/tool_registry.dart';
import '../../core/providers/settings_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _State();
}

class _State extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeCodeProvider);
    final results = _query.trim().isEmpty
        ? []
        : allTools.where((t) => ref.tr(t.titleKey).toLowerCase().contains(_query.toLowerCase()) || t.id.contains(_query.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          decoration: InputDecoration(hintText: ref.tr('search_hint'), border: InputBorder.none),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: _query.trim().isEmpty
          ? Center(child: Text(ref.tr('search_hint'), style: const TextStyle(color: Colors.grey)))
          : results.isEmpty
              ? Center(child: Text(ref.tr('search_empty')))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  itemBuilder: (context, i) {
                    final tool = results[i];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Icon(tool.icon)),
                        title: Text(ref.tr(tool.titleKey)),
                        onTap: () => context.push('/tool/${tool.id}'),
                      ),
                    );
                  },
                ),
    );
  }
}
