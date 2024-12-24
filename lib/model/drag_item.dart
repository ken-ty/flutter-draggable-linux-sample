import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:math';

part 'drag_item.freezed.dart';

/// ドラッグアイテムのデータクラス
@freezed
class DragItem with _$DragItem {
  static const defaultSize = Size(100, 60);
  const factory DragItem({
    required int id,
    required int index,
    required double x,
    required double y,
    @Default(0.0) double theta,
    @Default(DragItem.defaultSize) Size size,
  }) = _DragItem;
}

/// ドラッグアイテムの状態を管理するProvider
final dragItemsProvider =
    StateNotifierProvider<DragItemsNotifier, List<DragItem>>((ref) {
  debugPrint('Initializing DragItemsProvider');
  return DragItemsNotifier([]);
});

class DragItemsNotifier extends StateNotifier<List<DragItem>> {
  DragItemsNotifier(List<DragItem> state) : super(state);

  /// [index] のアイテムの位置を更新する
  void updateItem(int index, double dx, double dy) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(
            x: state[i].x + dx,
            y: state[i].y + dy,
          )
        else
          state[i]
    ];
  }

  /// [index] のアイテムの角度を [deltaTheta] だけ増加させる
  void incrementTheta(int index, double deltaTheta) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(theta: (state[i].theta + deltaTheta) % (2 * pi))
        else
          state[i]
    ];
  }

  /// 新しいアイテムを追加する
  void addItem() {
    debugPrint('Adding new item');
    final newId = state.isEmpty ? 0 : state.last.id + 1;
    final newIndex = state.length;
    final newX = 100.0 * (newId + 1);
    final newY = 100.0 * (newId + 1);
    state = [
      ...state,
      DragItem(
        id: newId,
        index: newIndex,
        x: newX,
        y: newY,
      ),
    ];
  }

  /// [id] のアイテムを削除する
  void removeItem(int id) {
    debugPrint('Removing item with id: $id');
    state = [
      for (final item in state)
        if (item.id != id)
          item.copyWith(index: state.indexOf(item)) // Recalculate indices
    ];
  }

  /// [id] のアイテムを前面に持ってくる
  void bringItemToFront(int id) {
    debugPrint('Bringing item with id: $id to front');
    final itemToBring = state.firstWhere((item) => item.id == id);
    state = [
      ...state
          .where((item) => item.id != id)
          .map((item) => item.copyWith(index: state.indexOf(item))),
      itemToBring.copyWith(index: state.length),
    ];
  }

  /// アイテムの順序を入れ替える
  void reorderItem(int oldIndex, int newIndex) {
    debugPrint('Reordering item from index $oldIndex to index $newIndex');
    int insertIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    final item = state.removeAt(oldIndex);
    state.insert(insertIndex, item);
    state = [
      for (int i = 0; i < state.length; i++) state[i].copyWith(index: i),
    ];
  }
}

/// 選択されたアイテムの状態を管理するProvider
///
/// key: アイテムのID, value: 選択されたかどうか
final selectedItemsProvider = StateProvider<Map<int, bool>>((ref) => {});
