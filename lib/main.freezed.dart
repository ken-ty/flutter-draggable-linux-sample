// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DragItem {
  int get id => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get originalX => throw _privateConstructorUsedError;
  double get originalY => throw _privateConstructorUsedError;
  double get theta => throw _privateConstructorUsedError;
  Size get size => throw _privateConstructorUsedError;
  bool get isDragging => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DragItemCopyWith<DragItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DragItemCopyWith<$Res> {
  factory $DragItemCopyWith(DragItem value, $Res Function(DragItem) then) =
      _$DragItemCopyWithImpl<$Res, DragItem>;
  @useResult
  $Res call(
      {int id,
      double x,
      double y,
      double originalX,
      double originalY,
      double theta,
      Size size,
      bool isDragging,
      bool isSelected});
}

/// @nodoc
class _$DragItemCopyWithImpl<$Res, $Val extends DragItem>
    implements $DragItemCopyWith<$Res> {
  _$DragItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? x = null,
    Object? y = null,
    Object? originalX = null,
    Object? originalY = null,
    Object? theta = null,
    Object? size = null,
    Object? isDragging = null,
    Object? isSelected = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      originalX: null == originalX
          ? _value.originalX
          : originalX // ignore: cast_nullable_to_non_nullable
              as double,
      originalY: null == originalY
          ? _value.originalY
          : originalY // ignore: cast_nullable_to_non_nullable
              as double,
      theta: null == theta
          ? _value.theta
          : theta // ignore: cast_nullable_to_non_nullable
              as double,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size,
      isDragging: null == isDragging
          ? _value.isDragging
          : isDragging // ignore: cast_nullable_to_non_nullable
              as bool,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DragItemImplCopyWith<$Res>
    implements $DragItemCopyWith<$Res> {
  factory _$$DragItemImplCopyWith(
          _$DragItemImpl value, $Res Function(_$DragItemImpl) then) =
      __$$DragItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      double x,
      double y,
      double originalX,
      double originalY,
      double theta,
      Size size,
      bool isDragging,
      bool isSelected});
}

/// @nodoc
class __$$DragItemImplCopyWithImpl<$Res>
    extends _$DragItemCopyWithImpl<$Res, _$DragItemImpl>
    implements _$$DragItemImplCopyWith<$Res> {
  __$$DragItemImplCopyWithImpl(
      _$DragItemImpl _value, $Res Function(_$DragItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? x = null,
    Object? y = null,
    Object? originalX = null,
    Object? originalY = null,
    Object? theta = null,
    Object? size = null,
    Object? isDragging = null,
    Object? isSelected = null,
  }) {
    return _then(_$DragItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      originalX: null == originalX
          ? _value.originalX
          : originalX // ignore: cast_nullable_to_non_nullable
              as double,
      originalY: null == originalY
          ? _value.originalY
          : originalY // ignore: cast_nullable_to_non_nullable
              as double,
      theta: null == theta
          ? _value.theta
          : theta // ignore: cast_nullable_to_non_nullable
              as double,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size,
      isDragging: null == isDragging
          ? _value.isDragging
          : isDragging // ignore: cast_nullable_to_non_nullable
              as bool,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$DragItemImpl implements _DragItem {
  const _$DragItemImpl(
      {required this.id,
      required this.x,
      required this.y,
      required this.originalX,
      required this.originalY,
      this.theta = 0.0,
      this.size = DragItem.defaultSize,
      this.isDragging = false,
      this.isSelected = false});

  @override
  final int id;
  @override
  final double x;
  @override
  final double y;
  @override
  final double originalX;
  @override
  final double originalY;
  @override
  @JsonKey()
  final double theta;
  @override
  @JsonKey()
  final Size size;
  @override
  @JsonKey()
  final bool isDragging;
  @override
  @JsonKey()
  final bool isSelected;

  @override
  String toString() {
    return 'DragItem(id: $id, x: $x, y: $y, originalX: $originalX, originalY: $originalY, theta: $theta, size: $size, isDragging: $isDragging, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DragItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.originalX, originalX) ||
                other.originalX == originalX) &&
            (identical(other.originalY, originalY) ||
                other.originalY == originalY) &&
            (identical(other.theta, theta) || other.theta == theta) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.isDragging, isDragging) ||
                other.isDragging == isDragging) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, x, y, originalX, originalY,
      theta, size, isDragging, isSelected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DragItemImplCopyWith<_$DragItemImpl> get copyWith =>
      __$$DragItemImplCopyWithImpl<_$DragItemImpl>(this, _$identity);
}

abstract class _DragItem implements DragItem {
  const factory _DragItem(
      {required final int id,
      required final double x,
      required final double y,
      required final double originalX,
      required final double originalY,
      final double theta,
      final Size size,
      final bool isDragging,
      final bool isSelected}) = _$DragItemImpl;

  @override
  int get id;
  @override
  double get x;
  @override
  double get y;
  @override
  double get originalX;
  @override
  double get originalY;
  @override
  double get theta;
  @override
  Size get size;
  @override
  bool get isDragging;
  @override
  bool get isSelected;
  @override
  @JsonKey(ignore: true)
  _$$DragItemImplCopyWith<_$DragItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
