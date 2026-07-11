import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../core/utils/chinese_convert_map.dart';

class ChineseConvertScreen extends ConsumerStatefulWidget {
  const ChineseConvertScreen({super.key});
  @override
  ConsumerState<ChineseConvertScreen> createState() => _State();
}

class _State extends ConsumerState<ChineseConvertScreen> {
  final _ctrl = TextEditingController(text: '奶龙工具箱支持简繁体转换');
  bool _toTraditional = true;
  String _result = '';

  void _convert() {
    final map = _toTraditional ? kSimplifiedToTraditional : kTraditionalToSimplified;
    final buffer = StringBuffer();
    for (final ch in _ctrl.text.characters) {
      buffer.write(map[ch] ?? ch);
    }
    setState(() => _result = buffer.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'text_chinese_convert',
      titleKey: 'text_chinese_convert',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _ctrl, maxLines: 5, decoration: const InputDecoration(labelText: '输入文本')),
          const SizedBox(height: 12),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('简体 → 繁体')),
              ButtonSegment(value: false, label: Text('繁体 → 简体')),
            ],
            selected: {_toTraditional},
            onSelectionChanged: (s) => setState(() => _toTraditional = s.first),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _convert, child: const Text('转换')),
          const SizedBox(height: 6),
          const Text('基于常用汉字对照表本地转换，覆盖高频字，罕见字或词组级差异可能无法转换。', style: TextStyle(fontSize: 12, color: Colors.grey)),
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
              child: SelectableText(_result, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: _result),
          ],
        ],
      ),
    );
  }
}
