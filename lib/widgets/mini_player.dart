import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class MiniPlayer extends StatelessWidget {
  final VoidCallback? onTap;

  const MiniPlayer({
    super.key,
    this.onTap,
  });

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService.instance;
    final sound = audioService.currentSound;

    if (sound == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<PlayerState>(
      stream: audioService.playerStateStream,
      builder: (context, stateSnapshot) {
        final playerState = stateSnapshot.data;
        final isPlaying = playerState?.playing ?? false;

        return StreamBuilder<Duration>(
          stream: audioService.positionStream,
          builder: (context, positionSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;

            return StreamBuilder<Duration?>(
              stream: audioService.durationStream,
              builder: (context, durationSnapshot) {
                final duration =
                    durationSnapshot.data ?? Duration.zero;

                final maximumMilliseconds =
                    duration.inMilliseconds > 0
                        ? duration.inMilliseconds
                        : 1;

                final currentMilliseconds = position.inMilliseconds
                    .clamp(0, maximumMilliseconds);

                final progress =
                    currentMilliseconds / maximumMilliseconds;

                return GestureDetector(
                  onTap: onTap,
                  behavior: HitTestBehavior.opaque,
                  child: GlassCard(
                    padding: const EdgeInsets.fromLTRB(
                      14,
                      12,
                      12,
                      11,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    blur: 28,
                    tint: Colors.white.withValues(alpha: 0.78),
                    showShadow: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            _MiniPlayerArtwork(
                              accent: sound.accent,
                              isPlaying: isPlaying,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'NOW PLAYING',
                                    style: TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.0,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    sound.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.25,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            _MiniPlayButton(
                              isPlaying: isPlaying,
                              accent: sound.accent,
                              onTap: () async {
                                if (isPlaying) {
                                  await audioService.pause();
                                } else {
                                  await audioService.resume();
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 9),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2.5,
                            thumbShape:
                                const RoundSliderThumbShape(
                              enabledThumbRadius: 4,
                            ),
                            overlayShape:
                                const RoundSliderOverlayShape(
                              overlayRadius: 12,
                            ),
                            activeTrackColor: sound.accent,
                            inactiveTrackColor:
                                AppColors.textPrimary
                                    .withValues(alpha: 0.08),
                            thumbColor: sound.accent,
                            overlayColor:
                                sound.accent.withValues(alpha: 0.12),
                          ),
                          child: Slider(
                            value: progress,
                            min: 0,
                            max: 1,
                            onChanged: duration.inMilliseconds <= 0
                                ? null
                                : (value) {
                                    final newPosition =
                                        duration * value;

                                    audioService.seek(
                                      newPosition,
                                    );
                                  },
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textTertiary,
                              ),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textTertiary,
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
          },
        );
      },
    );
  }
}

class _MiniPlayerArtwork extends StatelessWidget {
  final Color accent;
  final bool isPlaying;

  const _MiniPlayerArtwork({
    required this.accent,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(
              alpha: isPlaying ? 0.32 : 0.22,
            ),
            Colors.white.withValues(alpha: 0.72),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.9),
          width: 0.8,
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 21,
          height: 19,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _MiniWaveLine(
                height: isPlaying ? 9 : 6,
                color: accent,
              ),
              _MiniWaveLine(
                height: isPlaying ? 15 : 11,
                color: accent,
              ),
              _MiniWaveLine(
                height: isPlaying ? 18 : 15,
                color: accent,
              ),
              _MiniWaveLine(
                height: isPlaying ? 13 : 9,
                color: accent,
              ),
              _MiniWaveLine(
                height: isPlaying ? 8 : 5,
                color: accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniWaveLine extends StatelessWidget {
  final double height;
  final Color color;

  const _MiniWaveLine({
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      width: 2.2,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _MiniPlayButton extends StatelessWidget {
  final bool isPlaying;
  final Color accent;
  final VoidCallback onTap;

  const _MiniPlayButton({
    required this.isPlaying,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 39,
        height: 39,
        decoration: BoxDecoration(
          color: isPlaying
              ? accent.withValues(alpha: 0.92)
              : AppColors.playbackDark,
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: Icon(
            isPlaying
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            key: ValueKey(isPlaying),
            color: Colors.white,
            size: isPlaying ? 18 : 20,
          ),
        ),
      ),
    );
  }
}