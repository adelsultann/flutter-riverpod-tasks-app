// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_streak.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppStreak {

 String get id; int get currentStreak; DateTime get lastQualifyingDate; StreakStatus get streakStatus;
/// Create a copy of AppStreak
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppStreakCopyWith<AppStreak> get copyWith => _$AppStreakCopyWithImpl<AppStreak>(this as AppStreak, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppStreak&&(identical(other.id, id) || other.id == id)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.lastQualifyingDate, lastQualifyingDate) || other.lastQualifyingDate == lastQualifyingDate)&&(identical(other.streakStatus, streakStatus) || other.streakStatus == streakStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,currentStreak,lastQualifyingDate,streakStatus);

@override
String toString() {
  return 'AppStreak(id: $id, currentStreak: $currentStreak, lastQualifyingDate: $lastQualifyingDate, streakStatus: $streakStatus)';
}


}

/// @nodoc
abstract mixin class $AppStreakCopyWith<$Res>  {
  factory $AppStreakCopyWith(AppStreak value, $Res Function(AppStreak) _then) = _$AppStreakCopyWithImpl;
@useResult
$Res call({
 String id, int currentStreak, DateTime lastQualifyingDate, StreakStatus streakStatus
});




}
/// @nodoc
class _$AppStreakCopyWithImpl<$Res>
    implements $AppStreakCopyWith<$Res> {
  _$AppStreakCopyWithImpl(this._self, this._then);

  final AppStreak _self;
  final $Res Function(AppStreak) _then;

/// Create a copy of AppStreak
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? currentStreak = null,Object? lastQualifyingDate = null,Object? streakStatus = null,}) {
  return _then(AppStreak(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,lastQualifyingDate: null == lastQualifyingDate ? _self.lastQualifyingDate : lastQualifyingDate // ignore: cast_nullable_to_non_nullable
as DateTime,streakStatus: null == streakStatus ? _self.streakStatus : streakStatus // ignore: cast_nullable_to_non_nullable
as StreakStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [AppStreak].
extension AppStreakPatterns on AppStreak {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppStreak value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppStreak() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppStreak value)  $default,){
final _that = this;
switch (_that) {
case _AppStreak():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppStreak value)?  $default,){
final _that = this;
switch (_that) {
case _AppStreak() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int currentStreak,  DateTime lastQualifyingDate,  StreakStatus streakStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppStreak() when $default != null:
return $default(_that.id,_that.currentStreak,_that.lastQualifyingDate,_that.streakStatus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int currentStreak,  DateTime lastQualifyingDate,  StreakStatus streakStatus)  $default,) {final _that = this;
switch (_that) {
case _AppStreak():
return $default(_that.id,_that.currentStreak,_that.lastQualifyingDate,_that.streakStatus);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int currentStreak,  DateTime lastQualifyingDate,  StreakStatus streakStatus)?  $default,) {final _that = this;
switch (_that) {
case _AppStreak() when $default != null:
return $default(_that.id,_that.currentStreak,_that.lastQualifyingDate,_that.streakStatus);case _:
  return null;

}
}

}

/// @nodoc


class _AppStreak implements AppStreak {
  const _AppStreak({required this.id, required this.currentStreak, required this.lastQualifyingDate, this.streakStatus = StreakStatus.noStreak});
  

@override final  String id;
@override final  int currentStreak;
@override final  DateTime lastQualifyingDate;
@override@JsonKey() final  StreakStatus streakStatus;

/// Create a copy of AppStreak
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppStreakCopyWith<_AppStreak> get copyWith => __$AppStreakCopyWithImpl<_AppStreak>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppStreak&&(identical(other.id, id) || other.id == id)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.lastQualifyingDate, lastQualifyingDate) || other.lastQualifyingDate == lastQualifyingDate)&&(identical(other.streakStatus, streakStatus) || other.streakStatus == streakStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,currentStreak,lastQualifyingDate,streakStatus);

@override
String toString() {
  return 'AppStreak(id: $id, currentStreak: $currentStreak, lastQualifyingDate: $lastQualifyingDate, streakStatus: $streakStatus)';
}


}

/// @nodoc
abstract mixin class _$AppStreakCopyWith<$Res> implements $AppStreakCopyWith<$Res> {
  factory _$AppStreakCopyWith(_AppStreak value, $Res Function(_AppStreak) _then) = __$AppStreakCopyWithImpl;
@override @useResult
$Res call({
 String id, int currentStreak, DateTime lastQualifyingDate, StreakStatus streakStatus
});




}
/// @nodoc
class __$AppStreakCopyWithImpl<$Res>
    implements _$AppStreakCopyWith<$Res> {
  __$AppStreakCopyWithImpl(this._self, this._then);

  final _AppStreak _self;
  final $Res Function(_AppStreak) _then;

/// Create a copy of AppStreak
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? currentStreak = null,Object? lastQualifyingDate = null,Object? streakStatus = null,}) {
  return _then(_AppStreak(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,lastQualifyingDate: null == lastQualifyingDate ? _self.lastQualifyingDate : lastQualifyingDate // ignore: cast_nullable_to_non_nullable
as DateTime,streakStatus: null == streakStatus ? _self.streakStatus : streakStatus // ignore: cast_nullable_to_non_nullable
as StreakStatus,
  ));
}


}

// dart format on
