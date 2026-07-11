import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../core/utils/simple_formatters.dart';

class HtmlFormatScreen extends ConsumerStatefulWidget {
  const HtmlFormatScreen({super.key});
  @override
  ConsumerState<HtmlFormatScreen> createState() => _State();
}

class _State extends ConsumerState<HtmlFormatScreen> {
  final _inputCtrl = TextEditingController(text: '<div class="a"><p>奶龙工具箱</p><span>hello</span></div>');
  String _result = '';

  void _format() => setState(() => _result = SimpleFormatters.formatHtml(_inputCtrl.text));

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'dev_html_format',
      titleKey: 'dev_html_format',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _inputCtrl, maxLines: 8, style: const TextStyle(fontFamily: 'monospace', fontSize: 13), decoration: const InputDecoration(labelText: '输入 HTML')),
          const SizedBox(height: 12),
          FilledButton(onPressed: _format, child: const Text('格式化')),
          const SizedBox(height: 6),
          const Text('轻量规则格式化，适合快速美化压缩代码；复杂/不规范 HTML 可能无法完美处理。', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
