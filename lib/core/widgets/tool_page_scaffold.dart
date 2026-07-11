import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_providers.dart';
import '../providers/history_providers.dart';
import '../providers/settings_providers.dart';

/// 所有工具页面的统一外壳：
/// - 自动记录使用历史
/// - 右上角收藏按钮
/// - 统一的滚动 + 内边距
/// - 简单工具用 [child]；步骤式复杂工具（如图片处理）也可以直接把分区 Widget 放进 child。
class ToolPageScaffold extends ConsumerStatefulWidget {
  final String toolId;
  final String titleKey;
  final Widget child;
  final List<Widget>? extraActions;
  final bool offlineBadge; // true=本地处理徽章，false=需要联网徽章，null=不显示
  final bool? showNetworkBadge;

  const ToolPageScaffold({
    super.key,
    required this.toolId,
    required this.titleKey,
    required this.child,
    this.extraActions,
    this.offlineBadge = true,
    this.showNetworkBadge,
  });

  @override
  ConsumerState<ToolPageScaffold> createState() => _ToolPageScaffoldState();
}

class _ToolPageScaffoldState extends ConsumerState<ToolPageScaffold> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(historyProvider.notifier).record(widget.toolId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(widget.toolId);
    final title = ref.tr(widget.titleKey);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ...?widget.extraActions,
          IconButton(
            tooltip: isFav ? ref.tr('common_delete') : ref.tr('common_add'),
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.redAccent : null),
            onPressed: () => ref.read(favoritesProvider.notifier).toggle(widget.toolId),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: (widget.showNetworkBadge == true
                            ? scheme.errorContainer
                            : scheme.secondaryContainer)
                        .withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.showNetworkBadge == true
                        ? ref.tr('common_online_badge')
                        : ref.tr('common_offline_badge'),
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.showNetworkBadge == true
                          ? scheme.onErrorContainer
                          : scheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}
