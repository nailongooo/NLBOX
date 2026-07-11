import 'device_info_stub.dart'
    if (dart.library.io) 'device_info_io.dart'
    if (dart.library.html) 'device_info_web.dart' as impl;

/// 跨平台读取设备 / 浏览器基本信息（不涉及任何隐私上传，只在本机展示）。
Future<String> getDeviceInfo() => impl.getDeviceInfoImpl();
