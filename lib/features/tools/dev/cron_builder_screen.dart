import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class CronBuilderScreen extends ConsumerStatefulWidget {
  const CronBuilderScreen({super.key});
  @override
  ConsumerState<CronBuilderScreen> createState() => _State();
}

class _State extends ConsumerState<CronBuilderScreen> {
  final _minuteCtrl = TextEditingController(text: '*');
  final _hourCtrl = TextEditingController(text: '*');
  final _domCtrl = TextEditingController(text: '*');
  final _monthCtrl = TextEditingController(text: '*');
  final _dowCtrl = TextEditingController(text: '*');

  String get _expression => '${_minuteCtrl.text} ${_hourCtrl.text} ${_domCtrl.text} ${_monthCtrl.text} ${_dowCtrl.text}';

  void _setPreset(String minute, String hour, String dom, String month, String dow) {
    setState(() {
      _minuteCtrl.text = minute;
      _hourCtrl.text = hour;
      _domCtrl.text = dom;
      _monthCtrl.text = month;
      _dowCtrl.text = dow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'dev_cron',
      titleKey: 'dev_cron',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('常用预设：'),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            ActionChip(label: const Text('每分钟'), onPressed: () => _setPreset('*', '*', '*', '*', '*')),
            ActionChip(label: const Text('每小时整点'), onPressed: () => _setPreset('0', '*', '*', '*', '*')),
            ActionChip(label: const Text('每天 0 点'), onPressed: () => _setPreset('0', '0', '*', '*', '*')),
            ActionChip(label: const Text('每周一 9 点'), onPressed: () => _setPreset('0', '9', '*', '*', '1')),
            ActionChip(label: const Text('每月 1 号 0 点'), onPressed: () => _setPreset('0', '0', '1', '*', '*')),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: TextField(controller: _minuteCtrl, decoration: const InputDecoration(labelText: '分钟 0-59'))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: _hourCtrl, decoration: const InputDecoration(labelText: '小时 0-23'))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: _domCtrl, decoration: const InputDecoration(labelText: '日 1-31'))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: _monthCtrl, decoration: const InputDecoration(labelText: '月 1-12'))),
          ]),
          const SizedBox(height: 12),
          TextField(controller: _dowCtrl, decoration: const InputDecoration(labelText: '星期 0-6（0=周日）')),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(14)),
                  child: Text(_expression, style: const TextStyle(fontSize: 20, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                ResultActionsBar(copyText: _expression),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
