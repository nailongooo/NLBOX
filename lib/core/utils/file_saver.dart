import 'dart:typed_data';

import 'file_saver_stub.dart'
    if (dart.library.io) 'file_saver_io.dart'
    if (dart.library.html) 'file_saver_web.dart' as impl;

/// 跨平台保存二进制文件：
/// - Web：触发浏览器下载
/// - Android / iOS / Windows / macOS / Linux：写入本地目录并尝试调用系统分享面板
/// 返回保存结果描述（例如文件路径），失败会抛出异常。
Future<String> saveBytesToDevice(Uint8List bytes, String filename) {
  return impl.saveBytesImpl(bytes, filename);
}
