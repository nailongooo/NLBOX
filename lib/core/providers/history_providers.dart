import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/local_storage_service.dart';
import 'settings_providers.dart';

class HistoryEntry {
  final String toolId;
  final DateTime time;
  HistoryEntry(this.toolId, this.time);

  String encode() => '$toolId|${time.millisecondsSinceEpoch}';

  static HistoryEntry? decode(String raw) {
    final parts = raw.split('|');
    if (parts.length != 2) return null;
    final millis = int.tryParse(parts[1]);
    if (millis == null) return null;
    return HistoryEntry(parts[0], DateTime.fromMillisecondsSinceEpoch(millis));
  }
}

/// 使用历史，最多保留 200 条，仅保存在本机。
class HistoryNotifier extends StateNotifier<List<HistoryEntry>> {
  final LocalStorageService storage;
  static const _maxEntries = 200;

  HistoryNotifier(this.storage)
      : super(storage.historyRaw
            .map(HistoryEntry.decode)
            .whereType<HistoryEntry>()
            .toList());

  void record(String toolId) {
    final next = [HistoryEntry(toolId, DateTime.now()), ...state];
    if (next.length > _maxEntries) next.removeRange(_maxEntries, next.length);
    state = next;
    storage.setHistoryRaw(next.map((e) => e.encode()).toList());
  }

  void clear() {
    state = [];
    storage.setHistoryRaw([]);
  }

  /// 最近使用的工具 id（去重，按时间倒序）
  List<String> recentToolIds({int limit = 8}) {
    final seen = <String>{};
    final result = <String>[];
    for (final e in state) {
      if (seen.add(e.toolId)) {
        result.add(e.toolId);
        if (result.length >= limit) break;
      }
    }
    return result;
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, List<HistoryEntry>>((ref) {
  return HistoryNotifier(ref.watch(localStorageProvider));
});
