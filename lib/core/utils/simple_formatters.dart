/// 轻量级 HTML / CSS 格式化工具（基于简单规则的缩进格式化，非完整解析器）。
/// 适合快速美化压缩过的 HTML/CSS 代码，复杂/不规范的代码可能无法完美处理。
class SimpleFormatters {
  static const _voidTags = {
    'area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input',
    'link', 'meta', 'param', 'source', 'track', 'wbr'
  };

  static String formatHtml(String input) {
    final compact = input.replaceAll(RegExp(r'>\s+<'), '><').trim();
    final tokens = compact.split(RegExp(r'(?=<)|(?<=>)')).where((t) => t.isNotEmpty).toList();
    final buffer = StringBuffer();
    var indent = 0;
    for (final token in tokens) {
      if (token.trim().isEmpty) continue;
      if (token.startsWith('</')) {
        indent = (indent - 1).clamp(0, 999);
        buffer.writeln('${'  ' * indent}$token');
      } else if (token.startsWith('<') && !token.startsWith('<!')) {
        final tagName = RegExp(r'^<\s*([a-zA-Z0-9]+)').firstMatch(token)?.group(1)?.toLowerCase();
        final selfClose = token.endsWith('/>') || (tagName != null && _voidTags.contains(tagName));
        buffer.writeln('${'  ' * indent}$token');
        if (!selfClose) indent++;
      } else {
        buffer.writeln('${'  ' * indent}${token.trim()}');
      }
    }
    return buffer.toString().trim();
  }

  static String formatCss(String input) {
    final compact = input.replaceAll(RegExp(r'\s+'), ' ').trim();
    final buffer = StringBuffer();
    var indent = 0;
    for (var i = 0; i < compact.length; i++) {
      final ch = compact[i];
      if (ch == '{') {
        buffer.write(' {\n');
        indent++;
        buffer.write('  ' * indent);
      } else if (ch == '}') {
        indent = (indent - 1).clamp(0, 999);
        buffer.write('\n${'  ' * indent}}\n${'  ' * indent}');
      } else if (ch == ';') {
        buffer.write(';\n${'  ' * indent}');
      } else {
        buffer.write(ch);
      }
    }
    return buffer.toString().replaceAll(RegExp(r'[ \t]+\n'), '\n').replaceAll(RegExp(r'\n{2,}'), '\n').trim();
  }
}
