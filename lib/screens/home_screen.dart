import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../data/sound_data.dart';
import '../models/sound_model.dart';
import '../screens/sound_detail_sheet.dart';
import '../services/audio_service.dart';
import '../services/library_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/mini_player.dart';
import 'profile_sheet.dart';


class _AuscultaPalette {
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentSoft;
  final Color pink;
  final Color blue;
  final Color lavender;
  final Color glass;
  final Color glassStrong;
  final Color playback;
  final bool fabulous;
  final bool dark;

  const _AuscultaPalette({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentSoft,
    required this.pink,
    required this.blue,
    required this.lavender,
    required this.glass,
    required this.glassStrong,
    required this.playback,
    required this.fabulous,
    required this.dark,
  });

  factory _AuscultaPalette.of(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final extension =
        theme.extension<AuscultaThemeExtension>();
    final fabulous = extension?.fabulous ?? false;
    final dark = theme.brightness == Brightness.dark;

    final pink = fabulous
        ? AppColors.pink
        : (dark ? const Color(0xFFC89AB0) : AppColors.pink);

    final blue = fabulous
        ? AppColors.blue
        : (dark ? const Color(0xFF9DBDFF) : AppColors.blue);

    final lavender = fabulous
        ? AppColors.lavender
        : (dark ? const Color(0xFFB8AAEE) : AppColors.lavender);

    return _AuscultaPalette(
      background: theme.scaffoldBackgroundColor,
      surface: scheme.surface,
      textPrimary: scheme.onSurface,
      textSecondary: scheme.onSurface.withValues(alpha: 0.62),
      textTertiary: scheme.onSurface.withValues(alpha: 0.42),
      accent: scheme.primary,
      accentSoft: scheme.primary.withValues(alpha: 0.12),
      pink: pink,
      blue: blue,
      lavender: lavender,
      glass: scheme.surface.withValues(alpha: dark ? 0.52 : 0.62),
      glassStrong: scheme.surface.withValues(alpha: dark ? 0.72 : 0.80),
      playback: scheme.onSurface,
      fabulous: fabulous,
      dark: dark,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  String _query = '';

  bool _libraryReady = false;

  LibraryService get _libraryService => LibraryService.instance;

  List<Sound> get _filteredSounds {
    return SoundData.search(_query);
  }

  List<Sound> get _favoriteSounds {
    return _libraryService.favoriteSounds;
  }

  List<Sound> get _recentSounds {
    return _libraryService.recentlyPlayedSounds;
  }

  @override
  void initState() {
    super.initState();

    _initializeLibrary();
  }

  Future<void> _initializeLibrary() async {
    await _libraryService.initialize();

    if (!mounted) {
      return;
    }

    setState(() {
      _libraryReady = true;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();

    super.dispose();
  }

  // ===========================================================================
  // SEARCH
  // ===========================================================================

  void _onSearchChanged(String value) {
    setState(() {
      _query = value;
    });
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _query = '';
    });

    _searchFocusNode.requestFocus();
  }

  // ===========================================================================
  // PLAYBACK
  // ===========================================================================

  Future<void> _toggleSound(Sound sound) async {
    final audioService = AudioService.instance;

    try {
      final wasPlayingSameSound =
          audioService.isCurrent(sound) && audioService.isPlaying;

      await audioService.toggle(sound);

      if (!mounted) {
        return;
      }

      // Add to recent history whenever the user actually starts/resumes
      // a sound rather than when they pause it.
      if (!wasPlayingSameSound) {
        await _libraryService.addRecentlyPlayed(sound.id);
      }

      setState(() {});
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            0,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.medium,
            ),
          ),
          content: Text(
            'Couldn\'t play ${sound.name}.',
          ),
        ),
      );
    }
  }

  // ===========================================================================
  // FAVORITES
  // ===========================================================================

  Future<void> _toggleFavorite(Sound sound) async {
    final isFavorite =
        await _libraryService.toggleFavorite(sound.id);

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1300),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.medium,
          ),
        ),
        content: Text(
          isFavorite
              ? '${sound.name} added to Favorites'
              : '${sound.name} removed from Favorites',
        ),
      ),
    );
  }

  // ===========================================================================
  // NOW PLAYING
  // ===========================================================================

  Future<void> _openNowPlaying() async {
    final sound = AudioService.instance.currentSound;

    if (sound == null || !mounted) {
      return;
    }

    await SoundDetailSheet.show(
      context,
      sound,
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ===========================================================================
  // SOUND DETAIL
  // ===========================================================================

  Future<void> _openSound(Sound sound) async {
    await SoundDetailSheet.show(
      context,
      sound,
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final sounds = _filteredSounds;
    final isSearching = _query.trim().isNotEmpty;
    final palette = _AuscultaPalette.of(context);

    final screenWidth = MediaQuery.sizeOf(context).width;

    // Phone layout stays unchanged.
    // Tablets use a centered, width-aware layout and a responsive grid.
    final isTablet = screenWidth >= 700;
    final isWideTablet = screenWidth >= 1000;

    final contentWidth = isTablet ? 1200.0 : double.infinity;
    final horizontalPadding =
        isTablet ? (isWideTablet ? 48.0 : 40.0) : AppSpacing.xl;

    final showPersonalSections =
        !isSearching &&
        _libraryReady &&
        (_favoriteSounds.isNotEmpty ||
            _recentSounds.isNotEmpty);

    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundAtmosphere(),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: contentWidth,
                ),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    // =================================================================
                    // HEADER
                    // =================================================================

                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        isTablet ? 28.0 : AppSpacing.lg,
                        horizontalPadding,
                        0,
                      ),
                      sliver: const SliverToBoxAdapter(
                        child: _Header(),
                      ),
                    ),

                    // =================================================================
                    // SEARCH
                    // =================================================================

                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        isTablet ? 28.0 : AppSpacing.xl,
                        horizontalPadding,
                        0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _SearchBar(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          query: _query,
                          onChanged: _onSearchChanged,
                          onClear: _clearSearch,
                        ),
                      ),
                    ),

                    // =================================================================
                    // PERSONAL SECTIONS
                    // =================================================================

                    if (showPersonalSections) ...[
                      if (_favoriteSounds.isNotEmpty)
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            isTablet ? 34.0 : AppSpacing.xxl,
                            horizontalPadding,
                            0,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: _PersonalSectionHeader(
                              title: 'Favorites',
                              subtitle: 'Sounds you want close',
                              icon: Icons.favorite_rounded,
                              accent: palette.pink,
                              count: _favoriteSounds.length,
                            ),
                          ),
                        ),

                      if (_favoriteSounds.isNotEmpty)
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            AppSpacing.md,
                            horizontalPadding,
                            0,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: _HorizontalSoundList(
                              sounds: _favoriteSounds,
                              onPlay: _toggleSound,
                              onTap: _openSound,
                              onFavorite: _toggleFavorite,
                              isTablet: isTablet,
                            ),
                          ),
                        ),

                      if (_recentSounds.isNotEmpty)
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            isTablet ? 34.0 : AppSpacing.xxl,
                            horizontalPadding,
                            0,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: _PersonalSectionHeader(
                              title: 'Recently Played',
                              subtitle: 'Pick up where you left off',
                              icon: Icons.history_rounded,
                              accent: palette.blue,
                              count: _recentSounds.length,
                            ),
                          ),
                        ),

                      if (_recentSounds.isNotEmpty)
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            AppSpacing.md,
                            horizontalPadding,
                            0,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: _HorizontalSoundList(
                              sounds: _recentSounds,
                              onPlay: _toggleSound,
                              onTap: _openSound,
                              onFavorite: _toggleFavorite,
                              isTablet: isTablet,
                            ),
                          ),
                        ),
                    ],

                    // =================================================================
                    // MAIN SOUND LIBRARY HEADER
                    // =================================================================

                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        showPersonalSections
                            ? (isTablet ? 42.0 : AppSpacing.xxxl)
                            : (isTablet ? 48.0 : AppSpacing.huge),
                        horizontalPadding,
                        isTablet ? 20.0 : AppSpacing.lg,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: isSearching ? 'Results' : 'Sounds',
                          subtitle: isSearching
                              ? 'Matching your search'
                              : 'Your auscultation library',
                          count: sounds.length,
                        ),
                      ),
                    ),

                    // =================================================================
                    // EMPTY SEARCH
                    // =================================================================

                    if (sounds.isEmpty)
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          AppSpacing.md,
                          horizontalPadding,
                          0,
                        ),
                        sliver: const SliverToBoxAdapter(
                          child: _EmptySearchState(),
                        ),
                      )
                    else if (!isTablet)
                      // ===============================================================
                      // PHONE SOUND LIST
                      // ===============================================================

                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                        ),
                        sliver: SliverList.builder(
                          itemCount: sounds.length,
                          itemBuilder: (context, index) {
                            final sound = sounds[index];

                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.md,
                              ),
                              child: _SoundCard(
                                sound: sound,
                                isFavorite:
                                    _libraryService.isFavorite(sound.id),
                                onPlay: () => _toggleSound(sound),
                                onTap: () => _openSound(sound),
                                onFavorite: () =>
                                    _toggleFavorite(sound),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      // ===============================================================
                      // TABLET SOUND GRID
                      //
                      // Portrait tablet: 2 columns.
                      // Wide tablet / iPad landscape: 3 columns.
                      // ===============================================================

                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final sound = sounds[index];

                              return _SoundCard(
                                sound: sound,
                                isFavorite:
                                    _libraryService.isFavorite(sound.id),
                                onPlay: () => _toggleSound(sound),
                                onTap: () => _openSound(sound),
                                onFavorite: () =>
                                    _toggleFavorite(sound),
                              );
                            },
                            childCount: sounds.length,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isWideTablet ? 3 : 2,
                            crossAxisSpacing: isWideTablet ? 18.0 : 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio:
                                isWideTablet ? 2.75 : 2.65,
                          ),
                        ),
                      ),

                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: isTablet ? 210.0 : 190.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // =====================================================================
          // MINI PLAYER
          // =====================================================================

          if (MediaQuery.of(context).viewInsets.bottom == 0)
            Positioned(
              left: isTablet ? 24.0 : AppSpacing.lg,
              right: isTablet ? 24.0 : AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: SafeArea(
                top: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 760.0 : double.infinity,
                    ),
                    child: _MiniPlayerHost(
                      onTap: _openNowPlaying,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// =============================================================================
// MINI PLAYER HOST
// =============================================================================

class _MiniPlayerHost extends StatelessWidget {
  final VoidCallback onTap;

  const _MiniPlayerHost({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: AudioService.instance.playerStateStream,
      builder: (context, snapshot) {
        final sound = AudioService.instance.currentSound;

        if (sound == null) {
          return const SizedBox.shrink();
        }

        return MiniPlayer(
          key: ValueKey(sound.id),
          onTap: onTap,
        );
      },
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _BackgroundAtmosphere extends StatelessWidget {
  const _BackgroundAtmosphere();

  @override
  Widget build(BuildContext context) {
    final palette = _AuscultaPalette.of(context);

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: _BlurOrb(
              size: 270,
              color: palette.blue.withValues(
                alpha: palette.fabulous ? 0.16 : 0.10,
              ),
            ),
          ),
          Positioned(
            top: 250,
            left: -130,
            child: _BlurOrb(
              size: 250,
              color: palette.pink.withValues(
                alpha: palette.fabulous ? 0.11 : 0.055,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -70,
            child: _BlurOrb(
              size: 230,
              color: palette.lavender.withValues(
                alpha: palette.fabulous ? 0.12 : 0.07,
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    palette.background,
                    Color.alphaBlend(
                      palette.accent.withValues(
                        alpha: palette.fabulous
                            ? 0.035
                            : palette.dark
                                ? 0.025
                                : 0.012,
                      ),
                      palette.background,
                    ),
                    palette.background,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 70,
                sigmaY: 70,
              ),
              child: const SizedBox(),
            ),
          ),
          if (palette.fabulous)
            Positioned(
              top: 125,
              right: 42,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 9,
                color: palette.pink.withValues(alpha: 0.42),
              ),
            ),
          if (palette.fabulous)
            Positioned(
              top: 390,
              left: 28,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 7,
                color: palette.lavender.withValues(alpha: 0.36),
              ),
            ),
        ],
      ),
    );
  }
}

class _BlurOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurOrb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 55,
        sigmaY: 55,
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

// =============================================================================
// HEADER
// =============================================================================

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final palette = _AuscultaPalette.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Heyyy Ananya 👋🏻',
                style: TextStyle(
                  fontSize: 27,
                  height: 1.05,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.05,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: palette.pink,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'Ausculta',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                      color: palette.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        const _ProfileButton(),
      ],
    );
  }
}

