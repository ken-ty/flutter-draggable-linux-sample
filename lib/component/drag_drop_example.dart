import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_draggable_linux_sample/constant.dart';
import 'package:flutter_draggable_linux_sample/model/drag_item.dart';
import 'package:flutter_draggable_linux_sample/model/work_desk.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ドラッグアイテムのウィジェット
class DragDropExample extends ConsumerWidget {
  const DragDropExample({Key? key}) : super(key: key);

  /// スケールファクターを計算します
  ///
  /// Layout された Widget のサイズに合わせてスケーリングするための係数を計算する.
  /// FittedBox のような挙動を Drag and Drop のウィジェットに適用するために使用する為.
  double caluculateScaleFactor(Size baseSize, BoxConstraints constraints) {
    final widthScaleFactor = constraints.biggest.width / baseSize.width;
    final heightScaleFactor = constraints.biggest.height / baseSize.height;
    // 画面で見きれないよう小さい値を採用する
    final scaleFactor = min(widthScaleFactor, heightScaleFactor);
    return scaleFactor;
  }

  /// サイズをスケーリングします
  ///
  /// baseSize に scaleFactor を掛けたサイズを計算します
  Size scaleSize(Size baseSize, double scaleFactor) {
    return Size(baseSize.width * scaleFactor, baseSize.height * scaleFactor);
  }

  /// ワークデスクの相対サイズを取得します
  Size getRelativeWorkDeskSize(BoxConstraints constraints) {
    final baseSize = WorkDesk.defaultSize;
    final scaleFactor = caluculateScaleFactor(baseSize, constraints);
    return scaleSize(baseSize, scaleFactor);
  }

  /// アイテムの相対サイズを取得します
  Size getRelativeItemSize(Size itemAbsoluteSize, BoxConstraints constraints) {
    // ワークデスクとサイズ感を合わせたいので ワークデスクのサイズを基準にスケーリングする。
    final workBaseSize = WorkDesk.defaultSize;
    final scaleFactor = caluculateScaleFactor(workBaseSize, constraints);

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final workDeskSize = getRelativeWorkDeskSize(constraints);
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
                child: _WorkDeskContainer(workDeskSize: workDeskSize),
              ),
            ),
            // ドラッグアイテム
            ...List.generate(dragItems.length, (index) {
              final item = dragItems[index];
              final itemSize = getRelativeItemSize(item.size, constraints);
              return Positioned(
                left: item.x,
                top: item.y,
                child: GestureDetector(
                  onPanUpdate: (details) => dragItemsNotifier.updateItem(
                    item.index,
                    details.delta.dx,
                    details.delta.dy,
                  ),
                  child: Transform.rotate(
                    angle: item.theta,
                    alignment: Alignment.center,
                    child: _DragItemContainer(
                      itemSize: itemSize,
                      item: item,
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

class _DragItemContainer extends ConsumerWidget {
  const _DragItemContainer({
    required this.itemSize,
    required this.item,
  });

  final Size itemSize;
  final DragItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedItemsProvider);
    final isSelected = selectedItems[item.id] ?? false;

    return Container(
      width: itemSize.width,
      height: itemSize.height,
      decoration: BoxDecoration(
        color: isSelected
            ? kSelectedColor.withOpacity(0.5)
            : kColorsWithoutselectedColor[
                item.id % kColorsWithoutselectedColor.length],
        border: Border.all(
          color: isSelected ? kSelectedColor : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          'Drag ${item.id + 1} (${item.index})',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _WorkDeskContainer extends StatelessWidget {
  const _WorkDeskContainer({
    required this.workDeskSize,
  });

  final Size workDeskSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: workDeskSize.width,
        height: workDeskSize.height,
        color: Colors.brown,
      ),
    );
  }
}
