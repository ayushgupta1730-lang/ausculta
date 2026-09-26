import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// AUSCULTA DESIGN SYSTEM
/// ---------------------------------------------------------------------------
///
/// Three visual personalities:
///
/// CLARITY
/// Clean, warm, minimal and Apple-inspired.
/// The default Ausculta experience.
///
/// NOIR
/// Deep, quiet and premium.
/// Designed for comfortable night-time studying.
///
/// ANANYA ✦
/// Fabulous, dreamy and personalized.
/// Glossy glass, soft iridescence, pink/lilac/blue/peach accents,
/// subtle sparkle and a little more personality.
///
/// The same component system is shared by all three themes.
/// ---------------------------------------------------------------------------

enum AuscultaTheme {
  clarity,
  noir,
  ananya,
}

/// ---------------------------------------------------------------------------
/// THEME EXTENSION
/// ---------------------------------------------------------------------------
///
/// Allows widgets to access Ausculta-specific colors through:
///
/// Theme.of(context).extension<AuscultaThemeExtension>()
///
/// instead of scattering theme-specific constants throughout the UI.
/// ---------------------------------------------------------------------------

@immutable
class AuscultaThemeExtension
    extends ThemeExtension<AuscultaThemeExtension> {
  final Color background;
  final Color backgroundSecondary;

  final Color surface;
  final Color surfaceSoft;
  final Color surfaceStrong;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textFaint;

  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentTertiary;

  final Color accentSoft;
  final Color accentSecondarySoft;

  final Color glass;
  final Color glassStrong;
  final Color glassBorder;

  final Color playback;
  final Color playbackSoft;

  final Color sparkle;
  final Color glow;

  final bool fabulous;

  const AuscultaThemeExtension({
    required this.background,
    required this.backgroundSecondary,
    required this.surface,
    required this.surfaceSoft,
    required this.surfaceStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textFaint,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.accentTertiary,
    required this.accentSoft,
    required this.accentSecondarySoft,
    required this.glass,
    required this.glassStrong,
    required this.glassBorder,
    required this.playback,
    required this.playbackSoft,
    required this.sparkle,
    required this.glow,
    this.fabulous = false,
  });

  // ===========================================================================
  // CLARITY
  // ===========================================================================

  static const clarity = AuscultaThemeExtension(
    background: Color(0xFFF7F7F5),
    backgroundSecondary: Color(0xFFFAFAF8),

    surface: Color(0xFFFFFFFF),
    surfaceSoft: Color(0xFFF2F2F0),
    surfaceStrong: Color(0xFFFFFFFF),

    textPrimary: Color(0xFF171717),
    textSecondary: Color(0xFF737373),
    textTertiary: Color(0xFFA3A3A3),
    textFaint: Color(0xFFC0C0C0),

    accentPrimary: Color(0xFF8CB8FF),
    accentSecondary: Color(0xFFF2A9C5),
    accentTertiary: Color(0xFFB9A9F7),

    accentSoft: Color(0xFFDDEAFF),
    accentSecondarySoft: Color(0xFFFBE3ED),

    glass: Color(0xBFFFFFFF),
    glassStrong: Color(0xE6FFFFFF),
    glassBorder: Color(0x55FFFFFF),

    playback: Color(0xFF191919),
    playbackSoft: Color(0xFFF0F0EE),

    sparkle: Color(0xFFF2A9C5),
    glow: Color(0x33F2A9C5),

    fabulous: false,
  );

  // ===========================================================================
  // NOIR
  // ===========================================================================

  static const noir = AuscultaThemeExtension(
    background: Color(0xFF101112),
    backgroundSecondary: Color(0xFF151617),

    surface: Color(0xFF1B1C1E),
    surfaceSoft: Color(0xFF222326),
    surfaceStrong: Color(0xFF28292C),

    textPrimary: Color(0xFFF4F4F2),
    textSecondary: Color(0xFFB5B5B5),
    textTertiary: Color(0xFF858585),
    textFaint: Color(0xFF5F5F5F),

    accentPrimary: Color(0xFF8CB8FF),
    accentSecondary: Color(0xFFF2A9C5),
    accentTertiary: Color(0xFFB9A9F7),

    accentSoft: Color(0xFF243249),
    accentSecondarySoft: Color(0xFF382832),

    glass: Color(0x991F2023),
    glassStrong: Color(0xDD242529),
    glassBorder: Color(0x22FFFFFF),

    playback: Color(0xFFF4F4F2),
    playbackSoft: Color(0xFF292A2D),

    sparkle: Color(0xFFF2A9C5),
    glow: Color(0x44F2A9C5),

    fabulous: false,
  );

  // ===========================================================================
  // ANANYA ✦
  // ===========================================================================

  static const ananya = AuscultaThemeExtension(
    background: Color(0xFFFDF7FC),
    backgroundSecondary: Color(0xFFF8F6FF),

    surface: Color(0xFFFFFFFF),
    surfaceSoft: Color(0xFFFFF1F8),
    surfaceStrong: Color(0xFFFFFBFE),

    textPrimary: Color(0xFF241D2A),
    textSecondary: Color(0xFF756A7D),
    textTertiary: Color(0xFFA49AA9),
    textFaint: Color(0xFFC8BECF),

    accentPrimary: Color(0xFF9A8AF5),
    accentSecondary: Color(0xFFFF8FBD),
    accentTertiary: Color(0xFF76CFF7),

    accentSoft: Color(0xFFECE8FF),
    accentSecondarySoft: Color(0xFFFFE5F1),

    glass: Color(0xBFFFFFFF),
    glassStrong: Color(0xF2FFFFFF),
    glassBorder: Color(0xCCFFFFFF),

    playback: Color(0xFF2B2230),
    playbackSoft: Color(0xFFF4EAF4),

    sparkle: Color(0xFFFFB8D4),
    glow: Color(0x55FF9FC7),

    fabulous: true,
  );

  @override
  AuscultaThemeExtension copyWith({
    Color? background,
    Color? backgroundSecondary,
    Color? surface,
    Color? surfaceSoft,
    Color? surfaceStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textFaint,
    Color? accentPrimary,
    Color? accentSecondary,
    Color? accentTertiary,
    Color? accentSoft,
    Color? accentSecondarySoft,
    Color? glass,
    Color? glassStrong,
    Color? glassBorder,
    Color? playback,
    Color? playbackSoft,
    Color? sparkle,
    Color? glow,
    bool? fabulous,
  }) {
    return AuscultaThemeExtension(
      background: background ?? this.background,
      backgroundSecondary:
          backgroundSecondary ?? this.backgroundSecondary,
      surface: surface ?? this.surface,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      surfaceStrong: surfaceStrong ?? this.surfaceStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textFaint: textFaint ?? this.textFaint,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      accentTertiary: accentTertiary ?? this.accentTertiary,
      accentSoft: accentSoft ?? this.accentSoft,
      accentSecondarySoft:
          accentSecondarySoft ?? this.accentSecondarySoft,
      glass: glass ?? this.glass,
      glassStrong: glassStrong ?? this.glassStrong,
      glassBorder: glassBorder ?? this.glassBorder,
      playback: playback ?? this.playback,
      playbackSoft: playbackSoft ?? this.playbackSoft,
      sparkle: sparkle ?? this.sparkle,
      glow: glow ?? this.glow,
      fabulous: fabulous ?? this.fabulous,
    );
  }

  @override
  AuscultaThemeExtension lerp(
    covariant ThemeExtension<AuscultaThemeExtension>? other,
    double t,
  ) {
    if (other is! AuscultaThemeExtension) {
      return this;
    }

    return AuscultaThemeExtension(
      background:
          Color.lerp(background, other.background, t)!,
      backgroundSecondary:
          Color.lerp(
            backgroundSecondary,
            other.backgroundSecondary,
            t,
          )!,
      surface:
          Color.lerp(surface, other.surface, t)!,
      surfaceSoft:
          Color.lerp(surfaceSoft, other.surfaceSoft, t)!,
      surfaceStrong:
          Color.lerp(surfaceStrong, other.surfaceStrong, t)!,
      textPrimary:
          Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary:
          Color.lerp(textTertiary, other.textTertiary, t)!,
      textFaint:
          Color.lerp(textFaint, other.textFaint, t)!,
      accentPrimary:
          Color.lerp(accentPrimary, other.accentPrimary, t)!,
      accentSecondary:
          Color.lerp(accentSecondary, other.accentSecondary, t)!,
      accentTertiary:
          Color.lerp(accentTertiary, other.accentTertiary, t)!,
      accentSoft:
          Color.lerp(accentSoft, other.accentSoft, t)!,
      accentSecondarySoft:
          Color.lerp(
            accentSecondarySoft,
            other.accentSecondarySoft,
            t,
          )!,
      glass:
          Color.lerp(glass, other.glass, t)!,
      glassStrong:
          Color.lerp(glassStrong, other.glassStrong, t)!,
      glassBorder:
          Color.lerp(glassBorder, other.glassBorder, t)!,
      playback:
          Color.lerp(playback, other.playback, t)!,
      playbackSoft:
          Color.lerp(playbackSoft, other.playbackSoft, t)!,
      sparkle:
          Color.lerp(sparkle, other.sparkle, t)!,
      glow:
          Color.lerp(glow, other.glow, t)!,
      fabulous: t < 0.5 ? fabulous : other.fabulous,
    );
  }
}