// =============================================================================
// PROFILE BUTTON
// =============================================================================

class _ProfileButton extends StatelessWidget {
  const _ProfileButton();

  @override
  Widget build(BuildContext context) {
    final palette = _AuscultaPalette.of(context);

    return GestureDetector(
      onTap: () {
        ProfileSheet.show(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 49,
        height: 49,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: palette.dark
                ? [
                    palette.surface.withValues(alpha: 0.92),
                    palette.accent.withValues(alpha: 0.20),
                  ]
                : palette.fabulous
                    ? [
                        AppColors.pinkSoft,
                        AppColors.lavenderSoft,
                      ]
                    : [
                        const Color(0xFFFFDCE9),
                        const Color(0xFFE5EEFF),
                      ],
          ),
          border: Border.all(
            color: palette.dark
                ? Colors.white.withValues(alpha: 0.14)
                : Colors.white.withValues(alpha: 0.95),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: palette.pink.withValues(
                alpha: palette.fabulous ? 0.12 : 0.07,
              ),
              blurRadius: 24,
              spreadRadius: -5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.person_rounded,
              size: 22,
              color: palette.textPrimary.withValues(alpha: 0.82),
            ),
            Positioned(
              right: 8,
              top: 7,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: palette.pink,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SEARCH
// =============================================================================

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final palette = _AuscultaPalette.of(context);
    final hasQuery = query.trim().isNotEmpty;

    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(AppRadius.large),
      blur: 24,
      tint: palette.glass,
      showShadow: true,
      child: SizedBox(
        height: 58,
        child: Row(
          children: [
            const SizedBox(width: 18),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: palette.surface.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.search_rounded,
                size: 18,
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                cursorColor: palette.textPrimary,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.1,
                  color: palette.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search sounds...',
                  hintStyle: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                    color: palette.textTertiary,
                  ),
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
              ),
            ),
            if (hasQuery)
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: palette.textPrimary.withValues(alpha: 0.045),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: palette.textTertiary,
                  ),
                ),
              )
            else
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.only(right: 13),
                decoration: BoxDecoration(
                  color: palette.textPrimary.withValues(alpha: 0.035),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  size: 16,
                  color: palette.textTertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PERSONAL SECTION HEADER
// =============================================================================

class _PersonalSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final int count;

  const _PersonalSectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final palette = _AuscultaPalette.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 17,
            color: accent,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: palette.textTertiary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: palette.surface.withValues(alpha: 0.58),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: palette.surface.withValues(alpha: 0.85),
              width: 0.8,
            ),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: palette.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// HORIZONTAL PERSONAL SOUND LIST
// =============================================================================

class _HorizontalSoundList extends StatelessWidget {
  final List<Sound> sounds;
  final Future<void> Function(Sound sound) onPlay;
  final Future<void> Function(Sound sound) onTap;
  final Future<void> Function(Sound sound) onFavorite;
  final bool isTablet;

  const _HorizontalSoundList({
    required this.sounds,
    required this.onPlay,
    required this.onTap,
    required this.onFavorite,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isTablet ? 158.0 : 150.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: sounds.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 11);
        },
        itemBuilder: (context, index) {
          final sound = sounds[index];

          return _CompactSoundCard(
            sound: sound,
            isFavorite:
                LibraryService.instance.isFavorite(sound.id),
            onPlay: () => onPlay(sound),
            onTap: () => onTap(sound),
            onFavorite: () => onFavorite(sound),
            isTablet: isTablet,
          );
        },
      ),
    );
  }
}

