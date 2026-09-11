import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// The authentication information this app needs about a signed-in user.
///
/// This is deliberately not Supabase's `User` type: domain code must not
/// depend on a specific authentication service. Add fields here only when the
/// app itself needs them.
@freezed
abstract class AppUser with _$AppUser {
  /// Creates an immutable app user identified by the authentication provider.
  const factory AppUser({required String id}) = _AppUser;

  /// Recreates an [AppUser] from JSON when persistence or transport needs it.
  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
