import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class RandomNumberScreen extends ConsumerStatefulWidget {
  const RandomNumberScreen({super.key});
  @override
  ConsumerState<RandomNumberScreen> createState() => _State();
}

class _State extends ConsumerState<RandomNumberScreen> {
  final _minCtrl = TextEditingController(text: '1');
  final _maxCtrl = TextEditingController(text: '100');
  final _countCtrl = TextEditingController(text: '1');
  bool _isDecimal = false;
  bool _noRepeat = false;
  List<String> _results = [];

  void _generate() {
    final min = double.tryParse(_minCtrl.text) ?? 0;
    final max = double.tryParse(_maxCtrl.text) ?? 0;
    final count = int.tryParse(_countCtrl.text) ?? 1;
    final rand = Random();
    if (max < min || count <= 0) {
      setState(() => _results = []);
      return;
    }
    final list = <String>[];
    if (_isDecimal) {
      for (var i = 0; i < count; i++) {
        final v = min + rand.nextDouble() * (max - min);
        list.add(v.toStringAsFixed(2));
      }
    } else {
      final iMin = min.round();
      final iMax = max.round();
      if (_noRepeat) {
        final range = (iMax - iMin + 1);
        if (count > range) {
          setState(() => _results = ['可选范围不足以生成 $count 个不重复的数']);
          return;
        }
        final pool = List<int>.generate(range, (i) => iMin + i)..shuffle(rand);
        list.addAll(pool.take(count).map((e) => e.toString()));
      } else {
        for (var i = 0; i < count; i++) {
          list.add((iMin + rand.nextInt(iMax - iMin + 1)).toString());
        }
      }
    }
    setState(() => _results = list);
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'random_number',
      titleKey: 'random_number',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(child: TextField(controller: _minCtrl, decoration: const InputDecoration(labelText: '最小值'), keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true))),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _maxCtrl, decoration: const InputDecoration(labelText: '最大值'), keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true))),
          ]),
          const SizedBox(height: 12),
          TextField(controller: _countCtrl, decoration: const InputDecoration(labelText: '生成个数'), keyboardType: TextInputType.number),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('生成小数（保留两位）'),
            value: _isDecimal,
            onChanged: (v) => setState(() => _isDecimal = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('不重复（仅整数模式）'),
            value: _noRepeat,
            onChanged: _isDecimal ? null : (v) => setState(() => _noRepeat = v),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(onPressed: _generate, icon: const Icon(Icons.casino), label: Text(ref.tr('common_generate'))),
          if (_results.isNotEmpty) ...[
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _results.map((r) => Chip(label: Text(r))).toList(),
            ),
            const SizedBox(height: 16),
            ResultActionsBar(copyText: _results.join(', ')),
          ],
        ],
      ),
    );
  }
}
