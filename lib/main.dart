import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:math';

part 'main.freezed.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const title = 'Drag and Drop Example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: ExampleScreen(),
    );
  }
}

/// メイン画面
class ExampleScreen extends ConsumerWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final notifier = ref.read(dragItemsProvider.notifier);
              notifier.addItem();
            },
          ),
        ],
      ),
      body: Row(
        children: [
          SizedBox(width: 400, child: _ReorderableControlsListView()),
          // Flexible で画面いっぱいに広がるようにする
          Flexible(child: const DragDropExample()),
        ],
      ),
    );
  }
}

/// 選択されたアイテムの状態を管理するProvider
///
/// key: アイテムのID, value: 選択されたかどうか
final selectedItemsProvider = StateProvider<Map<int, bool>>((ref) => {});

/// リストビューのアイテムを表示するウィジェット
class _ReorderableControlsListView extends ConsumerWidget {
  const _ReorderableControlsListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(dragItemsProvider);
    final selectedItems = ref.watch(selectedItemsProvider);
    final selectedNotifier = ref.read(selectedItemsProvider.notifier);
    final notifier = ref.read(dragItemsProvider.notifier);

    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        if (newIndex > oldIndex) newIndex -= 1;
        notifier.reorderItem(oldIndex, newIndex);
      },
      children: [
        for (int index = 0; index < items.length; index++)
          ListTile(
            key: ValueKey(items[index].id),
            leading: CircleAvatar(
              backgroundColor: (selectedItems[items[index].id] ?? false)
                  ? Colors.blue
                  : Colors.primaries[items[index].id % Colors.primaries.length],
              child: Text('${items[index].id + 1}'),
            ),
            title: Text('Item ${items[index].id + 1}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.rotate_left),
                  onPressed: () => notifier.incrementTheta(index, -pi / 18),
                ),
                IconButton(
                  icon: const Icon(Icons.rotate_right),
                  onPressed: () => notifier.incrementTheta(index, pi / 18),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => notifier.removeItem(items[index].id),
                ),
              ],
            ),
            onTap: () {
              debugPrint('Tapped on item with id: ${items[index].id}');
              notifier.bringItemToFront(items[index].id);
              selectedNotifier.update((state) => {
                    ...state,
                    items[index].id: !(state[items[index].id] ?? false),
                  });
            },
          ),
      ],
    );
  }
}

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
    final item = state.removeAt(oldIndex);
    state.insert(newIndex, item);
    state = [
      for (int i = 0; i < state.length; i++) state[i].copyWith(index: i),
    ];
  }
}

/// ワークデスクのデータクラス
@freezed
class WorkDesk with _$WorkDesk {
  static const defaultSize = Size(400, 400);
  const factory WorkDesk({
    required int id,
    required double x,
    required double y,
    @Default(WorkDesk.defaultSize) Size size,
  }) = _WorkDesk;
}

/// ドラッグアイテムのウィジェット
class DragDropExample extends ConsumerWidget {
  const DragDropExample({Key? key}) : super(key: key);

  /// スケールファクターを計算します
  ///
  /// Layout された Widget のサイズに合わせてスケーリングするための係数を計算する.
  /// FittedBox のような挙動を Drag and Drop のウィジェットに適用するために使用する為.
  double _caluculateScaleFactor(Size baseSize, BoxConstraints constraints) {
    final widthScaleFactor = constraints.biggest.width / baseSize.width;
    final heightScaleFactor = constraints.biggest.height / baseSize.height;
    // 画面で見きれないよう小さい値を採用する
    final scaleFactor = min(widthScaleFactor, heightScaleFactor);
    return scaleFactor;
  }

  /// サイズをスケーリングします
  ///
  /// baseSize に scaleFactor を掛けたサイズを計算します
  Size _scaleSize(Size baseSize, double scaleFactor) {
    return Size(baseSize.width * scaleFactor, baseSize.height * scaleFactor);
  }

  /// ワークデスクの相対サイズを取得します
  Size _getRelativeWorkDeskSize(BoxConstraints constraints) {
    final baseSize = WorkDesk.defaultSize;
    final scaleFactor = _caluculateScaleFactor(baseSize, constraints);
    return _scaleSize(baseSize, scaleFactor);
  }

  /// アイテムの相対サイズを取得します
  Size _getRelativeItemSize(Size itemAbsoluteSize, BoxConstraints constraints) {
    // ワークデスクとサイズ感を合わせたいので ワークデスクのサイズを基準にスケーリングする。
    final workBaseSize = WorkDesk.defaultSize;
    final scaleFactor = _caluculateScaleFactor(workBaseSize, constraints);

    final relativeItemSize = Size(
      itemAbsoluteSize.width * scaleFactor,
      itemAbsoluteSize.height * scaleFactor,
    );
    return relativeItemSize;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dragItems = ref.watch(dragItemsProvider);
    final dragItemsNotifier = ref.read(dragItemsProvider.notifier);
    final selectedItems = ref.watch(selectedItemsProvider);
    final selectedNotifier = ref.read(selectedItemsProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final workDeskSize = _getRelativeWorkDeskSize(constraints);
        return Stack(
          children: [
            // 背景
            Positioned.fill(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey,
              ),
            ),
            // ワークデスク
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Container(
                    width: workDeskSize.width,
                    height: workDeskSize.height,
                    color: Colors.brown,
                  ),
                ),
              ),
            ),
            // ドラッグアイテム
            ...List.generate(dragItems.length, (index) {
              return Positioned(
                left: dragItems[index].x,
                top: dragItems[index].y,
                child: GestureDetector(
                  onPanStart: (_) {
                    // ドラッグ開始
                    debugPrint(
                      'Drag started on item with id: ${dragItems[index].id}',
                    );
                  },
                  onPanUpdate: (details) {
                    debugPrint(
                      'Item moved by dx: ${details.delta.dx}, dy: ${details.delta.dy}',
                    );
                    dragItemsNotifier.updateItem(
                      index,
                      details.delta.dx,
                      details.delta.dy,
                    );
                  },
                  onPanEnd: (_) {
                    // ドラッグ終了
                    debugPrint(
                      'Drag ended on item with id: ${dragItems[index].id}',
                    );
                  },
                  onTap: () {
                    debugPrint(
                      'Tapped on item with id: ${dragItems[index].id}',
                    );
                    dragItemsNotifier.bringItemToFront(dragItems[index].id);
                    selectedNotifier.update((state) => {
                          ...state,
                          dragItems[index].id:
                              !(state[dragItems[index].id] ?? false),
                        });
                  },
                  child: Transform.rotate(
                    angle: dragItems[index].theta,
                    alignment: Alignment.center,
                    child: Container(
                      width: _getRelativeItemSize(
                              dragItems[index].size, constraints)
                          .width,
                      height: _getRelativeItemSize(
                              dragItems[index].size, constraints)
                          .height,
                      decoration: BoxDecoration(
                        color: (selectedItems[dragItems[index].id] ?? false)
                            ? Colors.blue.withOpacity(0.7)
                            : Colors.primaries[
                                dragItems[index].id % Colors.primaries.length],
                        border: Border.all(
                          color: (selectedItems[dragItems[index].id] ?? false)
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Drag ${dragItems[index].id + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
