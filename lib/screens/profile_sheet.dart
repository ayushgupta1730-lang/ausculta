import 'dart:ui';

import 'package:flutter/material.dart';

import '../services/library_service.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';
import '../widgets/glass_card.dart';

class ProfileSheet extends StatefulWidget {
  const ProfileSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.22),
      builder: (_) => const ProfileSheet(),
    );
  }

  @override
  State<ProfileSheet> createState() => _ProfileSheetState();
}

class _ProfileSheetState extends State<ProfileSheet> {
  final ThemeController _themeController = ThemeController.instance;
  final LibraryService _libraryService = LibraryService.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNoir = _themeController.theme == AuscultaTheme.noir;
    final isAnanya = _themeController.theme == AuscultaTheme.ananya;

    final background = isNoir
        ? const Color(0xFF111113)
        : isAnanya
            ? const Color(0xFFF9F4FA)
            : const Color(0xFFF7F7F5);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.96),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(34),
        ),
      ),
      child: Stack(
        children: [
          if (isAnanya) const _AnanyaAtmosphere(),

          DraggableScrollableSheet(
            initialChildSize: 0.76,
            minChildSize: 0.55,
            maxChildSize: 0.92,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SheetHandle(),

                    const SizedBox(height: 24),

                    _ProfileHeader(
                      isAnanya: isAnanya,
                      isNoir: isNoir,
                    ),

                    const SizedBox(height: 24),

                    _LibraryStats(
                      favorites: _libraryService.favoriteCount,
                      recentlyPlayed:
                          _libraryService.recentlyPlayedCount,
                      isAnanya: isAnanya,
                      isNoir: isNoir,
                    ),

                    const SizedBox(height: 30),

                    _SectionLabel(
                      title: 'APPEARANCE',
                      isNoir: isNoir,
                    ),

                    const SizedBox(height: 12),

                    _AppearanceSelector(
                      selectedTheme: _themeController.theme,
                      isAnanya: isAnanya,
                      isNoir: isNoir,
                      onThemeSelected: (theme) async {
                        await _themeController.setTheme(theme);

                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),

                    const SizedBox(height: 30),

                    _SectionLabel(
                      title: 'AUSCULTA',
                      isNoir: isNoir,
                    ),

                    const SizedBox(height: 12),

                    _ControlRow(
                      icon: Icons.settings_rounded,
                      title: 'Settings',
                      subtitle: 'App preferences and playback',
                      isAnanya: isAnanya,
                      isNoir: isNoir,
                      onTap: () {
                        _showComingSoon(
                          context,
                          title: 'Settings',
                          message:
                              'Settings will be added here as Ausculta grows.',
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    _ControlRow(
                      icon: Icons.info_outline_rounded,
                      title: 'About Ausculta',
                      subtitle: 'A little about this app',
                      isAnanya: isAnanya,
                      isNoir: isNoir,
                      onTap: () {
                        _showAbout(context);
                      },
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          isAnanya
                              ? 'Made with a little extra sparkle ✦'
                              : 'Ausculta · Made for learning',
                          key: ValueKey(isAnanya),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.34),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showComingSoon(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _SimpleInfoSheet(
          title: title,
          message: message,
        );
      },
    );
  }

  void _showAbout(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const _SimpleInfoSheet(
          title: 'About Ausculta',
          message:
              'Ausculta is a personal auscultation sound library designed '
              'for focused medical learning and listening practice.',
        );
      },
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42,
        height: 5,
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final bool isAnanya;
  final bool isNoir;

  const _ProfileHeader({
    required this.isAnanya,
    required this.isNoir,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = Theme.of(context).colorScheme.onSurface;

    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isAnanya
                  ? [
                      AppColors.pinkSoft,
                      AppColors.lavenderSoft,
                      AppColors.blueSoft,
                    ]
                  : isNoir
                      ? [
                          Colors.white.withValues(alpha: 0.12),
                          Colors.white.withValues(alpha: 0.04),
                        ]
                      : [
                          AppColors.blueSoft,
                          Colors.white,
                        ],
            ),
            border: Border.all(
              color: isNoir
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.9),
              width: 1,
            ),
            boxShadow: isAnanya
                ? [
                    BoxShadow(
                      color: AppColors.pink.withValues(alpha: 0.14),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.person_rounded,
                size: 31,
                color: foreground.withValues(alpha: 0.72),
              ),
              if (isAnanya)
                Positioned(
                  top: 7,
                  right: 8,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 13,
                    color: AppColors.pink,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ananya',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  color: foreground,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                isAnanya
                    ? 'Your little Ausculta space ✦'
                    : 'Your personal Ausculta space',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: foreground.withValues(alpha: 0.48),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LibraryStats extends StatelessWidget {
  final int favorites;
  final int recentlyPlayed;
  final bool isAnanya;
  final bool isNoir;

  const _LibraryStats({
    required this.favorites,
    required this.recentlyPlayed,
    required this.isAnanya,
    required this.isNoir,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      blur: 22,
      tint: isNoir
          ? Colors.white.withValues(alpha: 0.055)
          : isAnanya
              ? Colors.white.withValues(alpha: 0.62)
              : Colors.white.withValues(alpha: 0.78),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                icon: Icons.favorite_rounded,
                value: favorites,
                label: 'Favorites',
                accent: isAnanya
                    ? AppColors.pink
                    : Theme.of(context).colorScheme.primary,
                isNoir: isNoir,
              ),
            ),
            Container(
              width: 1,
              margin: const EdgeInsets.symmetric(vertical: 17),
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.07),
            ),
            Expanded(
              child: _StatItem(
                icon: Icons.history_rounded,
                value: recentlyPlayed,
                label: 'Recently Played',
                accent: isAnanya
                    ? AppColors.lavender
                    : Theme.of(context).colorScheme.primary,
                isNoir: isNoir,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final Color accent;
  final bool isNoir;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
    required this.isNoir,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 12,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 18,
            color: accent,
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: foreground,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: foreground.withValues(alpha: 0.42),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final bool isNoir;

  const _SectionLabel({
    required this.title,
    required this.isNoir,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.25,
        color: Theme.of(context)
            .colorScheme
            .onSurface
            .withValues(alpha: 0.38),
      ),
    );
  }
}

class _AppearanceSelector extends StatelessWidget {
  final AuscultaTheme selectedTheme;
  final bool isAnanya;
  final bool isNoir;
  final ValueChanged<AuscultaTheme> onThemeSelected;

  const _AppearanceSelector({
    required this.selectedTheme,
    required this.isAnanya,
    required this.isNoir,
    required this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ThemeOption(
            theme: AuscultaTheme.clarity,
            selectedTheme: selectedTheme,
            icon: Icons.wb_sunny_rounded,
            title: 'Clarity',
            subtitle: 'Light',
            accent: AppColors.blue,
            onTap: () => onThemeSelected(AuscultaTheme.clarity),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ThemeOption(
            theme: AuscultaTheme.noir,
            selectedTheme: selectedTheme,
            icon: Icons.nightlight_round,
            title: 'Noir',
            subtitle: 'Dark',
            accent: const Color(0xFF8E8E9A),
            onTap: () => onThemeSelected(AuscultaTheme.noir),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ThemeOption(
            theme: AuscultaTheme.ananya,
            selectedTheme: selectedTheme,
            icon: Icons.auto_awesome_rounded,
            title: 'Ananya',
            subtitle: '✦ Special',
            accent: AppColors.pink,
            onTap: () => onThemeSelected(AuscultaTheme.ananya),
          ),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final AuscultaTheme theme;
  final AuscultaTheme selectedTheme;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.theme,
    required this.selectedTheme,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = theme == selectedTheme;
    final isNoir = Theme.of(context).brightness == Brightness.dark;
    final foreground = Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent.withValues(alpha: isNoir ? 0.24 : 0.16),
                    accent.withValues(alpha: isNoir ? 0.09 : 0.05),
                  ],
                )
              : null,
          color: selected
              ? null
              : foreground.withValues(alpha: isNoir ? 0.035 : 0.025),
          border: Border.all(
            color: selected
                ? accent.withValues(alpha: 0.48)
                : foreground.withValues(alpha: 0.07),
            width: selected ? 1.2 : 0.8,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.10),
                    blurRadius: 18,
                    spreadRadius: -3,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? accent.withValues(alpha: 0.16)
                    : foreground.withValues(alpha: 0.05),
              ),
              child: Icon(
                icon,
                size: 18,
                color: selected
                    ? accent
                    : foreground.withValues(alpha: 0.48),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: foreground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                color: foreground.withValues(alpha: 0.38),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: selected ? 1 : 0,
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isAnanya;
  final bool isNoir;
  final VoidCallback onTap;

  const _ControlRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isAnanya,
    required this.isNoir,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = Theme.of(context).colorScheme.onSurface;

    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 13,
      ),
      borderRadius: BorderRadius.circular(20),
      blur: 20,
      tint: isNoir
          ? Colors.white.withValues(alpha: 0.045)
          : isAnanya
              ? Colors.white.withValues(alpha: 0.60)
              : Colors.white.withValues(alpha: 0.76),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isAnanya
                  ? AppColors.pinkSoft.withValues(alpha: 0.72)
                  : foreground.withValues(alpha: 0.055),
            ),
            child: Icon(
              icon,
              size: 18,
              color: isAnanya
                  ? AppColors.pink
                  : foreground.withValues(alpha: 0.62),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: foreground.withValues(alpha: 0.40),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: foreground.withValues(alpha: 0.25),
          ),
        ],
      ),
    );
  }
}

class _AnanyaAtmosphere extends StatelessWidget {
  const _AnanyaAtmosphere();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        height: 430,
        child: Stack(
          children: [
            Positioned(
              top: -100,
              left: -80,
              child: _GlowBlob(
                size: 260,
                color: AppColors.pink.withValues(alpha: 0.10),
              ),
            ),
            Positioned(
              top: -70,
              right: -100,
              child: _GlowBlob(
                size: 280,
                color: AppColors.lavender.withValues(alpha: 0.10),
              ),
            ),
            Positioned(
              top: 110,
              right: 30,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 11,
                color: AppColors.pink.withValues(alpha: 0.45),
              ),
            ),
            Positioned(
              top: 180,
              left: 24,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 8,
                color: AppColors.lavender.withValues(alpha: 0.42),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowBlob({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 45,
        sigmaY: 45,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class _SimpleInfoSheet extends StatelessWidget {
  final String title;
  final String message;

  const _SimpleInfoSheet({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = Theme.of(context).colorScheme.onSurface;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          22,
          12,
          22,
          28,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 22),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                color: foreground,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: foreground.withValues(alpha: 0.50),
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}