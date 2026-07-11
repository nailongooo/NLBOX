import 'package:flutter/material.dart';
import '../models/tool_info.dart';

// 文本工具
import '../../features/tools/text/word_count_screen.dart';
import '../../features/tools/text/text_dedupe_screen.dart';
import '../../features/tools/text/text_sort_screen.dart';
import '../../features/tools/text/case_convert_screen.dart';
import '../../features/tools/text/chinese_convert_screen.dart';
import '../../features/tools/text/text_cipher_screen.dart';
import '../../features/tools/text/url_codec_screen.dart';
import '../../features/tools/text/base64_text_screen.dart';
import '../../features/tools/text/json_format_screen.dart';
import '../../features/tools/text/json_minify_screen.dart';
import '../../features/tools/text/markdown_preview_screen.dart';
import '../../features/tools/text/random_password_screen.dart';
import '../../features/tools/text/uuid_gen_screen.dart';

// 随机工具
import '../../features/tools/random/random_number_screen.dart';
import '../../features/tools/random/random_string_screen.dart';
import '../../features/tools/random/random_color_screen.dart';
import '../../features/tools/random/random_draw_screen.dart';
import '../../features/tools/random/random_group_screen.dart';
import '../../features/tools/random/random_picker_screen.dart';
import '../../features/tools/random/random_coin_screen.dart';
import '../../features/tools/random/random_dice_screen.dart';

// 日期与计算工具
import '../../features/tools/datecalc/timestamp_screen.dart';
import '../../features/tools/datecalc/date_diff_screen.dart';
import '../../features/tools/datecalc/age_calc_screen.dart';
import '../../features/tools/datecalc/countdown_screen.dart';
import '../../features/tools/datecalc/unit_convert_screen.dart';
import '../../features/tools/datecalc/bmi_screen.dart';
import '../../features/tools/datecalc/percentage_screen.dart';
import '../../features/tools/datecalc/base_convert_screen.dart';
import '../../features/tools/datecalc/calculator_screen.dart';

// 网络与开发工具
import '../../features/tools/dev/ip_lookup_screen.dart';
import '../../features/tools/dev/user_agent_screen.dart';
import '../../features/tools/dev/regex_tester_screen.dart';
import '../../features/tools/dev/hash_calc_screen.dart';
import '../../features/tools/dev/jwt_decode_screen.dart';
import '../../features/tools/dev/html_format_screen.dart';
import '../../features/tools/dev/css_format_screen.dart';
import '../../features/tools/dev/xml_format_screen.dart';
import '../../features/tools/dev/cron_builder_screen.dart';

// 图片工具
import '../../features/tools/image/image_to_base64_screen.dart';
import '../../features/tools/image/base64_to_image_screen.dart';
import '../../features/tools/image/image_compress_screen.dart';
import '../../features/tools/image/image_format_convert_screen.dart';
import '../../features/tools/image/image_resize_screen.dart';
import '../../features/tools/image/image_rotate_screen.dart';
import '../../features/tools/image/image_grayscale_screen.dart';
import '../../features/tools/image/qr_generate_screen.dart';

