import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/providers/settings_providers.dart';

class BmiScreen extends ConsumerStatefulWidget {
  const BmiScreen({super.key});
  @override
  ConsumerState<BmiScreen> createState() => _State();
}

class _State extends ConsumerState<BmiScreen> {
  final _heightCtrl = TextEditingController(text: '170');
  final _weightCtrl = TextEditingController(text: '60');
  String _result = '';
  Color? _color;

  void _calc() {
    final h = (double.tryParse(_heightCtrl.text) ?? 0) / 100;
    final w = double.tryParse(_weightCtrl.text) ?? 0;
    if (h <= 0 || w <= 0) return;
    final bmi = w / (h * h);
    String category;
    Color color;
    if (bmi < 18.5) {
      category = '偏瘦';
      color = Colors.blue;
    } else if (bmi < 24) {
      category = '正常';
      color = Colors.green;
    } else if (bmi < 28) {
      category = '偏胖';
      color = Colors.orange;
    } else {
      category = '肥胖';
      color = Colors.red;
    }
    setState(() {
      _result = 'BMI = ${bmi.toStringAsFixed(1)}（$category）';
      _color = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'date_bmi',
      titleKey: 'date_bmi',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _heightCtrl, decoration: const InputDecoration(labelText: '身高（cm）'), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          TextField(controller: _weightCtrl, decoration: const InputDecoration(labelText: '体重（kg）'), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          FilledButton(onPressed: _calc, child: const Text('计算 BMI')),
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: _color?.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
                child: Text(_result, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _color)),
              ),
            ),
            const SizedBox(height: 8),
            const Text('参考标准（成人）：<18.5 偏瘦，18.5-24 正常，24-28 偏胖，≥28 肥胖', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ],
      ),
    );
  }
}
