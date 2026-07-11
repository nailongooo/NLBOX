import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class TextSortScreen extends ConsumerStatefulWidget {
  const TextSortScreen({super.key});
  @override
  ConsumerState<TextSortScreen> createState() => _State();
}

class _State extends ConsumerState<TextSortScreen> {
  final _ctrl = TextEditingController(text: '香蕉\n苹果\n奶龙\nApple\nBanana');
  bool _asc = true;
  bool _numeric = false;
  String _result = '';

  void _process() {
    var lines = _ctrl.text.split('\n').where((e) => e.trim().isNotEmpty).toList();
    if (_numeric) {
      lines.sort((a, b) => (double.tryParse(a) ?? 0).compareTo(double.tryParse(b) ?? 0));
    } else {
      lines.sort();
    }
    if (!_asc) lines = lines.reversed.toList();
    setState(() => _result = lines.join('\n'));
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'text_sort',
      titleKey: 'text_sort',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _ctrl, maxLines: 8, decoration: const InputDecoration(labelText: '每行一条内容')),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('升序（关闭为降序）'), value: _asc, onChanged: (v) => setState(() => _asc = v)),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('按数字排序'), value: _numeric, onChanged: (v) => setState(() => _numeric = v)),
          FilledButton(onPressed: _process, child: const Text('排序')),
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
