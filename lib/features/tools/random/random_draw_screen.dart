import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class RandomDrawScreen extends ConsumerStatefulWidget {
  const RandomDrawScreen({super.key});
  @override
  ConsumerState<RandomDrawScreen> createState() => _State();
}

class _State extends ConsumerState<RandomDrawScreen> {
  final _listCtrl = TextEditingController(text: '张三\n李四\n王五\n赵六\n奶龙');
  final _countCtrl = TextEditingController(text: '1');
  List<String> _winners = [];

  void _draw() {
    final items = _listCtrl.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final count = int.tryParse(_countCtrl.text) ?? 1;
    if (items.isEmpty || count <= 0) return;
    items.shuffle(Random());
    setState(() => _winners = items.take(min(count, items.length)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'random_draw',
      titleKey: 'random_draw',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('候选名单（每行一个）', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          TextField(controller: _listCtrl, maxLines: 8, decoration: const InputDecoration(hintText: '每行一个名字')),
          const SizedBox(height: 12),
          TextField(controller: _countCtrl, decoration: const InputDecoration(labelText: '抽取人数'), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: _draw, icon: const Icon(Icons.emoji_events), label: const Text('开始抽签')),
          if (_winners.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(spacing: 8, runSpacing: 8, children: _winners.map((w) => Chip(avatar: const Icon(Icons.star, size: 18), label: Text(w))).toList()),
            const SizedBox(height: 12),
            ResultActionsBar(copyText: _winners.join('、')),
          ],
        ],
      ),
    );
  }
}
