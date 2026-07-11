import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class RandomGroupScreen extends ConsumerStatefulWidget {
  const RandomGroupScreen({super.key});
  @override
  ConsumerState<RandomGroupScreen> createState() => _State();
}

class _State extends ConsumerState<RandomGroupScreen> {
  final _listCtrl = TextEditingController(text: '张三\n李四\n王五\n赵六\n奶龙\n小美');
  final _groupCtrl = TextEditingController(text: '2');
  bool _byGroupCount = true; // true=按组数分, false=按每组人数分
  List<List<String>> _groups = [];

  void _split() {
    final items = _listCtrl.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()..shuffle(Random());
    final n = int.tryParse(_groupCtrl.text) ?? 1;
    if (items.isEmpty || n <= 0) return;
    final groups = <List<String>>[];
    if (_byGroupCount) {
      for (var i = 0; i < n; i++) groups.add([]);
      for (var i = 0; i < items.length; i++) {
        groups[i % n].add(items[i]);
      }
    } else {
      for (var i = 0; i < items.length; i += n) {
        groups.add(items.sublist(i, min(i + n, items.length)));
      }
    }
    setState(() => _groups = groups);
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'random_group',
      titleKey: 'random_group',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('名单（每行一个）'),
          const SizedBox(height: 8),
          TextField(controller: _listCtrl, maxLines: 8),
          const SizedBox(height: 12),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('按组数分')),
              ButtonSegment(value: false, label: Text('按每组人数分')),
            ],
            selected: {_byGroupCount},
            onSelectionChanged: (s) => setState(() => _byGroupCount = s.first),
          ),
          const SizedBox(height: 12),
          TextField(controller: _groupCtrl, decoration: InputDecoration(labelText: _byGroupCount ? '分成几组' : '每组几人'), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: _split, icon: const Icon(Icons.groups), label: const Text('随机分组')),
          if (_groups.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._groups.asMap().entries.map((e) => Card(
                  child: ListTile(
                    title: Text('第 ${e.key + 1} 组'),
                    subtitle: Text(e.value.join('、')),
                  ),
                )),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: _groups.asMap().entries.map((e) => '第${e.key + 1}组：${e.value.join('、')}').join('\n')),
          ],
        ],
      ),
    );
  }
}
