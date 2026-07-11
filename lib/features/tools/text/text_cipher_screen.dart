import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

/// 文本对称加密 / 解密：AES-256-CBC，密钥由密码经 SHA-256 派生，IV 随机生成并拼接在密文前。
/// 全部在本地完成，不会上传密码或原文。
class TextCipherScreen extends ConsumerStatefulWidget {
  const TextCipherScreen({super.key});
  @override
  ConsumerState<TextCipherScreen> createState() => _State();
}

class _State extends ConsumerState<TextCipherScreen> {
  final _textCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isEncrypt = true;
  bool _obscure = true;
  String _result = '';
  String? _error;

  enc.Key _deriveKey(String password) => enc.Key(Uint8List.fromList(sha256.convert(utf8.encode(password)).bytes));

  void _run() {
    final password = _passwordCtrl.text;
    if (password.isEmpty) {
      setState(() => _error = '请输入密码');
      return;
    }
    final key = _deriveKey(password);
    try {
      if (_isEncrypt) {
        final iv = enc.IV.fromSecureRandom(16);
        final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
        final encrypted = encrypter.encrypt(_textCtrl.text, iv: iv);
        final combined = base64.encode([...iv.bytes, ...encrypted.bytes]);
        setState(() {
          _result = combined;
          _error = null;
        });
      } else {
        final raw = base64.decode(_textCtrl.text.trim());
        if (raw.length < 16) throw const FormatException('密文过短');
        final iv = enc.IV(Uint8List.fromList(raw.sublist(0, 16)));
        final cipherBytes = raw.sublist(16);
        final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
        final decrypted = encrypter.decrypt(enc.Encrypted(Uint8List.fromList(cipherBytes)), iv: iv);
        setState(() {
          _result = decrypted;
          _error = null;
        });
      }
    } catch (e) {
      setState(() {
        _error = _isEncrypt ? '加密失败：$e' : '解密失败，请检查密码或密文是否正确';
        _result = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'text_cipher',
      titleKey: 'text_cipher',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('加密')),
              ButtonSegment(value: false, label: Text('解密')),
            ],
            selected: {_isEncrypt},
            onSelectionChanged: (s) => setState(() {
              _isEncrypt = s.first;
              _result = '';
              _error = null;
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _textCtrl,
            maxLines: 5,
            decoration: InputDecoration(labelText: _isEncrypt ? '待加密的文本' : '待解密的密文（Base64）'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordCtrl,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: '密码',
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text('AES-256 本地加密，请牢记密码，忘记密码将无法解密。', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          FilledButton(onPressed: _run, child: Text(_isEncrypt ? '加密' : '解密')),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
              child: SelectableText(_result),
            ),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: _result),
          ],
        ],
      ),
    );
  }
}
