import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/providers/settings_providers.dart';

class PercentageScreen extends ConsumerStatefulWidget {
  const PercentageScreen({super.key});
  @override
  ConsumerState<PercentageScreen> createState() => _State();
}

class _State extends ConsumerState<PercentageScreen> {
  int _mode = 0; // 0: X%of Y   1: X是Y的百分之几   2: X到Y变化百分比
  final _aCtrl = TextEditingController(text: '20');
  final _bCtrl = TextEditingController(text: '150');
  String _result = '';

  void _calc() {
    final a = double.tryParse(_aCtrl.text) ?? 0;
    final b = double.tryParse(_bCtrl.text) ?? 0;
    switch (_mode) {
      case 0:
        setState(() => _result = '$a% of $b = ${(a / 100 * b).toStringAsFixed(4)}');
        break;
      case 1:
        if (b == 0) return;
        setState(() => _result = '$a 是 $b 的 ${(a / b * 100).toStringAsFixed(2)}%');
        break;
      case 2:
        if (a == 0) return;
        final change = (b - a) / a * 100;
        setState(() => _result = '从 $a 到 $b 变化了 ${change.toStringAsFixed(2)}%（${change >= 0 ? '增加' : '减少'}）');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = ['X% of Y', 'X 是 Y 的百分之几', 'X 到 Y 的变化百分比'];
    final aLabels = ['X（百分比数值）', 'X', '起始值 X'];
    final bLabels = ['Y', 'Y', '结束值 Y'];
    return ToolPageScaffold(
      toolId: 'date_percentage',
      titleKey: 'date_percentage',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            children: labels.asMap().entries.map((e) => ChoiceChip(
                  label: Text(e.value),
                  selected: _mode == e.key,
                  onSelected: (_) => setState(() { _mode = e.key; _result = ''; }),
                )).toList(),
          ),
          const SizedBox(height: 16),
          TextField(controller: _aCtrl, decoration: InputDecoration(labelText: aLabels[_mode]), keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true)),
          const SizedBox(height: 12),
          TextField(controller: _bCtrl, decoration: InputDecoration(labelText: bLabels[_mode]), keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true)),
          const SizedBox(height: 16),
          FilledButton(onPressed: _calc, child: const Text('计算')),
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 16),
            SelectableText(_result, style: Theme.of(context).textTheme.titleMedium),
          ],
        ],
      ),
    );
  }
}
