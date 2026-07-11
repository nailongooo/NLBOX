import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class CaseConvertScreen extends ConsumerStatefulWidget {
  const CaseConvertScreen({super.key});
  @override
  ConsumerState<CaseConvertScreen> createState() => _State();
}

class _State extends ConsumerState<CaseConvertScreen> {
  final _ctrl = TextEditingController(text: 'Hello NaiLong Toolbox');
  String _result = '';

  String _titleCase(String s) => s.split(' ').map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1).toLowerCase()).join(' ');
  String _sentenceCase(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
  String _camelCase(String s) {
    final words = s.split(RegExp(r'[\s_-]+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '';
    return words.first.toLowerCase() + words.skip(1).map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase()).join();
  }
  String _snakeCase(String s) => s.split(RegExp(r'[\s-]+')).where((w) => w.isNotEmpty).map((w) => w.toLowerCase()).join('_');
  String _kebabCase(String s) => s.split(RegExp(r'[\s_]+')).where((w) => w.isNotEmpty).map((w) => w.toLowerCase()).join('-');

  @override
  Widget build(BuildContext context) {
    final text = _ctrl.text;
    final options = <String, String>{
      '大写 UPPERCASE': text.toUpperCase(),
      '小写 lowercase': text.toLowerCase(),
      '首字母大写 Title Case': _titleCase(text),
      '句首大写 Sentence case': _sentenceCase(text),
      '小驼峰 camelCase': _camelCase(text),
      '蛇形 snake_case': _snakeCase(text),
      '短横线 kebab-case': _kebabCase(text),
    };
    return ToolPageScaffold(
      toolId: 'text_case_convert',
      titleKey: 'text_case_convert',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _ctrl, maxLines: 4, decoration: const InputDecoration(labelText: '输入文本'), onChanged: (_) => setState(() {})),
          const SizedBox(height: 16),
          ...options.entries.map((e) => Card(
                child: ListTile(
                  title: Text(e.key, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  subtitle: SelectableText(e.value, style: const TextStyle(fontSize: 15)),
                  trailing: ResultActionsBar(copyText: e.value.isEmpty ? null : e.value),
                ),
              )),
        ],
      ),
    );
  }
}
