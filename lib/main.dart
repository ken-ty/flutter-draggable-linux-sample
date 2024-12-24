import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:math';

part 'main.freezed.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  static const title = 'Drag and Drop Example';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
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
            SizedBox(
              width: 400,
              child: _ReorderableControlsListView(),
            ),
            Flexible(child: const DragDropExample()),
          ],
        ),
      ),
    );
  }
}

final selectedItemsProvider =
    StateProvider<Map<int, bool>>((ref) => {}); // id と選択状態をマッピング

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
              notifier.bringItemToFront(items[index].id); // 選択されたアイテムを最前面に移動
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

@freezed
class DragItem with _$DragItem {
  static const defaultSize = Size(100, 60);
  const factory DragItem({
    required int id,
    required int index,
    required double x,
    required double y,
    required double originalX,
    required double originalY,
    @Default(0.0) double theta,
    @Default(DragItem.defaultSize) Size size,
  }) = _DragItem;
}

final dragItemsProvider =
    StateNotifierProvider<DragItemsNotifier, List<DragItem>>((ref) {
  debugPrint('Initializing DragItemsProvider');
  return DragItemsNotifier([]);
});

class DragItemsNotifier extends StateNotifier<List<DragItem>> {
  DragItemsNotifier(List<DragItem> state) : super(state);

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

  void incrementTheta(int index, double deltaTheta) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(theta: (state[i].theta + deltaTheta) % (2 * pi))
        else
          state[i]
    ];
  }

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
        originalX: newX,
        originalY: newY,
      ),
    ];
  }

  void removeItem(int id) {
    debugPrint('Removing item with id: $id');
    state = [
      for (final item in state)
        if (item.id != id)
          item.copyWith(index: state.indexOf(item)) // Recalculate indices
    ];
  }

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

  void reorderItem(int oldIndex, int newIndex) {
    debugPrint('Reordering item from index $oldIndex to index $newIndex');
    final item = state.removeAt(oldIndex);
    state.insert(newIndex, item);
    state = [
      for (int i = 0; i < state.length; i++) state[i].copyWith(index: i),
    ];
  }
}

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

class DragDropExample extends ConsumerWidget {
  const DragDropExample({Key? key}) : super(key: key);

  /// ベースサイズと制約に基づいてスケールファクターを計算します
  double _caluculateScaleFactor(Size baseSize, BoxConstraints constraints) {
    final widthScaleFactor = constraints.biggest.width / baseSize.width;
    final heightScaleFactor = constraints.biggest.height / baseSize.height;
    // 画面で見きれないよう小さい値を採用する
    final scaleFactor = min(widthScaleFactor, heightScaleFactor);
    return scaleFactor;
  }

  Size _calculateProportionalSize(Size baseSize, double scaleFactor) {
    return Size(baseSize.width * scaleFactor, baseSize.height * scaleFactor);
  }

  Size _getRelativeWorkDeskSize(BoxConstraints constraints) {
    final baseSize = WorkDesk.defaultSize;
    final scaleFactor = _caluculateScaleFactor(baseSize, constraints);
    return _calculateProportionalSize(baseSize, scaleFactor);
  }

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
    final items = ref.watch(dragItemsProvider);
    final selectedItems = ref.watch(selectedItemsProvider);
    final selectedNotifier = ref.read(selectedItemsProvider.notifier);
    final notifier = ref.read(dragItemsProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final workDeskSize = _getRelativeWorkDeskSize(constraints);
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.grey,
              ),
            ),
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
            ...List.generate(items.length, (index) {
              return Positioned(
                child: Positioned(
                  left: items[index].x,
                  top: items[index].y,
                  child: GestureDetector(
                    onPanStart: (_) {
                      // ドラッグ開始
                    },
                    onPanUpdate: (details) {
                      debugPrint(
                          'Item moved by dx: ${details.delta.dx}, dy: ${details.delta.dy}');
                      notifier.updateItem(
                          index, details.delta.dx, details.delta.dy);
                    },
                    onPanEnd: (_) {
                      // ドラッグ終了
                    },
                    onTap: () {
                      debugPrint('Tapped on item with id: ${items[index].id}');
                      notifier.bringItemToFront(items[index].id);
                      selectedNotifier.update((state) => {
                            ...state,
                            items[index].id: !(state[items[index].id] ?? false),
                          });
                    },
                    child: Transform.rotate(
                      angle: items[index].theta,
                      alignment: Alignment.center,
                      child: Container(
                        width:
                            _getRelativeItemSize(items[index].size, constraints)
                                .width,
                        height:
                            _getRelativeItemSize(items[index].size, constraints)
                                .height,
                        decoration: BoxDecoration(
                          color: (selectedItems[items[index].id] ?? false)
                              ? Colors.blue.withOpacity(0.7)
                              : Colors.primaries[
                                  items[index].id % Colors.primaries.length],
                          border: Border.all(
                            color: (selectedItems[items[index].id] ?? false)
                                ? Colors.blue
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Drag ${items[index].id + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
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
