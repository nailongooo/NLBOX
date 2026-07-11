import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class BaseConvertScreen extends ConsumerStatefulWidget {
  const BaseConvertScreen({super.key});
  @override
  ConsumerState<BaseConvertScreen> createState() => _State();
}

class _State extends ConsumerState<BaseConvertScreen> {
  final _inputCtrl = TextEditingController(text: '255');
  int _fromBase = 10;
  String _result = '';
  final _bases = const [2, 8, 10, 16];

  void _convert() {
    try {
      final value = int.parse(_inputCtrl.text.trim(), radix: _fromBase);
      final lines = <String>[
        '二进制：${value.toRadixString(2)}',
        '八进制：${value.toRadixString(8)}',
        '十进制：${value.toRadixString(10)}',
        '十六进制：${value.toRadixString(16).toUpperCase()}',
      ];
      setState(() => _result = lines.join('\n'));
    } catch (_) {
      setState(() => _result = '输入的数字与所选进制不匹配');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'date_base_convert',
      titleKey: 'date_base_convert',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _inputCtrl, decoration: const InputDecoration(labelText: '输入数字')),
          const SizedBox(height: 12),
          const Text('输入数字的进制：'),
          Wrap(
            spacing: 8,
            children: _bases.map((b) => ChoiceChip(
                  label: Text('$b 进制'),
                  selected: _fromBase == b,
                  onSelected: (_) => setState(() => _fromBase = b),
                )).toList(),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _convert, child: const Text('转换')),
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 16),
            SelectableText(_result, style: const TextStyle(fontFamily: 'monospace', fontSize: 16)),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: _result),
          ],
        ],
      ),
    );
  }
}
