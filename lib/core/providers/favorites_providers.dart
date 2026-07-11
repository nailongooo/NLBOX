import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/local_storage_service.dart';
import 'settings_providers.dart';

/// 收藏的工具 id 集合，纯本地存储。
class FavoritesNotifier extends StateNotifier<Set<String>> {
  final LocalStorageService storage;
  FavoritesNotifier(this.storage) : super(storage.favorites.toSet());

  void toggle(String toolId) {
    final next = {...state};
    if (next.contains(toolId)) {
      next.remove(toolId);
    } else {
      next.add(toolId);
    }
    state = next;
    storage.setFavorites(next.toList());
  }

  bool isFavorite(String toolId) => state.contains(toolId);
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier(ref.watch(localStorageProvider));
});
