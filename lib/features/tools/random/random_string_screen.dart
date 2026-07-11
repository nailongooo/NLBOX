import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class RandomStringScreen extends ConsumerStatefulWidget {
  const RandomStringScreen({super.key});
  @override
  ConsumerState<RandomStringScreen> createState() => _State();
}

class _State extends ConsumerState<RandomStringScreen> {
  double _length = 16;
  bool _upper = true, _lower = true, _digits = true, _symbols = false;
  List<String> _results = [];

  String _charset() {
    var s = '';
    if (_upper) s += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (_lower) s += 'abcdefghijklmnopqrstuvwxyz';
    if (_digits) s += '0123456789';
    if (_symbols) s += r'!@#$%^&*()-_=+[]{}';
    return s;
  }

  void _generate() {
    final charset = _charset();
    if (charset.isEmpty) return;
    final rand = Random.secure();
    final list = List.generate(5, (_) {
      return List.generate(_length.round(), (_) => charset[rand.nextInt(charset.length)]).join();
    });
    setState(() => _results = list);
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'random_string',
      titleKey: 'random_string',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('长度：${_length.round()}'),
          Slider(value: _length, min: 4, max: 64, divisions: 60, onChanged: (v) => setState(() => _length = v)),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: _upper, onChanged: (v) => setState(() => _upper = v ?? true), title: const Text('包含大写字母 A-Z')),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: _lower, onChanged: (v) => setState(() => _lower = v ?? true), title: const Text('包含小写字母 a-z')),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: _digits, onChanged: (v) => setState(() => _digits = v ?? true), title: const Text('包含数字 0-9')),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: _symbols, onChanged: (v) => setState(() => _symbols = v ?? false), title: const Text('包含特殊符号')),
          const SizedBox(height: 8),
          FilledButton.icon(onPressed: _generate, icon: const Icon(Icons.shuffle), label: Text(ref.tr('common_generate'))),
          if (_results.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._results.map((r) => Card(child: ListTile(title: SelectableText(r, style: const TextStyle(fontFamily: 'monospace'))))),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: _results.join('\n')),
          ],
        ],
      ),
    );
  }
}
