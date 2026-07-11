import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';

class RandomCoinScreen extends ConsumerStatefulWidget {
  const RandomCoinScreen({super.key});
  @override
  ConsumerState<RandomCoinScreen> createState() => _State();
}

class _State extends ConsumerState<RandomCoinScreen> with SingleTickerProviderStateMixin {
  final List<String> _history = [];
  String _current = '？';
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

  void _flip() {
    final result = Random().nextBool() ? '正面' : '反面';
    _controller.forward(from: 0);
    setState(() {
      _current = result;
      _history.insert(0, result);
      if (_history.length > 20) _history.removeLast();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'random_coin',
      titleKey: 'random_coin',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: RotationTransition(
              turns: _controller,
              child: Container(
                width: 140,
                height: 140,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Color(0xFFFFD54F), Color(0xFFFFA000)]),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 6))],
                ),
                child: Text(_current, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(child: FilledButton.icon(onPressed: _flip, icon: const Icon(Icons.monetization_on), label: const Text('抛硬币'))),
          if (_history.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('历史记录：${_history.join(' , ')}'),
          ],
        ],
      ),
    );
  }
}
