import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../core/utils/image_tool_utils.dart';

class Base64ToImageScreen extends ConsumerStatefulWidget {
  const Base64ToImageScreen({super.key});
  @override
  ConsumerState<Base64ToImageScreen> createState() => _State();
}

class _State extends ConsumerState<Base64ToImageScreen> {
  final _ctrl = TextEditingController();
  Uint8List? _bytes;
  String? _error;

  void _decode() {
    var input = _ctrl.text.trim();
    final commaIndex = input.indexOf(',');
    if (input.startsWith('data:') && commaIndex != -1) {
      input = input.substring(commaIndex + 1);
    }
    try {
      setState(() {
        _bytes = base64.decode(input);
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = '不是合法的 Base64 图片数据：$e';
        _bytes = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'image_base64_to_image',
      titleKey: 'image_base64_to_image',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _ctrl, maxLines: 6, decoration: const InputDecoration(labelText: '粘贴 Base64（可带 data:image/...;base64, 前缀）'), style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
          const SizedBox(height: 12),
          FilledButton(onPressed: _decode, child: const Text('解码为图片')),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_bytes != null) ...[
            const SizedBox(height: 16),
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(_bytes!, height: 220, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text('大小：${formatBytes(_bytes!.length)}'),
            const SizedBox(height: 8),
            ResultActionsBar(fileBytes: _bytes, fileName: 'nailong_decoded.png'),
          ],
        ],
      ),
    );
  }
}
