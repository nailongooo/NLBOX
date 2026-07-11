import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../core/utils/image_tool_utils.dart';

class ImageToBase64Screen extends ConsumerStatefulWidget {
  const ImageToBase64Screen({super.key});
  @override
  ConsumerState<ImageToBase64Screen> createState() => _State();
}

class _State extends ConsumerState<ImageToBase64Screen> {
  Uint8List? _bytes;
  String? _name;
  String _base64Str = '';
  bool _withDataUri = true;

  Future<void> _pick() async {
    final img = await pickImageBytes();
    if (img == null) return;
    setState(() {
      _bytes = img.bytes;
      _name = img.name;
      _updateOutput();
    });
  }

  void _updateOutput() {
    if (_bytes == null) return;
    final mime = (_name?.toLowerCase().endsWith('.png') ?? false) ? 'image/png' : 'image/jpeg';
    final raw = base64.encode(_bytes!);
    _base64Str = _withDataUri ? 'data:$mime;base64,$raw' : raw;
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'image_to_base64',
      titleKey: 'image_to_base64',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(onPressed: _pick, icon: const Icon(Icons.add_photo_alternate), label: Text(ref.tr('common_pick_image'))),
          if (_bytes != null) ...[
            const SizedBox(height: 16),
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(_bytes!, height: 160, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text('${ref.tr('common_original_size')}：${formatBytes(_bytes!.length)}'),
            if (_bytes!.length > kLargeFileThresholdBytes)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text('文件较大，Base64 文本会非常长，转换可能需要一点时间', style: TextStyle(color: Colors.orange)),
              ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('包含 data:image/...;base64, 前缀'),
              value: _withDataUri,
              onChanged: (v) => setState(() {
                _withDataUri = v;
                _updateOutput();
              }),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 220),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(child: SelectableText(_base64Str, style: const TextStyle(fontFamily: 'monospace', fontSize: 11))),
            ),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: _base64Str),
          ],
        ],
      ),
    );
  }
}
