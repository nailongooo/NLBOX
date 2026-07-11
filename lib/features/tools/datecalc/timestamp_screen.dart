import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class TimestampScreen extends ConsumerStatefulWidget {
  const TimestampScreen({super.key});
  @override
  ConsumerState<TimestampScreen> createState() => _State();
}

class _State extends ConsumerState<TimestampScreen> {
  final _tsCtrl = TextEditingController(text: (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString());
  bool _isMillis = false;
  String _dateResult = '';

  final _dateCtrl = TextEditingController();
  String _tsResult = '';

  void _toDate() {
    final raw = int.tryParse(_tsCtrl.text.trim());
    if (raw == null) {
      setState(() => _dateResult = '请输入合法的时间戳');
      return;
    }
    final millis = _isMillis ? raw : raw * 1000;
    final dt = DateTime.fromMillisecondsSinceEpoch(millis);
    final utc = dt.toUtc();
    setState(() => _dateResult = '本地时间：${_fmt(dt)}\nUTC 时间：${_fmt(utc)}');
  }

  String _fmt(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}';

  void _toTimestamp() {
    try {
      final dt = DateTime.parse(_dateCtrl.text.trim().replaceFirst(' ', 'T'));
      setState(() => _tsResult = '秒：${dt.millisecondsSinceEpoch ~/ 1000}\n毫秒：${dt.millisecondsSinceEpoch}');
    } catch (_) {
      setState(() => _tsResult = '日期格式应为 2026-01-01 12:00:00');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'date_timestamp',
      titleKey: 'date_timestamp',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('时间戳 → 日期', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(controller: _tsCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '时间戳')),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('单位为毫秒（关闭则为秒）'), value: _isMillis, onChanged: (v) => setState(() => _isMillis = v)),
          FilledButton(onPressed: _toDate, child: const Text('转换为日期')),
          if (_dateResult.isNotEmpty) ...[
            const SizedBox(height: 8),
            SelectableText(_dateResult),
            ResultActionsBar(copyText: _dateResult),
          ],
          const Divider(height: 40),
          Text('日期 → 时间戳', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(controller: _dateCtrl, decoration: const InputDecoration(labelText: '日期', hintText: '2026-01-01 12:00:00')),
          const SizedBox(height: 8),
          FilledButton(onPressed: _toTimestamp, child: const Text('转换为时间戳')),
          if (_tsResult.isNotEmpty) ...[
            const SizedBox(height: 8),
            SelectableText(_tsResult),
            ResultActionsBar(copyText: _tsResult),
          ],
        ],
      ),
    );
  }
}
