import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_desk.freezed.dart';

/// ワークデスクのデータクラス
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
