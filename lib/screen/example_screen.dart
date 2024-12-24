import 'package:flutter/material.dart';
import 'package:flutter_draggable_linux_sample/component/add_item_button.dart';
import 'package:flutter_draggable_linux_sample/component/drag_drop_example.dart';
import 'package:flutter_draggable_linux_sample/component/reorderable_controls_list_view.dart';

/// メイン画面
class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [AddItemButton()],
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
