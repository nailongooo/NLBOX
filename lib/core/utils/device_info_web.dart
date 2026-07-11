// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

Future<String> getDeviceInfoImpl() async {
  final nav = html.window.navigator;
  return [
    'User-Agent：${nav.userAgent}',
    '平台：${nav.platform ?? '-'}',
    '语言：${nav.language ?? '-'}',
    '在线状态：${nav.onLine == true ? '在线' : '离线'}',
  ].join('\n');
}
