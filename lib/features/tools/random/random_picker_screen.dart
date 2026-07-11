import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class RandomPickerScreen extends ConsumerStatefulWidget {
  const RandomPickerScreen({super.key});
  @override
  ConsumerState<RandomPickerScreen> createState() => _State();
}

class _State extends ConsumerState<RandomPickerScreen> {
  final _optionCtrl = TextEditingController();
  final List<String> _options = ['吃火锅', '吃烧烤', '喝奶茶'];
  String? _picked;

  void _addOption() {
    final v = _optionCtrl.text.trim();
    if (v.isEmpty) return;
    setState(() {
      _options.add(v);
      _optionCtrl.clear();
    });
  }

  void _pick() {
    if (_options.isEmpty) return;
    setState(() => _picked = _options[Random().nextInt(_options.length)]);
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'random_picker',
      titleKey: 'random_picker',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(child: TextField(controller: _optionCtrl, decoration: const InputDecoration(hintText: '输入一个选项'), onSubmitted: (_) => _addOption())),
            const SizedBox(width: 8),
            IconButton.filled(onPressed: _addOption, icon: const Icon(Icons.add)),
          ]),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _options.map((o) => Chip(
              label: Text(o),
              onDeleted: () => setState(() => _options.remove(o)),
            )).toList(),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: _options.isEmpty ? null : _pick, icon: const Icon(Icons.touch_app), label: const Text('帮我选一个')),
          if (_picked != null) ...[
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_picked!, style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),
            const SizedBox(height: 12),
            Center(child: ResultActionsBar(copyText: _picked)),
          ],
        ],
      ),
    );
  }
}
