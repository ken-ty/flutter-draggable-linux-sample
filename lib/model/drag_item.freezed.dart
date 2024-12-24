// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drag_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DragItem {
  int get id => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get theta => throw _privateConstructorUsedError;
  Size get size => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DragItemCopyWith<DragItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DragItemCopyWith<$Res> {
  factory $DragItemCopyWith(DragItem value, $Res Function(DragItem) then) =
      _$DragItemCopyWithImpl<$Res, DragItem>;
  @useResult
  $Res call({int id, int index, double x, double y, double theta, Size size});
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
    Object? index = null,
    Object? x = null,
    Object? y = null,
    Object? theta = null,
    Object? size = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      theta: null == theta
          ? _value.theta
          : theta // ignore: cast_nullable_to_non_nullable
              as double,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size,
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
  $Res call({int id, int index, double x, double y, double theta, Size size});
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
    Object? index = null,
    Object? x = null,
    Object? y = null,
    Object? theta = null,
    Object? size = null,
  }) {
    return _then(_$DragItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      theta: null == theta
          ? _value.theta
          : theta // ignore: cast_nullable_to_non_nullable
              as double,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size,
    ));
  }
}

/// @nodoc

class _$DragItemImpl implements _DragItem {
  const _$DragItemImpl(
      {required this.id,
      required this.index,
      required this.x,
      required this.y,
      this.theta = 0.0,
      this.size = DragItem.defaultSize});

  @override
  final int id;
  @override
  final int index;
  @override
  final double x;
  @override
  final double y;
  @override
  @JsonKey()
  final double theta;
  @override
  @JsonKey()
  final Size size;

  @override
  String toString() {
    return 'DragItem(id: $id, index: $index, x: $x, y: $y, theta: $theta, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DragItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.theta, theta) || other.theta == theta) &&
            (identical(other.size, size) || other.size == size));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, index, x, y, theta, size);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DragItemImplCopyWith<_$DragItemImpl> get copyWith =>
      __$$DragItemImplCopyWithImpl<_$DragItemImpl>(this, _$identity);
}

abstract class _DragItem implements DragItem {
  const factory _DragItem(
      {required final int id,
      required final int index,
      required final double x,
      required final double y,
      final double theta,
      final Size size}) = _$DragItemImpl;

  @override
  int get id;
  @override
  int get index;
  @override
  double get x;
  @override
  double get y;
  @override
  double get theta;
  @override
  Size get size;
  @override
  @JsonKey(ignore: true)
  _$$DragItemImplCopyWith<_$DragItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
