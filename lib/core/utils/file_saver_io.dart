import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// 非 Web 平台：写入本地目录（优先“下载”目录，桌面/移动均可），
/// 然后尝试弹出系统分享面板，方便用户另存到相册 / 其他 App / 文件管理器。
Future<String> saveBytesImpl(Uint8List bytes, String filename) async {
  Directory dir;
  try {
    dir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
  } catch (_) {
    dir = await getApplicationDocumentsDirectory();
  }
  final path = '${dir.path}${Platform.pathSeparator}$filename';
  final file = File(path);
  await file.writeAsBytes(bytes, flush: true);
  try {
    await Share.shareXFiles([XFile(path)], text: filename);
  } catch (_) {
    // 部分桌面平台可能不支持分享面板，忽略即可，文件已经保存成功
  }
  return path;
}
