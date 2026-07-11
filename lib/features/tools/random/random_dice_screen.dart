import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';

class RandomDiceScreen extends ConsumerStatefulWidget {
  const RandomDiceScreen({super.key});
  @override
  ConsumerState<RandomDiceScreen> createState() => _State();
}

class _State extends ConsumerState<RandomDiceScreen> {
  double _diceCount = 1;
  List<int> _values = [];

  void _roll() {
    final rand = Random();
    setState(() => _values = List.generate(_diceCount.round(), (_) => rand.nextInt(6) + 1));
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'random_dice',
      titleKey: 'random_dice',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('骰子数量：${_diceCount.round()}'),
          Slider(value: _diceCount, min: 1, max: 6, divisions: 5, onChanged: (v) => setState(() => _diceCount = v)),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: _roll, icon: const Icon(Icons.casino), label: const Text('掷骰子')),
          if (_values.isNotEmpty) ...[
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _values.map((v) => Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$v', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              )).toList(),
            ),
            const SizedBox(height: 12),
            Center(child: Text('总和：${_values.reduce((a, b) => a + b)}')),
          ],
        ],
      ),
    );
  }
}
