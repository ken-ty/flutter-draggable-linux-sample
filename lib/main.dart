import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    DragItem(x: 200, y: 200, index: 1),
    DragItem(x: 300, y: 300, index: 2),
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
    debugPrint('state: ${state[0].x}, ${state[0].y}, ${state[0].theta}');
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
            child: Transform.rotate(
              angle: item.theta,
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
          ),
        );
      }),
    );
  }
}
