import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../core/utils/image_tool_utils.dart';

class ImageFormatConvertScreen extends ConsumerStatefulWidget {
  const ImageFormatConvertScreen({super.key});
  @override
  ConsumerState<ImageFormatConvertScreen> createState() => _State();
}

class _State extends ConsumerState<ImageFormatConvertScreen> {
  Uint8List? _original;
  Uint8List? _converted;
  TargetFormat _target = TargetFormat.png;
  bool _loading = false;
  String? _error;

  Future<void> _pick() async {
    final img = await pickImageBytes();
    if (img == null) return;
    setState(() {
      _original = img.bytes;
      _converted = null;
    });
  }

  Future<void> _convert() async {
    if (_original == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await compute(convertFormatIsolate, FormatConvertParams(_original!, _target));
      setState(() => _converted = result);
    } catch (e) {
      setState(() => _error = '转换失败：$e');
    } finally {
      setState(() => _loading = false);
    }
  }

  String get _ext {
    switch (_target) {
      case TargetFormat.png:
        return 'png';
      case TargetFormat.jpg:
        return 'jpg';
      case TargetFormat.bmp:
        return 'bmp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'image_format_convert',
      titleKey: 'image_format_convert',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(onPressed: _pick, icon: const Icon(Icons.add_photo_alternate), label: Text(ref.tr('common_pick_image'))),
          if (_original != null) ...[
            const SizedBox(height: 16),
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(_original!, height: 160, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text('${ref.tr('common_original_size')}：${formatBytes(_original!.length)}'),
            const SizedBox(height: 12),
            const Text('目标格式：'),
            Wrap(spacing: 8, children: [
              ChoiceChip(label: const Text('PNG'), selected: _target == TargetFormat.png, onSelected: (_) => setState(() => _target = TargetFormat.png)),
              ChoiceChip(label: const Text('JPG'), selected: _target == TargetFormat.jpg, onSelected: (_) => setState(() => _target = TargetFormat.jpg)),
              ChoiceChip(label: const Text('BMP'), selected: _target == TargetFormat.bmp, onSelected: (_) => setState(() => _target = TargetFormat.bmp)),
            ]),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _loading ? null : _convert,
              icon: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.transform),
              label: const Text('开始转换'),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_converted != null) ...[
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(_converted!, height: 200, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text('${ref.tr('common_result_size')}：${formatBytes(_converted!.length)}'),
            const SizedBox(height: 8),
            ResultActionsBar(fileBytes: _converted, fileName: 'nailong_converted.$_ext'),
          ],
        ],
      ),
    );
  }
}
