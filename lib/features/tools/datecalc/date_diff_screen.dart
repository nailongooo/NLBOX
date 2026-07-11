import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class DateDiffScreen extends ConsumerStatefulWidget {
  const DateDiffScreen({super.key});
  @override
  ConsumerState<DateDiffScreen> createState() => _State();
}

class _State extends ConsumerState<DateDiffScreen> {
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now().add(const Duration(days: 30));
  String _result = '';

  Future<void> _pick(bool isStart) async {
    final d = await showDatePicker(
      context: context,
      initialDate: isStart ? _start : _end,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (d != null) {
      setState(() => isStart ? _start = d : _end = d);
    }
  }

  void _calc() {
    final diff = _end.difference(_start);
    final days = diff.inDays;
    final weeks = (days / 7).toStringAsFixed(1);
    final years = (days / 365.25).toStringAsFixed(2);
    setState(() => _result = '相差 $days 天\n约 $weeks 周\n约 $years 年');
  }

  String _fmt(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'date_diff',
      titleKey: 'date_diff',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(title: const Text('开始日期'), subtitle: Text(_fmt(_start)), trailing: const Icon(Icons.edit_calendar), onTap: () => _pick(true)),
          ListTile(title: const Text('结束日期'), subtitle: Text(_fmt(_end)), trailing: const Icon(Icons.edit_calendar), onTap: () => _pick(false)),
          const SizedBox(height: 12),
          FilledButton(onPressed: _calc, child: const Text('计算间隔')),
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 16),
            SelectableText(_result, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: _result),
          ],
        ],
      ),
    );
  }
}
