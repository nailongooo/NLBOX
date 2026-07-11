import 'dart:convert';
import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/providers/settings_providers.dart';

class WordCountScreen extends ConsumerStatefulWidget {
  const WordCountScreen({super.key});
  @override
  ConsumerState<WordCountScreen> createState() => _State();
}

class _State extends ConsumerState<WordCountScreen> {
  final _ctrl = TextEditingController();
  int _chars = 0, _charsNoSpace = 0, _words = 0, _lines = 0, _bytes = 0;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_update);
  }

  void _update() {
    final text = _ctrl.text;
    setState(() {
      _chars = text.characters.length;
      _charsNoSpace = text.replaceAll(RegExp(r'\s'), '').characters.length;
      _words = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
      _lines = text.isEmpty ? 0 : text.split('\n').length;
      _bytes = utf8.encode(text).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'text_word_count',
      titleKey: 'text_word_count',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _ctrl, maxLines: 10, decoration: const InputDecoration(labelText: '输入或粘贴文本')),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.6,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _stat('字符数（含空格）', '$_chars'),
              _stat('字符数（不含空格）', '$_charsNoSpace'),
              _stat('单词数', '$_words'),
              _stat('行数', '$_lines'),
              _stat('字节数（UTF-8）', '$_bytes'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
