import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class RandomPasswordScreen extends ConsumerStatefulWidget {
  const RandomPasswordScreen({super.key});
  @override
  ConsumerState<RandomPasswordScreen> createState() => _State();
}

class _State extends ConsumerState<RandomPasswordScreen> {
  double _length = 16;
  bool _upper = true, _lower = true, _digits = true, _symbols = true, _excludeAmbiguous = true;
  String _password = '';
  double _strength = 0;

  static const _ambiguous = 'Il1O0';

  void _generate() {
    var charset = '';
    if (_upper) charset += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (_lower) charset += 'abcdefghijklmnopqrstuvwxyz';
    if (_digits) charset += '0123456789';
    if (_symbols) charset += r'!@#$%^&*()-_=+[]{}';
    if (_excludeAmbiguous) {
      charset = charset.split('').where((c) => !_ambiguous.contains(c)).join();
    }
    if (charset.isEmpty) return;
    final rand = Random.secure();
    final pwd = List.generate(_length.round(), (_) => charset[rand.nextInt(charset.length)]).join();
    var score = 0;
    if (_upper) score++;
    if (_lower) score++;
    if (_digits) score++;
    if (_symbols) score++;
    setState(() {
      _password = pwd;
      _strength = (score / 4) * (_length / 24).clamp(0.4, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'text_random_password',
      titleKey: 'text_random_password',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('长度：${_length.round()}'),
          Slider(value: _length, min: 6, max: 32, divisions: 26, onChanged: (v) => setState(() => _length = v)),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: _upper, onChanged: (v) => setState(() => _upper = v ?? true), title: const Text('大写字母')),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: _lower, onChanged: (v) => setState(() => _lower = v ?? true), title: const Text('小写字母')),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: _digits, onChanged: (v) => setState(() => _digits = v ?? true), title: const Text('数字')),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: _symbols, onChanged: (v) => setState(() => _symbols = v ?? true), title: const Text('特殊符号')),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: _excludeAmbiguous, onChanged: (v) => setState(() => _excludeAmbiguous = v ?? true), title: const Text('排除易混淆字符（Il1O0）')),
          const SizedBox(height: 8),
          FilledButton.icon(onPressed: _generate, icon: const Icon(Icons.password), label: Text(ref.tr('common_generate'))),
          if (_password.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
              child: SelectableText(_password, style: const TextStyle(fontFamily: 'monospace', fontSize: 18, letterSpacing: 1)),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: _strength,
              color: _strength < 0.4 ? Colors.red : (_strength < 0.7 ? Colors.orange : Colors.green),
              backgroundColor: Colors.grey.withOpacity(0.2),
            ),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: _password),
          ],
        ],
      ),
    );
  }
}
