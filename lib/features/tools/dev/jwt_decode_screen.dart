import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class JwtDecodeScreen extends ConsumerStatefulWidget {
  const JwtDecodeScreen({super.key});
  @override
  ConsumerState<JwtDecodeScreen> createState() => _State();
}

class _State extends ConsumerState<JwtDecodeScreen> {
  final _inputCtrl = TextEditingController();
  String _header = '';
  String _payload = '';
  String? _error;

  String _base64UrlDecode(String input) {
    var s = input.replaceAll('-', '+').replaceAll('_', '/');
    switch (s.length % 4) {
      case 2:
        s += '==';
        break;
      case 3:
        s += '=';
        break;
    }
    return utf8.decode(base64.decode(s));
  }

  void _decode() {
    final parts = _inputCtrl.text.trim().split('.');
    if (parts.length < 2) {
      setState(() {
        _error = 'JWT 格式应为 header.payload.signature';
        _header = '';
        _payload = '';
      });
      return;
    }
    try {
      final headerJson = jsonDecode(_base64UrlDecode(parts[0]));
      final payloadJson = jsonDecode(_base64UrlDecode(parts[1])) as Map<String, dynamic>;
      const encoder = JsonEncoder.withIndent('  ');
      var payloadText = encoder.convert(payloadJson);
      if (payloadJson['exp'] is int) {
        final exp = DateTime.fromMillisecondsSinceEpoch((payloadJson['exp'] as int) * 1000);
        payloadText += '\n\n过期时间（exp）：$exp';
      }
      setState(() {
        _header = encoder.convert(headerJson);
        _payload = payloadText;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = '解析失败：$e';
        _header = '';
        _payload = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'dev_jwt',
      titleKey: 'dev_jwt',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _inputCtrl, maxLines: 5, decoration: const InputDecoration(labelText: '粘贴 JWT'), style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
          const SizedBox(height: 12),
          FilledButton(onPressed: _decode, child: const Text('解析')),
          const SizedBox(height: 8),
          const Text('说明：仅在本地解码 Header 和 Payload，不校验签名，也不会上传任何内容。', style: TextStyle(fontSize: 12, color: Colors.grey)),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_header.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Header', style: Theme.of(context).textTheme.titleMedium),
            Card(child: Padding(padding: const EdgeInsets.all(12), child: SelectableText(_header, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)))),
            const SizedBox(height: 12),
            Text('Payload', style: Theme.of(context).textTheme.titleMedium),
            Card(child: Padding(padding: const EdgeInsets.all(12), child: SelectableText(_payload, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)))),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: '$_header\n\n$_payload'),
          ],
        ],
      ),
    );
  }
}
