import 'package:flutter/material.dart';

/// Semantic colors not covered by [ColorScheme] — currently just the
/// positive/success accent used for free-order and discount messaging, so
/// screens never have to hardcode a raw green.
class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  final Color onSuccess;

  const AppColors({required this.success, required this.onSuccess});

  @override
  AppColors copyWith({Color? success, Color? onSuccess}) => AppColors(
    success: success ?? this.success,
    onSuccess: onSuccess ?? this.onSuccess,
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
    );
  }
}
