import 'package:flutter/material.dart';
import 'package:flutter_draggable_linux_sample/model/drag_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// アイテム追加ボタン
class AddItemButton extends ConsumerWidget {
  const AddItemButton();

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
