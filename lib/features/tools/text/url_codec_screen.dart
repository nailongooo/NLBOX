import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class UrlCodecScreen extends ConsumerStatefulWidget {
  const UrlCodecScreen({super.key});
  @override
  ConsumerState<UrlCodecScreen> createState() => _State();
}

class _State extends ConsumerState<UrlCodecScreen> {
  final _ctrl = TextEditingController(text: 'https://nailong.example.com/?q=奶龙 工具箱');
  bool _fullUri = false; // true=Uri.encodeFull/decodeFull, false=encodeComponent/decodeComponent
  String _result = '';
  String? _error;

  void _encode() {
    try {
      setState(() {
        _result = _fullUri ? Uri.encodeFull(_ctrl.text) : Uri.encodeComponent(_ctrl.text);
        _error = null;
      });
    } catch (e) {
      setState(() => _error = '编码失败：$e');
    }
  }

  void _decode() {
    try {
      setState(() {
        _result = _fullUri ? Uri.decodeFull(_ctrl.text) : Uri.decodeComponent(_ctrl.text);
        _error = null;
      });
    } catch (e) {
      setState(() => _error = '解码失败：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'text_url_codec',
      titleKey: 'text_url_codec',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _ctrl, maxLines: 5, decoration: const InputDecoration(labelText: '输入文本 / URL')),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('完整 URL 模式（保留 :/?# 等符号，关闭则编码全部特殊字符）'),
            value: _fullUri,
            onChanged: (v) => setState(() => _fullUri = v),
          ),
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
