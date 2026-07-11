import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/providers/settings_providers.dart';

class MarkdownPreviewScreen extends ConsumerStatefulWidget {
  const MarkdownPreviewScreen({super.key});
  @override
  ConsumerState<MarkdownPreviewScreen> createState() => _State();
}

class _State extends ConsumerState<MarkdownPreviewScreen> {
  final _ctrl = TextEditingController(text: '# 奶龙工具箱\n\n- 图片工具\n- 文本工具\n- **随机工具**\n\n> 一个装满小工具的口袋百宝箱');

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'text_markdown_preview',
      titleKey: 'text_markdown_preview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('编辑', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          TextField(controller: _ctrl, maxLines: 10, style: const TextStyle(fontFamily: 'monospace', fontSize: 13), onChanged: (_) => setState(() {})),
          const SizedBox(height: 16),
          Text('预览', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
            child: MarkdownBody(data: _ctrl.text, selectable: true),
          ),
        ],
      ),
    );
  }
}