// =============================================================================
// COMPACT SOUND CARD
// =============================================================================

class _CompactSoundCard extends StatelessWidget {
  final Sound sound;
  final bool isFavorite;
  final VoidCallback onPlay;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool isTablet;

  const _CompactSoundCard({
    required this.sound,
    required this.isFavorite,
    required this.onPlay,
    required this.onTap,
    required this.onFavorite,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = _AuscultaPalette.of(context);

    return StreamBuilder<PlayerState>(
      stream: AudioService.instance.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;

        final isCurrent =
            AudioService.instance.currentSound?.id == sound.id;

        final isPlaying =
            isCurrent && (playerState?.playing ?? false);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: isTablet ? 238.0 : 220.0,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: isPlaying
                  ? sound.accent.withValues(alpha: 0.10)
                  : palette.glass,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: palette.surface.withValues(
                  alpha: palette.dark ? 0.14 : 0.88,
                ),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: palette.dark ? 0.18 : 0.035,
                  ),
                  blurRadius: 20,
                  spreadRadius: -6,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _SoundIcon(
                      accent: sound.accent,
                      isPlaying: isPlaying,
                      size: 42,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onFavorite,
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        width: 34,
                        height: 34,
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 18,
                          color: isFavorite
                              ? palette.pink
                              : palette.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  sound.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.25,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        sound.pitch ?? 'Auscultation sound',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: palette.textTertiary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onPlay,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 31,
                        height: 31,
                        decoration: BoxDecoration(
                          color: isPlaying
                              ? sound.accent
                              : palette.playback,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: palette.dark
                              ? Colors.black
                              : Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// SECTION HEADER
// =============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final int count;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final palette = _AuscultaPalette.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.65,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: palette.textTertiary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: palette.surface.withValues(alpha: 0.58),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: palette.surface.withValues(alpha: 0.85),
              width: 0.8,
            ),
          ),
          child: Text(
            '$count sounds',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: palette.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// EMPTY SEARCH STATE
// =============================================================================

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    final palette = _AuscultaPalette.of(context);

    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxxl,
      ),
      borderRadius: BorderRadius.circular(AppRadius.large),
      blur: 20,
      tint: palette.glass,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: palette.surface.withValues(alpha: 0.62),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.graphic_eq_rounded,
              color: palette.textTertiary,
              size: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No sounds found',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.25,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try searching for another auscultation sound.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: palette.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SOUND CARD
// =============================================================================

class _SoundCard extends StatelessWidget {
  final Sound sound;
  final bool isFavorite;
  final VoidCallback onPlay;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _SoundCard({
    required this.sound,
    required this.isFavorite,
    required this.onPlay,
    required this.onTap,
    required this.onFavorite,
  });

  String get _descriptor {
    final parts = <String>[];

    if (sound.pitch != null &&
        sound.pitch!.trim().isNotEmpty) {
      parts.add(sound.pitch!.trim());
    }

    if (sound.timing != null &&
        sound.timing!.trim().isNotEmpty) {
      parts.add(sound.timing!.trim());
    }

    if (parts.isNotEmpty) {
      return parts.join(' · ');
    }

    return 'Auscultation sound';
  }

  @override
  Widget build(BuildContext context) {
    final palette = _AuscultaPalette.of(context);

    return StreamBuilder<PlayerState>(
      stream: AudioService.instance.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;

        final isCurrent =
            AudioService.instance.currentSound?.id == sound.id;

        final isPlaying =
            isCurrent && (playerState?.playing ?? false);

        return GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: GlassCard(
            padding: const EdgeInsets.all(13),
            borderRadius: BorderRadius.circular(AppRadius.large),
            blur: 22,
            tint: isPlaying
                ? sound.accent.withValues(alpha: 0.08)
                : palette.glass,
            child: Row(
              children: [
                _SoundIcon(
                  accent: sound.accent,
                  isPlaying: isPlaying,
                  size: 51,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        sound.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.25,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _descriptor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: palette.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),

                GestureDetector(
                  onTap: onFavorite,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 40,
                    height: 48,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 180,
                        ),
                        transitionBuilder:
                            (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          key: ValueKey(isFavorite),
                          size: 19,
                          color: isFavorite
                              ? palette.pink
                              : palette.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 2),

                _PlayButton(
                  accent: sound.accent,
                  isPlaying: isPlaying,
                  onTap: onPlay,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// SOUND ICON
// =============================================================================

class _SoundIcon extends StatelessWidget {
  final Color accent;
  final bool isPlaying;
  final double size;

  const _SoundIcon({
    required this.accent,
    required this.isPlaying,
    this.size = 51,
  });

  @override
  Widget build(BuildContext context) {
    final palette = _AuscultaPalette.of(context);
    final innerWidth = size * 0.49;
    final innerHeight = size * 0.43;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          size * 0.33,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(
              alpha: isPlaying ? 0.32 : 0.22,
            ),
            palette.surface.withValues(
              alpha: palette.dark ? 0.22 : 0.58,
            ),
          ],
        ),
        border: Border.all(
          color: palette.surface.withValues(
            alpha: palette.dark ? 0.16 : 0.82,
          ),
          width: 0.8,
        ),
      ),
      child: Center(
        child: SizedBox(
          width: innerWidth,
          height: innerHeight,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              _WaveLine(
                height: isPlaying
                    ? size * 0.20
                    : size * 0.14,
                color: accent,
                animated: isPlaying,
              ),
              _WaveLine(
                height: isPlaying
                    ? size * 0.33
                    : size * 0.25,
                color: accent,
                animated: isPlaying,
              ),
              _WaveLine(
                height: isPlaying
                    ? size * 0.39
                    : size * 0.35,
                color: accent,
                animated: isPlaying,
              ),
              _WaveLine(
                height: isPlaying
                    ? size * 0.29
                    : size * 0.20,
                color: accent,
                animated: isPlaying,
              ),
              _WaveLine(
                height: isPlaying
                    ? size * 0.18
                    : size * 0.12,
                color: accent,
                animated: isPlaying,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaveLine extends StatelessWidget {
  final double height;
  final Color color;
  final bool animated;

  const _WaveLine({
    required this.height,
    required this.color,
    required this.animated,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      width: 2.5,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: animated ? 0.95 : 0.8,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

// =============================================================================
// PLAY BUTTON
// =============================================================================

class _PlayButton extends StatelessWidget {
  final Color accent;
  final bool isPlaying;
  final VoidCallback onTap;

  const _PlayButton({
    required this.accent,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = _AuscultaPalette.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: isPlaying
              ? accent.withValues(alpha: 0.92)
              : palette.playback,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isPlaying ? 0.15 : 0.12,
              ),
              blurRadius: 15,
              spreadRadius: -4,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 160),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: Icon(
            isPlaying
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            key: ValueKey(isPlaying),
            color: palette.dark
                ? Colors.black.withValues(alpha: 0.90)
                : Colors.white.withValues(alpha: 0.96),
            size: isPlaying ? 20 : 21,
          ),
        ),
      ),
    );
  }
}
