import 'package:flutter/material.dart';

/// 工具分类
enum ToolCategory { image, text, random, dateCalc, dev }

extension ToolCategoryX on ToolCategory {
  /// 用于翻译字典查找的 key 前缀
  String get key {
    switch (this) {
      case ToolCategory.image:
        return 'cat_image';
      case ToolCategory.text:
        return 'cat_text';
      case ToolCategory.random:
        return 'cat_random';
      case ToolCategory.dateCalc:
        return 'cat_datecalc';
      case ToolCategory.dev:
        return 'cat_dev';
    }
  }

  IconData get icon {
    switch (this) {
      case ToolCategory.image:
        return Icons.image_outlined;
      case ToolCategory.text:
        return Icons.text_fields_outlined;
      case ToolCategory.random:
        return Icons.casino_outlined;
      case ToolCategory.dateCalc:
        return Icons.calculate_outlined;
      case ToolCategory.dev:
        return Icons.code_outlined;
    }
  }
}

/// 单个工具的元数据。titleKey 对应 AppText 翻译字典中的 key。
class ToolInfo {
  final String id;
  final ToolCategory category;
  final IconData icon;
  final String titleKey;
  final WidgetBuilder builder;

  const ToolInfo({
    required this.id,
    required this.category,
    required this.icon,
    required this.titleKey,
    required this.builder,
  });
}
