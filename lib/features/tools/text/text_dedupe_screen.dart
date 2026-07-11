import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class TextDedupeScreen extends ConsumerStatefulWidget {
  const TextDedupeScreen({super.key});
  @override
  ConsumerState<TextDedupeScreen> createState() => _State();
}

class _State extends ConsumerState<TextDedupeScreen> {
  final _ctrl = TextEditingController(text: '苹果\n香蕉\n苹果\n奶龙\n香蕉');
  bool _keepOrder = true;
  bool _trimLines = true;
  String _result = '';

  void _process() {
    var lines = _ctrl.text.split('\n');
    if (_trimLines) lines = lines.map((e) => e.trim()).toList();
    lines = lines.where((e) => e.isNotEmpty).toList();
    final seen = <String>{};
    final out = <String>[];
    for (final l in lines) {
      if (seen.add(l)) out.add(l);
    }
    if (!_keepOrder) out.sort();
    setState(() => _result = out.join('\n'));
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'text_dedupe',
      titleKey: 'text_dedupe',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _ctrl, maxLines: 8, decoration: const InputDecoration(labelText: '每行一条内容')),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('保持原有顺序（关闭则按字母排序）'), value: _keepOrder, onChanged: (v) => setState(() => _keepOrder = v)),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('去除每行首尾空格'), value: _trimLines, onChanged: (v) => setState(() => _trimLines = v)),
          FilledButton(onPressed: _process, child: const Text('去重')),
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
              child: SelectableText(_result),
            ),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: _result),
          ],
        ],
      ),
    );
  }
}
