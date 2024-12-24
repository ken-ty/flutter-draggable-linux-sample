// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_desk.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkDesk {
  int get id => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  Size get size => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WorkDeskCopyWith<WorkDesk> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkDeskCopyWith<$Res> {
  factory $WorkDeskCopyWith(WorkDesk value, $Res Function(WorkDesk) then) =
      _$WorkDeskCopyWithImpl<$Res, WorkDesk>;
  @useResult
  $Res call({int id, double x, double y, Size size});
}

/// @nodoc
class _$WorkDeskCopyWithImpl<$Res, $Val extends WorkDesk>
    implements $WorkDeskCopyWith<$Res> {
  _$WorkDeskCopyWithImpl(this._value, this._then);

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
    Object? size = null,
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
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkDeskImplCopyWith<$Res>
    implements $WorkDeskCopyWith<$Res> {
  factory _$$WorkDeskImplCopyWith(
          _$WorkDeskImpl value, $Res Function(_$WorkDeskImpl) then) =
      __$$WorkDeskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, double x, double y, Size size});
}

/// @nodoc
class __$$WorkDeskImplCopyWithImpl<$Res>
    extends _$WorkDeskCopyWithImpl<$Res, _$WorkDeskImpl>
    implements _$$WorkDeskImplCopyWith<$Res> {
  __$$WorkDeskImplCopyWithImpl(
      _$WorkDeskImpl _value, $Res Function(_$WorkDeskImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? x = null,
    Object? y = null,
    Object? size = null,
  }) {
    return _then(_$WorkDeskImpl(
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
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size,
    ));
  }
}

/// @nodoc

class _$WorkDeskImpl implements _WorkDesk {
  const _$WorkDeskImpl(
      {required this.id,
      required this.x,
      required this.y,
      this.size = WorkDesk.defaultSize});

  @override
  final int id;
  @override
  final double x;
  @override
  final double y;
  @override
  @JsonKey()
  final Size size;

  @override
  String toString() {
    return 'WorkDesk(id: $id, x: $x, y: $y, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkDeskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.size, size) || other.size == size));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, x, y, size);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkDeskImplCopyWith<_$WorkDeskImpl> get copyWith =>
      __$$WorkDeskImplCopyWithImpl<_$WorkDeskImpl>(this, _$identity);
}

abstract class _WorkDesk implements WorkDesk {
  const factory _WorkDesk(
      {required final int id,
      required final double x,
      required final double y,
      final Size size}) = _$WorkDeskImpl;

  @override
  int get id;
  @override
  double get x;
  @override
  double get y;
  @override
  Size get size;
  @override
  @JsonKey(ignore: true)
  _$$WorkDeskImplCopyWith<_$WorkDeskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
