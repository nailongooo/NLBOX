import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/providers/settings_providers.dart';

class _UnitCategory {
  final String name;
  final Map<String, double> unitsToBase; // 相对基准单位的换算系数
  const _UnitCategory(this.name, this.unitsToBase);
}

final _categories = <_UnitCategory>[
  const _UnitCategory('长度', {'毫米': 0.001, '厘米': 0.01, '米': 1, '千米': 1000, '英寸': 0.0254, '英尺': 0.3048, '码': 0.9144, '英里': 1609.344}),
  const _UnitCategory('重量', {'毫克': 0.000001, '克': 0.001, '千克': 1, '吨': 1000, '磅': 0.453592, '盎司': 0.0283495}),
  const _UnitCategory('面积', {'平方米': 1, '平方千米': 1000000, '公顷': 10000, '亩': 666.667, '平方英尺': 0.092903}),
  const _UnitCategory('体积', {'毫升': 0.001, '升': 1, '立方米': 1000, '加仑(美)': 3.78541}),
  const _UnitCategory('速度', {'米/秒': 1, '千米/小时': 0.277778, '英里/小时': 0.44704, '节': 0.514444}),
];

class UnitConvertScreen extends ConsumerStatefulWidget {
  const UnitConvertScreen({super.key});
  @override
  ConsumerState<UnitConvertScreen> createState() => _State();
}

class _State extends ConsumerState<UnitConvertScreen> {
  int _catIndex = 0;
  late String _from = _categories[0].unitsToBase.keys.first;
  late String _to = _categories[0].unitsToBase.keys.elementAt(1);
  final _valueCtrl = TextEditingController(text: '1');
  bool _isTemperature = false;
  String _result = '';

  void _convert() {
    final cat = _categories[_catIndex];
    final v = double.tryParse(_valueCtrl.text) ?? 0;
    final base = v * cat.unitsToBase[_from]!;
    final result = base / cat.unitsToBase[_to]!;
    setState(() => _result = '$v $_from = ${result.toStringAsFixed(6).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '')} $_to');
  }

  void _convertTemperature() {
    final v = double.tryParse(_valueCtrl.text) ?? 0;
    double celsius;
    switch (_from) {
      case '摄氏度':
        celsius = v;
        break;
      case '华氏度':
        celsius = (v - 32) * 5 / 9;
        break;
      default: // 开尔文
        celsius = v - 273.15;
    }
    double out;
    switch (_to) {
      case '摄氏度':
        out = celsius;
        break;
      case '华氏度':
        out = celsius * 9 / 5 + 32;
        break;
      default:
        out = celsius + 273.15;
    }
    setState(() => _result = '$v $_from = ${out.toStringAsFixed(2)} $_to');
  }

  @override
  Widget build(BuildContext context) {
    final tempUnits = ['摄氏度', '华氏度', '开尔文'];
    return ToolPageScaffold(
      toolId: 'date_unit_convert',
      titleKey: 'date_unit_convert',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            children: [
              ..._categories.asMap().entries.map((e) => ChoiceChip(
                    label: Text(e.value.name),
                    selected: !_isTemperature && _catIndex == e.key,
                    onSelected: (_) => setState(() {
                      _isTemperature = false;
                      _catIndex = e.key;
                      _from = _categories[_catIndex].unitsToBase.keys.first;
                      _to = _categories[_catIndex].unitsToBase.keys.elementAt(1);
                      _result = '';
                    }),
                  )),
              ChoiceChip(
                label: const Text('温度'),
                selected: _isTemperature,
                onSelected: (_) => setState(() {
                  _isTemperature = true;
                  _from = tempUnits[0];
                  _to = tempUnits[1];
                  _result = '';
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(controller: _valueCtrl, keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true), decoration: const InputDecoration(labelText: '数值')),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _from,
                items: (_isTemperature ? tempUnits : _categories[_catIndex].unitsToBase.keys.toList())
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (v) => setState(() => _from = v!),
                decoration: const InputDecoration(labelText: '从'),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.arrow_forward)),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _to,
                items: (_isTemperature ? tempUnits : _categories[_catIndex].unitsToBase.keys.toList())
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (v) => setState(() => _to = v!),
                decoration: const InputDecoration(labelText: '到'),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          FilledButton(onPressed: _isTemperature ? _convertTemperature : _convert, child: const Text('转换')),
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 16),
            SelectableText(_result, style: Theme.of(context).textTheme.titleMedium),
          ],
        ],
      ),
    );
  }
}
