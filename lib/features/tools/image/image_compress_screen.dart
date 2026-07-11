import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../core/utils/image_tool_utils.dart';

class ImageCompressScreen extends ConsumerStatefulWidget {
  const ImageCompressScreen({super.key});
  @override
  ConsumerState<ImageCompressScreen> createState() => _State();
}

class _State extends ConsumerState<ImageCompressScreen> {
  Uint8List? _original;
  Uint8List? _compressed;
  double _quality = 80;
  bool _loading = false;
  String? _error;

  Future<void> _pick() async {
    final img = await pickImageBytes();
    if (img == null) return;
    setState(() {
      _original = img.bytes;
      _compressed = null;
      _error = null;
    });
  }

  Future<void> _compress() async {
    if (_original == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await compute(compressImageIsolate, CompressParams(_original!, _quality.round()));
      setState(() => _compressed = result);
    } catch (e) {
      setState(() => _error = '压缩失败：$e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'image_compress',
      titleKey: 'image_compress',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(onPressed: _pick, icon: const Icon(Icons.add_photo_alternate), label: Text(ref.tr('common_pick_image'))),
          if (_original != null) ...[
            const SizedBox(height: 16),
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(_original!, height: 160, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text('${ref.tr('common_original_size')}：${formatBytes(_original!.length)}'),
            if (_original!.length > kLargeFileThresholdBytes)
              const Padding(padding: EdgeInsets.only(top: 4), child: Text('文件较大，压缩可能需要几秒钟，请耐心等待', style: TextStyle(color: Colors.orange))),
            const SizedBox(height: 12),
            Text('压缩质量：${_quality.round()}（数值越低体积越小，画质越差）'),
            Slider(value: _quality, min: 10, max: 100, divisions: 90, onChanged: (v) => setState(() => _quality = v)),
            FilledButton.icon(
              onPressed: _loading ? null : _compress,
              icon: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.compress),
              label: const Text('开始压缩'),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_compressed != null) ...[
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 8),
            Text('压缩预览', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(_compressed!, height: 200, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text('${ref.tr('common_result_size')}：${formatBytes(_compressed!.length)}'
                '（相比原图 ${(100 - _compressed!.length / _original!.length * 100).toStringAsFixed(1)}% ↓）'),
            const SizedBox(height: 8),
            ResultActionsBar(fileBytes: _compressed, fileName: 'nailong_compressed.jpg'),
          ],
        ],
      ),
    );
  }
}
