import 'package:just_audio/just_audio.dart';

import '../models/sound_model.dart';

/// ---------------------------------------------------------------------------
/// AUSCULTA AUDIO SERVICE
/// ---------------------------------------------------------------------------
///
/// Central audio controller for the app.
///
/// Responsibilities:
/// - Load local auscultation recordings
/// - Play / pause / resume sounds
/// - Stop playback
/// - Seek through recordings
/// - Expose playback state and progress
/// - Track which sound is currently loaded
///
/// UI code should communicate with this service instead of controlling
/// just_audio directly.
/// ---------------------------------------------------------------------------

class AudioService {
  AudioService._internal();

  static final AudioService instance = AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  Sound? _currentSound;

  /// The sound currently loaded into the audio player.
  Sound? get currentSound => _currentSound;

  /// Whether something is currently playing.
  bool get isPlaying => _player.playing;

  /// Current playback position.
  Stream<Duration> get positionStream => _player.positionStream;

  /// Duration of the currently loaded recording.
  Stream<Duration?> get durationStream => _player.durationStream;

  /// Whether the player is currently playing.
  Stream<bool> get playingStream => _player.playingStream;

  /// Complete player state stream.
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// Current playback position synchronously.
  Duration get position => _player.position;

  /// Current duration synchronously.
  Duration? get duration => _player.duration;

  /// Whether the given sound is currently loaded.
  bool isCurrent(Sound sound) {
    return _currentSound?.id == sound.id;
  }

  /// -------------------------------------------------------------------------
  /// PLAY
  /// -------------------------------------------------------------------------
  ///
  /// If the requested sound is already loaded, playback resumes from the
  /// current position.
  ///
  /// If a different sound is requested, the new asset is loaded first.
  ///
  Future<void> play(Sound sound) async {
    try {
      if (!sound.audioAvailable) {
        return;
      }

      final isDifferentSound = !isCurrent(sound);

      if (isDifferentSound) {
        _currentSound = sound;

        await _player.setAsset(sound.audioAsset);
      }

      await _player.play();
    } on PlayerException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  /// -------------------------------------------------------------------------
  /// PAUSE
  /// -------------------------------------------------------------------------
  Future<void> pause() async {
    await _player.pause();
  }

  /// -------------------------------------------------------------------------
  /// RESUME
  /// -------------------------------------------------------------------------
  Future<void> resume() async {
    if (_currentSound == null) {
      return;
    }

    await _player.play();
  }

  /// -------------------------------------------------------------------------
  /// TOGGLE PLAY / PAUSE
  /// -------------------------------------------------------------------------
  Future<void> toggle(Sound sound) async {
    if (isCurrent(sound) && _player.playing) {
      await pause();
      return;
    }

    await play(sound);
  }

  /// -------------------------------------------------------------------------
  /// STOP
  /// -------------------------------------------------------------------------
  Future<void> stop() async {
    await _player.stop();
  }

  /// -------------------------------------------------------------------------
  /// SEEK
  /// -------------------------------------------------------------------------
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Seek forward by a specific amount.
  Future<void> seekForward([
    Duration amount = const Duration(seconds: 10),
  ]) async {
    final target = _player.position + amount;

    final maximum = _player.duration;

    if (maximum == null) {
      await _player.seek(target);
      return;
    }

    final clampedTarget = target > maximum ? maximum : target;

    await _player.seek(clampedTarget);
  }

  /// Seek backward by a specific amount.
  Future<void> seekBackward([
    Duration amount = const Duration(seconds: 10),
  ]) async {
    final target = _player.position - amount;

    final clampedTarget =
        target < Duration.zero ? Duration.zero : target;

    await _player.seek(clampedTarget);
  }

  /// -------------------------------------------------------------------------
  /// RESET
  /// -------------------------------------------------------------------------
  ///
  /// Stops playback and clears the currently loaded sound.
  ///
  Future<void> reset() async {
    await _player.stop();

    _currentSound = null;
  }

  /// -------------------------------------------------------------------------
  /// DISPOSE
  /// -------------------------------------------------------------------------
  ///
  /// Call this only when the application is permanently shutting down.
  ///
  Future<void> dispose() async {
    await _player.dispose();
  }
}