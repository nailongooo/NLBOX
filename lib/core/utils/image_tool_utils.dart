import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;

class PickedImage {
  final Uint8List bytes;
  final String name;
  PickedImage(this.bytes, this.name);
}

/// 跨平台选择一张图片，直接拿到字节数组（Web 也可用）。
Future<PickedImage?> pickImageBytes() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    withData: true,
  );
  if (result == null || result.files.isEmpty) return null;
  final file = result.files.first;
  if (file.bytes == null) return null;
  return PickedImage(file.bytes!, file.name);
}

/// 将字节数展示为易读的大小文本
String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
}

/// 超大文件阈值（20MB），超过给出提示但仍允许继续处理
const int kLargeFileThresholdBytes = 20 * 1024 * 1024;

// ---------------------------------------------------------------------------
// 以下函数用于配合 Flutter 的 compute()，把耗时的图片解码/编码放到后台 isolate
// 执行，避免处理大图片时界面卡顿。函数必须是顶层函数（不能是闭包），
// 参数类型必须可以跨 isolate 传递。
// ---------------------------------------------------------------------------

class CompressParams {
  final Uint8List bytes;
  final int quality; // 1-100
  CompressParams(this.bytes, this.quality);
}

Uint8List compressImageIsolate(CompressParams p) {
  final image = _decodeOrThrow(p.bytes);
  return Uint8List.fromList(img.encodeJpg(image, quality: p.quality));
}

enum TargetFormat { png, jpg, bmp }

class FormatConvertParams {
  final Uint8List bytes;
  final TargetFormat target;
  final int quality;
  FormatConvertParams(this.bytes, this.target, {this.quality = 92});
}

Uint8List convertFormatIsolate(FormatConvertParams p) {
  final image = _decodeOrThrow(p.bytes);
  switch (p.target) {
    case TargetFormat.png:
      return Uint8List.fromList(img.encodePng(image));
    case TargetFormat.jpg:
      return Uint8List.fromList(img.encodeJpg(image, quality: p.quality));
    case TargetFormat.bmp:
      return Uint8List.fromList(img.encodeBmp(image));
  }
}

class ResizeParams {
  final Uint8List bytes;
  final int width;
  final int? height;
  ResizeParams(this.bytes, this.width, this.height);
}

Uint8List resizeImageIsolate(ResizeParams p) {
  final image = _decodeOrThrow(p.bytes);
  final resized = img.copyResize(image, width: p.width, height: p.height);
  final isPng = _looksLikePng(p.bytes);
  return Uint8List.fromList(isPng ? img.encodePng(resized) : img.encodeJpg(resized, quality: 92));
}

class RotateParams {
  final Uint8List bytes;
  final int angle;
  RotateParams(this.bytes, this.angle);
}

Uint8List rotateImageIsolate(RotateParams p) {
  final image = _decodeOrThrow(p.bytes);
  final rotated = img.copyRotate(image, angle: p.angle);
  final isPng = _looksLikePng(p.bytes);
  return Uint8List.fromList(isPng ? img.encodePng(rotated) : img.encodeJpg(rotated, quality: 92));
}

Uint8List grayscaleImageIsolate(Uint8List bytes) {
  final image = _decodeOrThrow(bytes);
  final gray = img.grayscale(image);
  final isPng = _looksLikePng(bytes);
  return Uint8List.fromList(isPng ? img.encodePng(gray) : img.encodeJpg(gray, quality: 92));
}

img.Image _decodeOrThrow(Uint8List bytes) {
  final image = img.decodeImage(bytes);
  if (image == null) {
    throw Exception('无法识别该图片格式');
  }
  return image;
}

bool _looksLikePng(Uint8List bytes) {
  return bytes.length > 4 && bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47;
}
