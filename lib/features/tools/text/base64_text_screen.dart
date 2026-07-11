import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class Base64TextScreen extends ConsumerStatefulWidget {
  const Base64TextScreen({super.key});
  @override
  ConsumerState<Base64TextScreen> createState() => _State();
}

class _State extends ConsumerState<Base64TextScreen> {
  final _ctrl = TextEditingController(text: '奶龙工具箱 NaiLong Toolbox');
  String _result = '';
  String? _error;

  void _encode() => setState(() {
        _result = base64.encode(utf8.encode(_ctrl.text));
        _error = null;
      });

  void _decode() {
    try {
      setState(() {
        _result = utf8.decode(base64.decode(_ctrl.text.trim()));
        _error = null;
      });
    } catch (e) {
      setState(() => _error = '解码失败，请检查输入是否为合法的 Base64：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'text_base64',
      titleKey: 'text_base64',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _ctrl, maxLines: 6, decoration: const InputDecoration(labelText: '输入文本')),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: FilledButton(onPressed: _encode, child: const Text('编码'))),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton(onPressed: _decode, child: const Text('解码'))),
          ]),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
              child: SelectableText(_result, style: const TextStyle(fontFamily: 'monospace')),
            ),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: _result),
          ],
        ],
      ),
    );
  }
}
