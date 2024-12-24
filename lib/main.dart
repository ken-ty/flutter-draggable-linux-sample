import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Drag and Drop Example')),
        body: Row(
          children: [
            SizedBox(
              width: 400,
              child: _ControlsListView(),
            ),
            Flexible(child: const DragDropExample()),
          ],
        ),
      ),
    );
  }
}

class _ControlsListView extends ConsumerWidget {
  const _ControlsListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(dragItemsProvider);
    final notifier = ref.read(dragItemsProvider.notifier);

    return ListView.builder(
      itemCount: items.length + 1, // 最後の「追加ボタン」用
      itemBuilder: (context, index) {
        if (index == items.length) {
          // リストの最後に「追加」用のボタンを表示
          return ListTile(
            leading: const Icon(Icons.add, color: Colors.green),
            title: const Text('Add New Item'),
            onTap: notifier.addItem,
          );
        }

        final item = items[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.primaries[index % Colors.primaries.length],
            child: Text('${item.index + 1}'),
          ),
          title: Text('Item ${item.index + 1}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => notifier.removeItem(item.index),
          ),
        );
      },
    );
  }
}

class DragItem {
  double x;
  double y;
  double theta;
  int index;
  final double originalX;
  final double originalY;
  bool isDragging;

  DragItem({
    required this.x,
    required this.y,
    this.theta = 0.0,
    required this.index,
    required this.originalX,
    required this.originalY,
    this.isDragging = false,
  });
}

final dragItemsProvider =
    StateNotifierProvider<DragItemsNotifier, List<DragItem>>((ref) {
  return DragItemsNotifier([
    DragItem(x: 100, y: 100, index: 0, originalX: 100, originalY: 100),
  ]);
});

class DragItemsNotifier extends StateNotifier<List<DragItem>> {
  DragItemsNotifier(List<DragItem> state) : super(state);

  void updateItem(int index, double dx, double dy) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          DragItem(
            x: state[i].x + dx,
            y: state[i].y + dy,
            theta: state[i].theta,
            index: state[i].index,
            originalX: state[i].originalX,
            originalY: state[i].originalY,
            isDragging: state[i].isDragging,
          )
        else
          state[i]
    ];
  }

  void setDragging(int index, bool isDragging) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          DragItem(
            x: state[i].x,
            y: state[i].y,
            theta: state[i].theta,
            index: state[i].index,
            originalX: state[i].originalX,
            originalY: state[i].originalY,
            isDragging: isDragging,
          )
        else
          state[i]
    ];
  }

  void incrementTheta(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          DragItem(
            x: state[i].x,
            y: state[i].y,
            theta: (state[i].theta + pi / 180) % (2 * pi),
            index: state[i].index,
            originalX: state[i].originalX,
            originalY: state[i].originalY,
            isDragging: state[i].isDragging,
          )
        else
          state[i]
    ];
  }

  void addItem() {
    final newIndex = state.isEmpty ? 0 : state.last.index + 1;
    final newX = 100.0 * (newIndex + 1);
    final newY = 100.0 * (newIndex + 1);
    state = [
      ...state,
      DragItem(
        x: newX,
        y: newY,
        index: newIndex,
        originalX: newX,
        originalY: newY,
      ),
    ];
  }

  void removeItem(int index) {
    state = state.where((item) => item.index != index).toList();
  }
}

class DragDropExample extends ConsumerWidget {
  const DragDropExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(dragItemsProvider);
    final notifier = ref.read(dragItemsProvider.notifier);

    return Stack(
      children: [
        for (int index = 0; index < items.length; index++)
          Stack(
            children: [
              // ドラッグ中のみ元の位置にプレースホルダーを表示
              if (items[index].isDragging)
                Positioned(
                  left: items[index].originalX,
                  top: items[index].originalY,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.withOpacity(0.3),
                    child: const Center(
                      child: Text(
                        'Original',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ),
              // ドラッグ可能な要素
              Positioned(
                left: items[index].x,
                top: items[index].y,
                child: GestureDetector(
                  onPanStart: (_) {
                    notifier.setDragging(index, true); // ドラッグ開始
                  },
                  onPanUpdate: (details) {
                    notifier.updateItem(
                        index, details.delta.dx, details.delta.dy);
                  },
                  onPanEnd: (_) {
                    notifier.setDragging(index, false); // ドラッグ終了
                  },
                  child: Stack(
                    children: [
                      Transform.rotate(
                        angle: items[index].theta,
                        alignment: Alignment.center,
                        child: Container(
                          width: 100,
                          height: 100,
                          color:
                              Colors.primaries[index % Colors.primaries.length],
                          child: Center(
                            child: Text(
                              'Drag ${items[index].index + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.rotate_right,
                              color: Colors.black),
                          onPressed: () {
                            notifier.incrementTheta(index);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
