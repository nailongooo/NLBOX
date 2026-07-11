import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class QrGenerateScreen extends ConsumerStatefulWidget {
  const QrGenerateScreen({super.key});
  @override
  ConsumerState<QrGenerateScreen> createState() => _State();
}

class _State extends ConsumerState<QrGenerateScreen> {
  final _ctrl = TextEditingController(text: 'https://nailong.example.com');
  final _boundaryKey = GlobalKey();
  double _size = 240;
  Uint8List? _pngBytes;
  String _content = 'https://nailong.example.com';

  void _generate() => setState(() {
        _content = _ctrl.text.trim().isEmpty ? ' ' : _ctrl.text.trim();
        _pngBytes = null;
      });

  Future<void> _exportPng() async {
    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        setState(() => _pngBytes = byteData.buffer.asUint8List());
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'image_qr_generate',
      titleKey: 'image_qr_generate',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _ctrl, maxLines: 3, decoration: const InputDecoration(labelText: '文本或链接内容')),
          const SizedBox(height: 8),
          Text('二维码大小：${_size.round()} px'),
          Slider(value: _size, min: 120, max: 400, divisions: 28, onChanged: (v) => setState(() => _size = v)),
          FilledButton.icon(onPressed: _generate, icon: const Icon(Icons.qr_code), label: const Text('生成二维码')),
          const SizedBox(height: 20),
          Center(
            child: RepaintBoundary(
              key: _boundaryKey,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: QrImageView(
                  data: _content,
                  version: QrVersions.auto,
                  size: _size,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton.icon(onPressed: _exportPng, icon: const Icon(Icons.image), label: const Text('导出为图片')),
          ),
          if (_pngBytes != null) ...[
            const SizedBox(height: 12),
            Center(child: ResultActionsBar(fileBytes: _pngBytes, fileName: 'nailong_qrcode.png')),
          ],
        ],
      ),
    );
  }
}
