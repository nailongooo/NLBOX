import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/providers/settings_providers.dart';

class HashCalcScreen extends ConsumerStatefulWidget {
  const HashCalcScreen({super.key});
  @override
  ConsumerState<HashCalcScreen> createState() => _State();
}

class _State extends ConsumerState<HashCalcScreen> {
  final _inputCtrl = TextEditingController();
  Map<String, String> _hashes = {};

  void _calc() {
    final bytes = utf8.encode(_inputCtrl.text);
    setState(() => _hashes = {
          'MD5': md5.convert(bytes).toString(),
          'SHA-1': sha1.convert(bytes).toString(),
          'SHA-256': sha256.convert(bytes).toString(),
          'SHA-512': sha512.convert(bytes).toString(),
        });
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'dev_hash',
      titleKey: 'dev_hash',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _inputCtrl, maxLines: 5, decoration: const InputDecoration(labelText: '输入文本')),
          const SizedBox(height: 12),
          FilledButton(onPressed: _calc, child: const Text('计算哈希')),
          if (_hashes.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._hashes.entries.map((e) => Card(
                  child: ListTile(
                    title: Text(e.key),
                    subtitle: SelectableText(e.value, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      tooltip: ref.tr('common_copy'),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: e.value));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ref.tr('common_copied'))));
                        }
                      },
                    ),
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
