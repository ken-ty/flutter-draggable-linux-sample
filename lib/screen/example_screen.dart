import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_draggable_linux_sample/model/drag_item.dart';
import 'package:flutter_draggable_linux_sample/model/work_desk.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// メイン画面
class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          _AddItemButton(),
        ],
      ),
      body: Row(
        children: [
          SizedBox(
            width: 400,
            child: ReorderableControlsListView(),
          ),
          // Flexible で画面いっぱいに広がるようにする
          Flexible(
            child: const DragDropExample(),
          ),
        ],
      ),
    );
  }
}

/// アイテム追加ボタン
class _AddItemButton extends ConsumerWidget {
  const _AddItemButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        final notifier = ref.read(dragItemsProvider.notifier);
        notifier.addItem();
      },
    );
  }
}

/// リストビューのアイテムを表示するウィジェット
class ReorderableControlsListView extends HookConsumerWidget {
  const ReorderableControlsListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(dragItemsProvider);
    final selectedItems = ref.watch(selectedItemsProvider);
    final selectedNotifier = ref.read(selectedItemsProvider.notifier);
    final notifier = ref.read(dragItemsProvider.notifier);

    final showDragHandles = useState(false);

    return ReorderableListView(
      onReorder: notifier.reorderItem,
      header: ListTile(
        title: Text('Items'),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: showDragHandles.value ? Colors.blue : null,
            backgroundColor: showDragHandles.value ? Colors.blue[100] : null,
          ),
          onPressed: () => showDragHandles.value = !showDragHandles.value,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.reorder),
              SizedBox(width: 8),
              Text('Reorder'),
              SizedBox(width: 8),
              SizedBox(
                  width: 30, child: Text(showDragHandles.value ? 'ON' : 'OFF')),
            ],
          ),
        ),
      ),
      buildDefaultDragHandles: showDragHandles.value,
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
            trailing: showDragHandles.value
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.rotate_left),
                        onPressed: () =>
                            notifier.incrementTheta(index, -pi / 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.rotate_right),
                        onPressed: () =>
                            notifier.incrementTheta(index, pi / 18),
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
