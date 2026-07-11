import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class XmlFormatScreen extends ConsumerStatefulWidget {
  const XmlFormatScreen({super.key});
  @override
  ConsumerState<XmlFormatScreen> createState() => _State();
}

class _State extends ConsumerState<XmlFormatScreen> {
  final _inputCtrl = TextEditingController(text: '<root><item id="1">奶龙</item></root>');
  String _result = '';
  String? _error;

  void _format() {
    try {
      final doc = XmlDocument.parse(_inputCtrl.text);
      setState(() {
        _result = doc.toXmlString(pretty: true, indent: '  ');
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = 'XML 解析失败：$e';
        _result = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'dev_xml_format',
      titleKey: 'dev_xml_format',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _inputCtrl, maxLines: 8, style: const TextStyle(fontFamily: 'monospace', fontSize: 13), decoration: const InputDecoration(labelText: '输入 XML')),
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
