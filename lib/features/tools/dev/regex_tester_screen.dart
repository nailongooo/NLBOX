import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/providers/settings_providers.dart';

class RegexTesterScreen extends ConsumerStatefulWidget {
  const RegexTesterScreen({super.key});
  @override
  ConsumerState<RegexTesterScreen> createState() => _State();
}

class _State extends ConsumerState<RegexTesterScreen> {
  final _patternCtrl = TextEditingController(text: r'\d+');
  final _textCtrl = TextEditingController(text: '奶龙工具箱 2026 年发布第 1 版，欢迎使用！');
  bool _multiLine = false, _caseSensitive = true, _dotAll = false;
  List<RegExpMatch> _matches = [];
  String? _error;

  void _test() {
    try {
      final re = RegExp(_patternCtrl.text, multiLine: _multiLine, caseSensitive: _caseSensitive, dotAll: _dotAll);
      setState(() {
        _matches = re.allMatches(_textCtrl.text).toList();
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = '正则表达式有误：$e';
        _matches = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'dev_regex',
      titleKey: 'dev_regex',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _patternCtrl, decoration: const InputDecoration(labelText: '正则表达式', prefixText: '/'), style: const TextStyle(fontFamily: 'monospace')),
          const SizedBox(height: 8),
          Wrap(spacing: 4, children: [
            FilterChip(label: const Text('multiline'), selected: _multiLine, onSelected: (v) => setState(() => _multiLine = v)),
            FilterChip(label: const Text('区分大小写'), selected: _caseSensitive, onSelected: (v) => setState(() => _caseSensitive = v)),
            FilterChip(label: const Text('dotAll'), selected: _dotAll, onSelected: (v) => setState(() => _dotAll = v)),
          ]),
          const SizedBox(height: 12),
          TextField(controller: _textCtrl, maxLines: 6, decoration: const InputDecoration(labelText: '测试文本')),
          const SizedBox(height: 12),
          FilledButton(onPressed: _test, child: const Text('测试匹配')),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_error == null && _matches.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('共匹配到 ${_matches.length} 处：', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ..._matches.asMap().entries.map((e) => Card(
                  child: ListTile(
                    dense: true,
                    title: Text('#${e.key + 1}：${e.value.group(0)}', style: const TextStyle(fontFamily: 'monospace')),
                    subtitle: e.value.groupCount > 0
                        ? Text('分组：${List.generate(e.value.groupCount, (i) => e.value.group(i + 1)).join(', ')}')
                        : null,
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
