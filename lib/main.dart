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
        body: const DragDropExample(),
        floatingActionButton: const DragDropControls(),
      ),
    );
  }
}

class DragItem {
  double x;
  double y;
  double theta;
  int index;

  DragItem(
      {required this.x,
      required this.y,
      this.theta = 0.0,
      required this.index});
}

final dragItemsProvider =
    StateNotifierProvider<DragItemsNotifier, List<DragItem>>((ref) {
  return DragItemsNotifier([
    DragItem(x: 100, y: 100, index: 0),
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
          )
        else
          state[i]
    ];
  }

  void addItem() {
    final newIndex = state.isEmpty ? 0 : state.last.index + 1;
    state = [
      ...state,
      DragItem(
          x: 100.0 * (newIndex + 1),
          y: 100.0 * (newIndex + 1),
          index: newIndex),
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
      children: List.generate(items.length, (index) {
        final item = items[index];
        return Positioned(
          left: item.x,
          top: item.y,
          child: GestureDetector(
            onPanUpdate: (details) {
              notifier.updateItem(index, details.delta.dx, details.delta.dy);
            },
            child: Stack(
              children: [
                Transform.rotate(
                  angle: item.theta,
                  alignment: Alignment.center,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.primaries[index % Colors.primaries.length],
                    child: Center(
                      child: Text(
                        'Drag ${item.index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.rotate_right, color: Colors.black),
                    onPressed: () {
                      notifier.incrementTheta(index);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class DragDropControls extends ConsumerWidget {
  const DragDropControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dragItemsProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            notifier.addItem();
          },
          tooltip: 'Add Item',
          child: const Icon(Icons.add),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          onPressed: () {
            if (ref.read(dragItemsProvider).isNotEmpty) {
              notifier.removeItem(ref.read(dragItemsProvider).last.index);
            }
          },
          tooltip: 'Remove Item',
          child: const Icon(Icons.remove),
        ),
      ],
    );
  }
}
