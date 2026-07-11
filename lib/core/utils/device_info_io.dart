import 'dart:io';

Future<String> getDeviceInfoImpl() async {
  return [
    '运行平台：${Platform.operatingSystem}',
    '系统版本：${Platform.operatingSystemVersion}',
    'CPU 核心数：${Platform.numberOfProcessors}',
    'Dart 版本：${Platform.version.split(' ').first}',
    '本地语言环境：${Platform.localeName}',
  ].join('\n');
}
