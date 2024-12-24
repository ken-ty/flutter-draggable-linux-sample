import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_draggable_linux_sample/constant.dart';
import 'package:flutter_draggable_linux_sample/model/drag_item.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      header: _Header(
        showDragHandles: showDragHandles.value,
        onToggle: () => showDragHandles.value = !showDragHandles.value,
      ),
      buildDefaultDragHandles: showDragHandles.value,
      children: [
        for (int index = 0; index < items.length; index++)
          ListTile(
            key: ValueKey(items[index].id),
            leading: CircleAvatar(
              backgroundColor: (selectedItems[items[index].id] ?? false)
                  ? kSelectedColor
                  : kColorsWithoutselectedColor[
                      items[index].id % kColorsWithoutselectedColor.length],
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
                        icon: const Icon(Icons.delete),
                        onPressed: () => notifier.removeItem(items[index].id),
                      ),
                    ],
                  ),
            onTap: () {
              debugPrint('Tapped on item with id: ${items[index].id}');
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

class _Header extends StatelessWidget {
  const _Header({
    required this.showDragHandles,
    required this.onToggle,
  });

  final bool showDragHandles;
  final void Function() onToggle;

  static final reorderingButtonColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Items'),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: showDragHandles ? reorderingButtonColor : null,
          backgroundColor: showDragHandles ? reorderingButtonColor[100] : null,
        ),
        onPressed: onToggle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.reorder),
            SizedBox(width: 8),
            Text('Reorder'),
            SizedBox(width: 8),
            SizedBox(
              width: 30,
              child: Text(showDragHandles ? 'ON' : 'OFF'),
            ),
          ],
        ),
      ),
    );
  }
}
