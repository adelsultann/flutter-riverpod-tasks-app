// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppTask {

 String get id; String get title; String? get description; bool get isCompleted;
/// Create a copy of AppTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppTaskCopyWith<AppTask> get copyWith => _$AppTaskCopyWithImpl<AppTask>(this as AppTask, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppTask&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,isCompleted);

@override
String toString() {
  return 'AppTask(id: $id, title: $title, description: $description, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $AppTaskCopyWith<$Res>  {
  factory $AppTaskCopyWith(AppTask value, $Res Function(AppTask) _then) = _$AppTaskCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, bool isCompleted
});




}
/// @nodoc
class _$AppTaskCopyWithImpl<$Res>
    implements $AppTaskCopyWith<$Res> {
  _$AppTaskCopyWithImpl(this._self, this._then);

  final AppTask _self;
  final $Res Function(AppTask) _then;

/// Create a copy of AppTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? isCompleted = null,}) {
  return _then(AppTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppTask].
extension AppTaskPatterns on AppTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppTask value)  $default,){
final _that = this;
switch (_that) {
case _AppTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppTask value)?  $default,){
final _that = this;
switch (_that) {
case _AppTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppTask() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _AppTask():
return $default(_that.id,_that.title,_that.description,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description,  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _AppTask() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc


class _AppTask implements AppTask {
  const _AppTask({required this.id, required this.title, this.description, this.isCompleted = false});
  

@override final  String id;
@override final  String title;
@override final  String? description;
@override@JsonKey() final  bool isCompleted;

/// Create a copy of AppTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppTaskCopyWith<_AppTask> get copyWith => __$AppTaskCopyWithImpl<_AppTask>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppTask&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,isCompleted);

@override
String toString() {
  return 'AppTask(id: $id, title: $title, description: $description, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$AppTaskCopyWith<$Res> implements $AppTaskCopyWith<$Res> {
  factory _$AppTaskCopyWith(_AppTask value, $Res Function(_AppTask) _then) = __$AppTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, bool isCompleted
});




}
/// @nodoc
class __$AppTaskCopyWithImpl<$Res>
    implements _$AppTaskCopyWith<$Res> {
  __$AppTaskCopyWithImpl(this._self, this._then);

  final _AppTask _self;
  final $Res Function(_AppTask) _then;

/// Create a copy of AppTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? isCompleted = null,}) {
  return _then(_AppTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
