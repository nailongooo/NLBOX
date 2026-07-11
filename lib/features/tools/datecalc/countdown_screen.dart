import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';

class CountdownScreen extends ConsumerStatefulWidget {
  const CountdownScreen({super.key});
  @override
  ConsumerState<CountdownScreen> createState() => _State();
}

class _State extends ConsumerState<CountdownScreen> {
  DateTime _target = DateTime.now().add(const Duration(days: 1));
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!mounted) return;
    setState(() => _remaining = _target.difference(DateTime.now()));
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(context: context, initialDate: _target, firstDate: DateTime(2000), lastDate: DateTime(2200));
    if (d == null) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_target));
    setState(() => _target = DateTime(d.year, d.month, d.day, t?.hour ?? 0, t?.minute ?? 0));
    _tick();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final neg = _remaining.isNegative;
    final abs = neg ? -_remaining : _remaining;
    final d = abs.inDays, h = abs.inHours % 24, m = abs.inMinutes % 60, s = abs.inSeconds % 60;
    return ToolPageScaffold(
      toolId: 'date_countdown',
      titleKey: 'date_countdown',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: const Text('目标时间'),
            subtitle: Text('${_target.year}-${_target.month.toString().padLeft(2, '0')}-${_target.day.toString().padLeft(2, '0')} '
                '${_target.hour.toString().padLeft(2, '0')}:${_target.minute.toString().padLeft(2, '0')}'),
            trailing: const Icon(Icons.event),
            onTap: _pickDate,
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Text(neg ? '已过去' : '剩余', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _unit('$d', '天'),
                    _unit('$h', '时'),
                    _unit('$m', '分'),
                    _unit('$s', '秒'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _unit(String v, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
          child: Text(v, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
