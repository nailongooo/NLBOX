import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class AgeCalcScreen extends ConsumerStatefulWidget {
  const AgeCalcScreen({super.key});
  @override
  ConsumerState<AgeCalcScreen> createState() => _State();
}

class _State extends ConsumerState<AgeCalcScreen> {
  DateTime _birth = DateTime(2000, 1, 1);
  String _result = '';

  Future<void> _pick() async {
    final d = await showDatePicker(context: context, initialDate: _birth, firstDate: DateTime(1900), lastDate: DateTime.now());
    if (d != null) setState(() => _birth = d);
  }

  void _calc() {
    final now = DateTime.now();
    var years = now.year - _birth.year;
    var months = now.month - _birth.month;
    var days = now.day - _birth.day;
    if (days < 0) {
      months -= 1;
      final prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    var nextBirthday = DateTime(now.year, _birth.month, _birth.day);
    if (nextBirthday.isBefore(now)) nextBirthday = DateTime(now.year + 1, _birth.month, _birth.day);
    final daysToNext = nextBirthday.difference(DateTime(now.year, now.month, now.day)).inDays;
    setState(() => _result = '$years 岁 $months 个月 $days 天\n距离下一个生日还有 $daysToNext 天');
  }

  String _fmt(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'date_age',
      titleKey: 'date_age',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(title: const Text('出生日期'), subtitle: Text(_fmt(_birth)), trailing: const Icon(Icons.cake), onTap: _pick),
          const SizedBox(height: 12),
          FilledButton(onPressed: _calc, child: const Text('计算年龄')),
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
