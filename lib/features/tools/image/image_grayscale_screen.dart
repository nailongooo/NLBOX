import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../core/utils/image_tool_utils.dart';

class ImageGrayscaleScreen extends ConsumerStatefulWidget {
  const ImageGrayscaleScreen({super.key});
  @override
  ConsumerState<ImageGrayscaleScreen> createState() => _State();
}

class _State extends ConsumerState<ImageGrayscaleScreen> {
  Uint8List? _original;
  Uint8List? _result;
  bool _loading = false;
  String? _error;

  Future<void> _pick() async {
    final img = await pickImageBytes();
    if (img == null) return;
    setState(() {
      _original = img.bytes;
      _result = null;
    });
  }

  Future<void> _process() async {
    if (_original == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await compute(grayscaleImageIsolate, _original!);
      setState(() => _result = result);
    } catch (e) {
      setState(() => _error = '处理失败：$e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'image_grayscale',
      titleKey: 'image_grayscale',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(onPressed: _pick, icon: const Icon(Icons.add_photo_alternate), label: Text(ref.tr('common_pick_image'))),
          if (_original != null) ...[
            const SizedBox(height: 16),
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(_original!, height: 160, fit: BoxFit.contain)),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _loading ? null : _process,
              icon: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.invert_colors),
              label: const Text('转为黑白'),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_result != null) ...[
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(_result!, height: 200, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text('${ref.tr('common_result_size')}：${formatBytes(_result!.length)}'),
            const SizedBox(height: 8),
            ResultActionsBar(fileBytes: _result, fileName: 'nailong_grayscale.png'),
          ],
        ],
      ),
    );
  }
}
