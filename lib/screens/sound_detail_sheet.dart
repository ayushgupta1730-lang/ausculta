import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/sound_model.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';

class SoundDetailSheet extends StatelessWidget {
  final Sound sound;

  const SoundDetailSheet({
    super.key,
    required this.sound,
  });

  static Future<void> show(
    BuildContext context,
    Sound sound,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.22),
      builder: (_) {
        return SoundDetailSheet(sound: sound);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService.instance;

    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.55,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundWarm,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32),
            ),
          ),
          child: Stack(
            children: [
              ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                  24,
                  12,
                  24,
                  40,
                ),
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _Header(
                    sound: sound,
                    onClose: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 30),
                  _LargeWaveform(
                    accent: sound.accent,
                  ),
                  const SizedBox(height: 28),
                  _PlaybackControls(
                    sound: sound,
                    audioService: audioService,
                  ),
                  const SizedBox(height: 34),
                  _InformationSection(
                    sound: sound,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final Sound sound;
  final VoidCallback onClose;

  const _Header({
    required this.sound,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AUSCULTATION',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                sound.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 25,
                  height: 1.05,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.9,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onClose,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.045),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close_rounded,
              size: 19,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _LargeWaveform extends StatelessWidget {
  final Color accent;

  const _LargeWaveform({
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    const heights = [
      30.0,
      54.0,
      38.0,
      76.0,
      48.0,
      94.0,
      62.0,
      42.0,
      72.0,
      34.0,
      58.0,
      86.0,
      44.0,
      68.0,
      38.0,
      56.0,
      30.0,
    ];

    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.13),
            Colors.white.withValues(alpha: 0.72),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.9),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: heights.map((height) {
          return Container(
            width: 3,
            height: height,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PlaybackControls extends StatelessWidget {
  final Sound sound;
  final AudioService audioService;

  const _PlaybackControls({
    required this.sound,
    required this.audioService,
  });

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioService.playerStateStream,
      builder: (context, playerSnapshot) {
        final playerState = playerSnapshot.data;

        final isCurrent =
            audioService.currentSound?.id == sound.id;

        final isPlaying =
            isCurrent && (playerState?.playing ?? false);

        return StreamBuilder<Duration>(
          stream: audioService.positionStream,
          builder: (context, positionSnapshot) {
            final position =
                positionSnapshot.data ?? Duration.zero;

            return StreamBuilder<Duration?>(
              stream: audioService.durationStream,
              builder: (context, durationSnapshot) {
                final duration =
                    durationSnapshot.data ?? Duration.zero;

                final maxMilliseconds =
                    duration.inMilliseconds > 0
                        ? duration.inMilliseconds
                        : 1;

                final currentMilliseconds =
                    position.inMilliseconds.clamp(
                  0,
                  maxMilliseconds,
                );

                final progress =
                    currentMilliseconds / maxMilliseconds;

                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape:
                            const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape:
                            const RoundSliderOverlayShape(
                          overlayRadius: 16,
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
                        onChanged:
                            duration.inMilliseconds <= 0
                                ? null
                                : (value) {
                                    audioService.seek(
                                      duration * value,
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
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Text(
                          _formatDuration(duration),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        _RoundControl(
                          icon: Icons.replay_10_rounded,
                          onTap: () {
                            audioService.seekBackward(
                              const Duration(seconds: 10),
                            );
                          },
                        ),
                        const SizedBox(width: 22),
                        GestureDetector(
                          onTap: () async {
                            if (!isCurrent) {
                              await audioService.play(sound);
                              return;
                            }

                            if (isPlaying) {
                              await audioService.pause();
                            } else {
                              await audioService.resume();
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 180,
                            ),
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: sound.accent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: sound.accent.withValues(
                                    alpha: 0.24,
                                  ),
                                  blurRadius: 22,
                                  spreadRadius: -3,
                                  offset: const Offset(0, 9),
                                ),
                              ],
                            ),
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 31,
                            ),
                          ),
                        ),
                        const SizedBox(width: 22),
                        _RoundControl(
                          icon: Icons.forward_10_rounded,
                          onTap: () {
                            audioService.seekForward(
                              const Duration(seconds: 10),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _RoundControl extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundControl({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.045),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 22,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _InformationSection extends StatelessWidget {
  final Sound sound;

  const _InformationSection({
    required this.sound,
  });

  @override
  Widget build(BuildContext context) {
    final information = <_InformationItem>[
      _InformationItem(
        title: 'Characteristics',
        value: sound.characteristics,
      ),
      _InformationItem(
        title: 'Location',
        value: sound.location,
      ),
      _InformationItem(
        title: 'Pitch',
        value: sound.pitch,
      ),
      _InformationItem(
        title: 'Timing',
        value: sound.timing,
      ),
      _InformationItem(
        title: 'Conditions',
        value: sound.conditions,
      ),
    ].where((item) {
      return item.value != null &&
          item.value!.trim().isNotEmpty;
    }).toList();

    if (information.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ABOUT THIS SOUND',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 12),
        ...information.map(
          (item) => Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: _InformationCard(
              item: item,
              accent: sound.accent,
            ),
          ),
        ),
      ],
    );
  }
}

class _InformationItem {
  final String title;
  final String? value;

  const _InformationItem({
    required this.title,
    required this.value,
  });
}

class _InformationCard extends StatelessWidget {
  final _InformationItem item;
  final Color accent;

  const _InformationCard({
    required this.item,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.85),
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(
              top: 5,
              right: 11,
            ),
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.value!,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}