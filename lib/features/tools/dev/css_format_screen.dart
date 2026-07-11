import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../core/utils/simple_formatters.dart';

class CssFormatScreen extends ConsumerStatefulWidget {
  const CssFormatScreen({super.key});
  @override
  ConsumerState<CssFormatScreen> createState() => _State();
}

class _State extends ConsumerState<CssFormatScreen> {
  final _inputCtrl = TextEditingController(text: '.a{color:red;font-size:14px}.b{display:flex}');
  String _result = '';

  void _format() => setState(() => _result = SimpleFormatters.formatCss(_inputCtrl.text));

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'dev_css_format',
      titleKey: 'dev_css_format',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _inputCtrl, maxLines: 8, style: const TextStyle(fontFamily: 'monospace', fontSize: 13), decoration: const InputDecoration(labelText: '输入 CSS')),
          const SizedBox(height: 12),
          FilledButton(onPressed: _format, child: const Text('格式化')),
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
