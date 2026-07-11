import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../core/utils/image_tool_utils.dart';

class ImageResizeScreen extends ConsumerStatefulWidget {
  const ImageResizeScreen({super.key});
  @override
  ConsumerState<ImageResizeScreen> createState() => _State();
}

class _State extends ConsumerState<ImageResizeScreen> {
  Uint8List? _original;
  Uint8List? _result;
  int _origWidth = 0, _origHeight = 0;
  final _widthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  bool _lockRatio = true;
  bool _loading = false;
  String? _error;

  Future<void> _pick() async {
    final picked = await pickImageBytes();
    if (picked == null) return;
    final codec = await ui.instantiateImageCodec(picked.bytes);
    final frame = await codec.getNextFrame();
    setState(() {
      _original = picked.bytes;
      _origWidth = frame.image.width;
      _origHeight = frame.image.height;
      _widthCtrl.text = _origWidth.toString();
      _heightCtrl.text = _origHeight.toString();
      _result = null;
    });
  }

  void _onWidthChanged(String v) {
    if (!_lockRatio || _origWidth == 0) return;
    final w = int.tryParse(v);
    if (w == null) return;
    _heightCtrl.text = (w * _origHeight / _origWidth).round().toString();
  }

  Future<void> _resize() async {
    if (_original == null) return;
    final w = int.tryParse(_widthCtrl.text);
    final h = int.tryParse(_heightCtrl.text);
    if (w == null || w <= 0) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await compute(resizeImageIsolate, ResizeParams(_original!, w, _lockRatio ? null : h));
      setState(() => _result = result);
    } catch (e) {
      setState(() => _error = '调整失败：$e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'image_resize',
      titleKey: 'image_resize',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(onPressed: _pick, icon: const Icon(Icons.add_photo_alternate), label: Text(ref.tr('common_pick_image'))),
          if (_original != null) ...[
            const SizedBox(height: 16),
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(_original!, height: 160, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text('原始尺寸：$_origWidth × $_origHeight，${formatBytes(_original!.length)}'),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: _widthCtrl, decoration: const InputDecoration(labelText: '宽度 (px)'), keyboardType: TextInputType.number, onChanged: _onWidthChanged)),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: _heightCtrl, enabled: !_lockRatio, decoration: const InputDecoration(labelText: '高度 (px)'), keyboardType: TextInputType.number)),
            ]),
            SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('保持宽高比例'), value: _lockRatio, onChanged: (v) => setState(() => _lockRatio = v)),
            FilledButton.icon(
              onPressed: _loading ? null : _resize,
              icon: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.aspect_ratio),
              label: const Text('调整尺寸'),
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
            ResultActionsBar(fileBytes: _result, fileName: 'nailong_resized.png'),
          ],
        ],
      ),
    );
  }
}