/// ---------------------------------------------------------------------------
/// LEGACY / SHARED COLOR TOKENS
/// ---------------------------------------------------------------------------
///
/// Existing widgets currently use AppColors directly.
/// These remain here so we don't have to rewrite the entire app at once.
///
/// Later, components can gradually migrate to the theme extension.
/// ---------------------------------------------------------------------------

abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Background
  // ---------------------------------------------------------------------------

  static const background = Color(0xFFF7F7F5);
  static const backgroundWarm = Color(0xFFFAFAF8);

  // ---------------------------------------------------------------------------
  // Surfaces
  // ---------------------------------------------------------------------------

  static const surface = Color(0xFFFFFFFF);
  static const surfaceSoft = Color(0xFFF2F2F0);
  static const surfaceMuted = Color(0xFFEDEDEB);

  // ---------------------------------------------------------------------------
  // Typography
  // ---------------------------------------------------------------------------

  static const textPrimary = Color(0xFF171717);
  static const textSecondary = Color(0xFF737373);
  static const textTertiary = Color(0xFFA3A3A3);
  static const textFaint = Color(0xFFC0C0C0);

  // ---------------------------------------------------------------------------
  // Accent system
  // ---------------------------------------------------------------------------

  static const blue = Color(0xFF8CB8FF);
  static const blueSoft = Color(0xFFDDEAFF);

  static const pink = Color(0xFFF2A9C5);
  static const pinkSoft = Color(0xFFFBE3ED);

  static const lavender = Color(0xFFB9A9F7);
  static const lavenderSoft = Color(0xFFECE7FF);

  // ---------------------------------------------------------------------------
  // Glass
  // ---------------------------------------------------------------------------

  static const glassWhite = Color(0xBFFFFFFF);
  static const glassWhiteStrong = Color(0xE6FFFFFF);

  static const glassBorder = Color(0x55FFFFFF);
  static const subtleBorder = Color(0x16000000);

  // ---------------------------------------------------------------------------
  // Playback
  // ---------------------------------------------------------------------------

  static const playbackDark = Color(0xFF191919);
  static const playbackSoft = Color(0xFFF0F0EE);
}

