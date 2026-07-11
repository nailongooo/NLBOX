import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class UuidGenScreen extends ConsumerStatefulWidget {
  const UuidGenScreen({super.key});
  @override
  ConsumerState<UuidGenScreen> createState() => _State();
}

class _State extends ConsumerState<UuidGenScreen> {
  static final _uuid = Uuid();
  double _count = 5;
  bool _uppercase = false;
  bool _withHyphen = true;
  List<String> _results = [];

  void _generate() {
    setState(() {
      _results = List.generate(_count.round(), (_) {
        var v = _uuid.v4();
        if (!_withHyphen) v = v.replaceAll('-', '');
        if (_uppercase) v = v.toUpperCase();
        return v;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'text_uuid',
      titleKey: 'text_uuid',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('生成数量：${_count.round()}'),
          Slider(value: _count, min: 1, max: 30, divisions: 29, onChanged: (v) => setState(() => _count = v)),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('大写'), value: _uppercase, onChanged: (v) => setState(() => _uppercase = v)),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('保留连字符 -'), value: _withHyphen, onChanged: (v) => setState(() => _withHyphen = v)),
          const SizedBox(height: 8),
          FilledButton.icon(onPressed: _generate, icon: const Icon(Icons.fingerprint), label: Text(ref.tr('common_generate'))),
          if (_results.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._results.map((r) => Card(child: ListTile(dense: true, title: SelectableText(r, style: const TextStyle(fontFamily: 'monospace'))))),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: _results.join('\n')),
          ],
        ],
      ),
    );
  }
}
