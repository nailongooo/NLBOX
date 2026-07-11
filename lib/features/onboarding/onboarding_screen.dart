import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/settings_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final VoidCallback onFinish;
  const OnboardingScreen({super.key, required this.onFinish});
  @override
  ConsumerState<OnboardingScreen> createState() => _State();
}

class _State extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _icons = [Icons.waving_hand, Icons.lock_outline, Icons.favorite_border];
  static const _titleKeys = ['onboarding_title_1', 'onboarding_title_2', 'onboarding_title_3'];
  static const _descKeys = ['onboarding_desc_1', 'onboarding_desc_2', 'onboarding_desc_3'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(onPressed: widget.onFinish, child: Text(ref.tr('onboarding_skip'))),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: 3,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
                        child: Icon(_icons[i], size: 56, color: scheme.onPrimaryContainer),
                      ),
                      const SizedBox(height: 32),
                      Text(ref.tr(_titleKeys[i]), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      Text(ref.tr(_descKeys[i]), style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == i ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _page == i ? scheme.primary : scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_page == 2) {
                      widget.onFinish();
                    } else {
                      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                    }
                  },
                  child: Text(_page == 2 ? ref.tr('onboarding_start') : ref.tr('onboarding_next')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
