import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class JsonFormatScreen extends ConsumerStatefulWidget {
  const JsonFormatScreen({super.key});
  @override
  ConsumerState<JsonFormatScreen> createState() => _State();
}

class _State extends ConsumerState<JsonFormatScreen> {
  final _ctrl = TextEditingController(text: '{"name":"奶龙工具箱","version":1,"tools":["图片","文本","随机"]}');
  String _result = '';
  String? _error;

  void _format() {
    try {
      final data = jsonDecode(_ctrl.text);
      const encoder = JsonEncoder.withIndent('  ');
      setState(() {
        _result = encoder.convert(data);
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = 'JSON 解析失败：$e';
        _result = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'text_json_format',
      titleKey: 'text_json_format',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _ctrl, maxLines: 8, style: const TextStyle(fontFamily: 'monospace', fontSize: 13), decoration: const InputDecoration(labelText: '输入 JSON')),
          const SizedBox(height: 12),
          FilledButton(onPressed: _format, child: const Text('格式化')),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
              child: SelectableText(_result, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
            ),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: _result),
          ],
        ],
      ),
    );
  }
}
