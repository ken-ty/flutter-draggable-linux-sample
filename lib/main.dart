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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Drag and Drop Example'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Add a new item via the provider
                final container = ProviderContainer();
                final notifier = container.read(dragItemsProvider.notifier);
                notifier.addItem();
                container.dispose();
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
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => notifier.removeItem(items[index].id),
            ),
            onTap: () {
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
  static const defaultSize = Size(100, 100);
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

  void incrementTheta(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(theta: (state[i].theta + pi / 180) % (2 * pi))
        else
          state[i]
    ];
  }

  void addItem() {
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
    state = [
      for (final item in state)
        if (item.id != id)
          item.copyWith(index: state.indexOf(item)) // Recalculate indices
    ];
  }

  void bringItemToFront(int id) {
    final itemToBring = state.firstWhere((item) => item.id == id);
    state = [
      ...state
          .where((item) => item.id != id)
          .map((item) => item.copyWith(index: state.indexOf(item))),
      itemToBring.copyWith(index: state.length),
    ];
  }

  void reorderItem(int oldIndex, int newIndex) {
    final item = state.removeAt(oldIndex);
    state.insert(newIndex, item);
    state = [
      for (int i = 0; i < state.length; i++) state[i].copyWith(index: i),
    ];
  }
}

class DragDropExample extends ConsumerWidget {
  const DragDropExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(dragItemsProvider);
    final selectedItems = ref.watch(selectedItemsProvider);
    final selectedNotifier = ref.read(selectedItemsProvider.notifier);
    final notifier = ref.read(dragItemsProvider.notifier);

    return Stack(
      children: [
        for (int index = 0; index < items.length; index++)
          Stack(
            children: [
              Positioned(
                left: items[index].x,
                top: items[index].y,
                child: GestureDetector(
                  onPanStart: (_) {
                    // ドラッグ開始
                  },
                  onPanUpdate: (details) {
                    notifier.updateItem(
                        index, details.delta.dx, details.delta.dy);
                  },
                  onPanEnd: (_) {
                    // ドラッグ終了
                  },
                  onTap: () {
                    // 選択状態をトグル
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
                      width: 100,
                      height: 100,
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
            ],
          ),
      ],
    );
  }
}