/// 全部工具的统一注册表。新增工具时只需要：
/// 1. 在 features/tools/<分类>/ 下新建一个页面文件
/// 2. 在上面 import 它
/// 3. 在下面的列表里加一行 ToolInfo
/// 首页分类、全部工具、搜索、收藏、历史都会自动读取这个列表，无需额外改动。
final List<ToolInfo> allTools = [
  // ---------------- 图片工具 ----------------
  ToolInfo(id: 'image_to_base64', category: ToolCategory.image, icon: Icons.data_object, titleKey: 'image_to_base64', builder: (_) => const ImageToBase64Screen()),
  ToolInfo(id: 'image_base64_to_image', category: ToolCategory.image, icon: Icons.image, titleKey: 'image_base64_to_image', builder: (_) => const Base64ToImageScreen()),
  ToolInfo(id: 'image_compress', category: ToolCategory.image, icon: Icons.compress, titleKey: 'image_compress', builder: (_) => const ImageCompressScreen()),
  ToolInfo(id: 'image_format_convert', category: ToolCategory.image, icon: Icons.transform, titleKey: 'image_format_convert', builder: (_) => const ImageFormatConvertScreen()),
  ToolInfo(id: 'image_resize', category: ToolCategory.image, icon: Icons.aspect_ratio, titleKey: 'image_resize', builder: (_) => const ImageResizeScreen()),
  ToolInfo(id: 'image_rotate', category: ToolCategory.image, icon: Icons.rotate_right, titleKey: 'image_rotate', builder: (_) => const ImageRotateScreen()),
  ToolInfo(id: 'image_grayscale', category: ToolCategory.image, icon: Icons.invert_colors, titleKey: 'image_grayscale', builder: (_) => const ImageGrayscaleScreen()),
  ToolInfo(id: 'image_qr_generate', category: ToolCategory.image, icon: Icons.qr_code, titleKey: 'image_qr_generate', builder: (_) => const QrGenerateScreen()),

  // ---------------- 文本工具 ----------------
  ToolInfo(id: 'text_word_count', category: ToolCategory.text, icon: Icons.short_text, titleKey: 'text_word_count', builder: (_) => const WordCountScreen()),
  ToolInfo(id: 'text_dedupe', category: ToolCategory.text, icon: Icons.filter_alt, titleKey: 'text_dedupe', builder: (_) => const TextDedupeScreen()),
  ToolInfo(id: 'text_sort', category: ToolCategory.text, icon: Icons.sort_by_alpha, titleKey: 'text_sort', builder: (_) => const TextSortScreen()),
  ToolInfo(id: 'text_case_convert', category: ToolCategory.text, icon: Icons.text_fields, titleKey: 'text_case_convert', builder: (_) => const CaseConvertScreen()),
  ToolInfo(id: 'text_chinese_convert', category: ToolCategory.text, icon: Icons.translate, titleKey: 'text_chinese_convert', builder: (_) => const ChineseConvertScreen()),
  ToolInfo(id: 'text_cipher', category: ToolCategory.text, icon: Icons.enhanced_encryption, titleKey: 'text_cipher', builder: (_) => const TextCipherScreen()),
  ToolInfo(id: 'text_url_codec', category: ToolCategory.text, icon: Icons.link, titleKey: 'text_url_codec', builder: (_) => const UrlCodecScreen()),
  ToolInfo(id: 'text_base64', category: ToolCategory.text, icon: Icons.code, titleKey: 'text_base64', builder: (_) => const Base64TextScreen()),
  ToolInfo(id: 'text_json_format', category: ToolCategory.text, icon: Icons.data_object, titleKey: 'text_json_format', builder: (_) => const JsonFormatScreen()),
  ToolInfo(id: 'text_json_minify', category: ToolCategory.text, icon: Icons.compress, titleKey: 'text_json_minify', builder: (_) => const JsonMinifyScreen()),
  ToolInfo(id: 'text_markdown_preview', category: ToolCategory.text, icon: Icons.article, titleKey: 'text_markdown_preview', builder: (_) => const MarkdownPreviewScreen()),
  ToolInfo(id: 'text_random_password', category: ToolCategory.text, icon: Icons.password, titleKey: 'text_random_password', builder: (_) => const RandomPasswordScreen()),
  ToolInfo(id: 'text_uuid', category: ToolCategory.text, icon: Icons.fingerprint, titleKey: 'text_uuid', builder: (_) => const UuidGenScreen()),

  // ---------------- 随机工具 ----------------
  ToolInfo(id: 'random_number', category: ToolCategory.random, icon: Icons.pin, titleKey: 'random_number', builder: (_) => const RandomNumberScreen()),
  ToolInfo(id: 'random_string', category: ToolCategory.random, icon: Icons.shuffle, titleKey: 'random_string', builder: (_) => const RandomStringScreen()),
  ToolInfo(id: 'random_color', category: ToolCategory.random, icon: Icons.palette, titleKey: 'random_color', builder: (_) => const RandomColorScreen()),
  ToolInfo(id: 'random_draw', category: ToolCategory.random, icon: Icons.emoji_events, titleKey: 'random_draw', builder: (_) => const RandomDrawScreen()),
  ToolInfo(id: 'random_group', category: ToolCategory.random, icon: Icons.groups, titleKey: 'random_group', builder: (_) => const RandomGroupScreen()),
  ToolInfo(id: 'random_picker', category: ToolCategory.random, icon: Icons.touch_app, titleKey: 'random_picker', builder: (_) => const RandomPickerScreen()),
  ToolInfo(id: 'random_coin', category: ToolCategory.random, icon: Icons.monetization_on, titleKey: 'random_coin', builder: (_) => const RandomCoinScreen()),
  ToolInfo(id: 'random_dice', category: ToolCategory.random, icon: Icons.casino, titleKey: 'random_dice', builder: (_) => const RandomDiceScreen()),

  // ---------------- 日期与计算 ----------------
  ToolInfo(id: 'date_timestamp', category: ToolCategory.dateCalc, icon: Icons.access_time, titleKey: 'date_timestamp', builder: (_) => const TimestampScreen()),
  ToolInfo(id: 'date_diff', category: ToolCategory.dateCalc, icon: Icons.date_range, titleKey: 'date_diff', builder: (_) => const DateDiffScreen()),
  ToolInfo(id: 'date_age', category: ToolCategory.dateCalc, icon: Icons.cake, titleKey: 'date_age', builder: (_) => const AgeCalcScreen()),
  ToolInfo(id: 'date_countdown', category: ToolCategory.dateCalc, icon: Icons.hourglass_bottom, titleKey: 'date_countdown', builder: (_) => const CountdownScreen()),
  ToolInfo(id: 'date_unit_convert', category: ToolCategory.dateCalc, icon: Icons.swap_horiz, titleKey: 'date_unit_convert', builder: (_) => const UnitConvertScreen()),
  ToolInfo(id: 'date_bmi', category: ToolCategory.dateCalc, icon: Icons.monitor_weight, titleKey: 'date_bmi', builder: (_) => const BmiScreen()),
  ToolInfo(id: 'date_percentage', category: ToolCategory.dateCalc, icon: Icons.percent, titleKey: 'date_percentage', builder: (_) => const PercentageScreen()),
  ToolInfo(id: 'date_base_convert', category: ToolCategory.dateCalc, icon: Icons.pin, titleKey: 'date_base_convert', builder: (_) => const BaseConvertScreen()),
  ToolInfo(id: 'date_calculator', category: ToolCategory.dateCalc, icon: Icons.calculate, titleKey: 'date_calculator', builder: (_) => const CalculatorScreen()),

  // ---------------- 网络与开发 ----------------
  ToolInfo(id: 'dev_ip', category: ToolCategory.dev, icon: Icons.public, titleKey: 'dev_ip', builder: (_) => const IpLookupScreen()),
  ToolInfo(id: 'dev_user_agent', category: ToolCategory.dev, icon: Icons.devices, titleKey: 'dev_user_agent', builder: (_) => const UserAgentScreen()),
  ToolInfo(id: 'dev_regex', category: ToolCategory.dev, icon: Icons.pattern, titleKey: 'dev_regex', builder: (_) => const RegexTesterScreen()),
  ToolInfo(id: 'dev_hash', category: ToolCategory.dev, icon: Icons.tag, titleKey: 'dev_hash', builder: (_) => const HashCalcScreen()),
  ToolInfo(id: 'dev_jwt', category: ToolCategory.dev, icon: Icons.vpn_key, titleKey: 'dev_jwt', builder: (_) => const JwtDecodeScreen()),
  ToolInfo(id: 'dev_html_format', category: ToolCategory.dev, icon: Icons.html, titleKey: 'dev_html_format', builder: (_) => const HtmlFormatScreen()),
  ToolInfo(id: 'dev_css_format', category: ToolCategory.dev, icon: Icons.css, titleKey: 'dev_css_format', builder: (_) => const CssFormatScreen()),
  ToolInfo(id: 'dev_xml_format', category: ToolCategory.dev, icon: Icons.code, titleKey: 'dev_xml_format', builder: (_) => const XmlFormatScreen()),
  ToolInfo(id: 'dev_cron', category: ToolCategory.dev, icon: Icons.schedule, titleKey: 'dev_cron', builder: (_) => const CronBuilderScreen()),
];

List<ToolInfo> toolsByCategory(ToolCategory category) => allTools.where((t) => t.category == category).toList();

ToolInfo? findTool(String id) {
  for (final t in allTools) {
    if (t.id == id) return t;
  }
  return null;
}
