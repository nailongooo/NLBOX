import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

class RandomColorScreen extends ConsumerStatefulWidget {
  const RandomColorScreen({super.key});
  @override
  ConsumerState<RandomColorScreen> createState() => _State();
}

class _State extends ConsumerState<RandomColorScreen> {
  List<Color> _colors = [];

  void _generate() {
    final rand = Random();
    setState(() {
      _colors = List.generate(8, (_) => Color.fromARGB(255, rand.nextInt(256), rand.nextInt(256), rand.nextInt(256)));
    });
  }

  String _hex(Color c) => '#${c.value.toRadixString(16).substring(2).toUpperCase()}';
  String _rgb(Color c) => 'rgb(${c.red}, ${c.green}, ${c.blue})';

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'random_color',
      titleKey: 'random_color',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(onPressed: _generate, icon: const Icon(Icons.palette), label: Text(ref.tr('common_generate'))),
          const SizedBox(height: 16),
          if (_colors.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 2.4),
              itemCount: _colors.length,
              itemBuilder: (_, i) {
                final c = _colors[i];
                return Container(
                  decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_hex(c), style: TextStyle(color: c.computeLuminance() > 0.5 ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                      Text(_rgb(c), style: TextStyle(color: c.computeLuminance() > 0.5 ? Colors.black87 : Colors.white70, fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          if (_colors.isNotEmpty) ...[
            const SizedBox(height: 12),
            ResultActionsBar(copyText: _colors.map(_hex).join(', ')),
          ],
        ],
      ),
    );
  }
}
