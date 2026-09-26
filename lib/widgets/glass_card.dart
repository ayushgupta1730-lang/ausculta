import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A reusable translucent material used throughout Ausculta.
///
/// The intention is not "heavy glassmorphism".
/// Instead, it creates the subtle layered material feeling found in premium
/// modern interfaces.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final double blur;
  final Color? tint;
  final bool showShadow;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AppRadius.medium),
    ),
    this.onTap,
    this.blur = 18,
    this.tint,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final material = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tint ?? AppColors.glassWhite,
            borderRadius: borderRadius,
            border: Border.all(
              color: AppColors.glassBorder,
              width: 0.8,
            ),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.045),
                      blurRadius: 30,
                      spreadRadius: -6,
                      offset: const Offset(0, 14),
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) {
      return material;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        splashColor: Colors.black.withValues(alpha: 0.025),
        highlightColor: Colors.black.withValues(alpha: 0.018),
        child: material,
      ),
    );
  }
}