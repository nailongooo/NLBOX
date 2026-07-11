import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/settings_providers.dart';
import '../utils/file_saver.dart';

/// 通用的“复制 / 保存 / 分享”操作栏，各工具结果区域统一复用。
class ResultActionsBar extends ConsumerWidget {
  final String? copyText; // 提供则显示“复制”按钮
  final String? shareText; // 提供则显示“分享文字”按钮
  final Uint8List? fileBytes; // 提供则显示“保存”按钮（连同 fileName）
  final String? fileName;

  const ResultActionsBar({
    super.key,
    this.copyText,
    this.shareText,
    this.fileBytes,
    this.fileName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttons = <Widget>[];

    if (copyText != null && copyText!.isNotEmpty) {
      buttons.add(FilledButton.tonalIcon(
        icon: const Icon(Icons.copy_rounded, size: 18),
        label: Text(ref.tr('common_copy')),
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: copyText!));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(ref.tr('common_copied'))),
            );
          }
        },
      ));
    }

    if (fileBytes != null && fileName != null) {
      buttons.add(FilledButton.icon(
        icon: const Icon(Icons.download_rounded, size: 18),
        label: Text(ref.tr('common_save')),
        onPressed: () async {
          try {
            await saveBytesToDevice(fileBytes!, fileName!);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(ref.tr('common_saved'))),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${ref.tr('common_error')}: $e')),
              );
            }
          }
        },
      ));
    }

    if (shareText != null && shareText!.isNotEmpty) {
      buttons.add(OutlinedButton.icon(
        icon: const Icon(Icons.ios_share_rounded, size: 18),
        label: Text(ref.tr('common_share')),
        onPressed: () => Share.share(shareText!),
      ));
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: 10, runSpacing: 10, children: buttons);
  }
}