/// ---------------------------------------------------------------------------
/// SPACING
/// ---------------------------------------------------------------------------

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 40.0;
  static const huge = 52.0;
}

/// ---------------------------------------------------------------------------
/// RADIUS
/// ---------------------------------------------------------------------------

abstract final class AppRadius {
  static const small = 12.0;
  static const medium = 18.0;
  static const large = 24.0;
  static const extraLarge = 30.0;
  static const pill = 100.0;
}

/// ---------------------------------------------------------------------------
/// THEME FACTORY
/// ---------------------------------------------------------------------------

abstract final class AppTheme {
  static ThemeData get clarity {
    return _buildTheme(
      AuscultaThemeExtension.clarity,
      Brightness.light,
    );
  }

  static ThemeData get noir {
    return _buildTheme(
      AuscultaThemeExtension.noir,
      Brightness.dark,
    );
  }

  static ThemeData get ananya {
    return _buildTheme(
      AuscultaThemeExtension.ananya,
      Brightness.light,
    );
  }

  static ThemeData forTheme(AuscultaTheme theme) {
    switch (theme) {
      case AuscultaTheme.clarity:
        return clarity;

      case AuscultaTheme.noir:
        return noir;

      case AuscultaTheme.ananya:
        return ananya;
    }
  }

  static ThemeData _buildTheme(
    AuscultaThemeExtension colors,
    Brightness brightness,
  ) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,

      scaffoldBackgroundColor: colors.background,

      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.accentPrimary,
        onPrimary: brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        secondary: colors.accentSecondary,
        onSecondary: brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        error: const Color(0xFFFF5C67),
        onError: Colors.white,
      ),

      fontFamily: 'sans',

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      dividerTheme: DividerThemeData(
        color: brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.08),
        thickness: 1,
        space: 1,
      ),

      splashFactory: InkSparkle.splashFactory,

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android:
              FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS:
              CupertinoPageTransitionsBuilder(),
        },
      ),

      extensions: <ThemeExtension<dynamic>>[
        colors,
      ],
    );
  }
}