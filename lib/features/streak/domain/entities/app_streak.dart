import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_streak.freezed.dart';

enum StreakStatus { active, atRisk, noStreak }

@freezed
abstract class AppStreak with _$AppStreak {
  const factory AppStreak({
    required String id,
    required int currentStreak,
    required DateTime lastQualifyingDate,
    @Default(StreakStatus.noStreak) StreakStatus streakStatus,
  }) = _AppStreak;
}