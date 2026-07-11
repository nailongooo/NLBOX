import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/providers/settings_providers.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});
  @override
  ConsumerState<CalculatorScreen> createState() => _State();
}

class _State extends ConsumerState<CalculatorScreen> {
  String _expression = '';
  String _result = '0';

  static const _keys = [
    '7', '8', '9', '÷',
    '4', '5', '6', '×',
    '1', '2', '3', '−',
    'C', '0', '.', '+',
    '(', ')', '%', '=',
  ];

  void _onKey(String key) {
    if (key == 'C') {
      setState(() {
        _expression = '';
        _result = '0';
      });
      return;
    }
    if (key == '=') {
      _evaluate();
      return;
    }
    setState(() => _expression += key);
  }

  void _evaluate() {
    try {
      final normalized = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-')
          .replaceAll('%', '/100');
      final parser = Parser();
      final exp = parser.parse(normalized);
      final value = exp.evaluate(EvaluationType.REAL, ContextModel());
      setState(() => _result = _trim(value));
    } catch (_) {
      setState(() => _result = '表达式错误');
    }
  }

  String _trim(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(6).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ToolPageScaffold(
      toolId: 'date_calculator',
      titleKey: 'date_calculator',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: scheme.surfaceContainerHighest.withOpacity(0.4), borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_expression.isEmpty ? ' ' : _expression, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 16)),
                const SizedBox(height: 8),
                Text(_result, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.3),
            itemCount: _keys.length,
            itemBuilder: (_, i) {
              final k = _keys[i];
              final isOp = ['÷', '×', '−', '+', '='].contains(k);
              return FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: k == 'C'
                      ? scheme.errorContainer
                      : isOp
                          ? scheme.primaryContainer
                          : scheme.surfaceContainerHighest.withOpacity(0.5),
                  foregroundColor: k == 'C' ? scheme.onErrorContainer : (isOp ? scheme.onPrimaryContainer : scheme.onSurface),
                ),
                onPressed: () => _onKey(k),
                child: Text(k, style: const TextStyle(fontSize: 18)),
              );
            },
          ),
        ],
      ),
    );
  }
}
