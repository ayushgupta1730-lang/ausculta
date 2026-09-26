import 'package:shared_preferences/shared_preferences.dart';

import '../data/sound_data.dart';
import '../models/sound_model.dart';

class LibraryService {
  LibraryService._internal();

  static final LibraryService instance = LibraryService._internal();

  static const String _favoritesKey = 'favorite_sound_ids';
  static const String _recentlyPlayedKey = 'recently_played_sound_ids';

  SharedPreferences? _preferences;

  Set<String> _favoriteIds = <String>{};
  List<String> _recentIds = <String>[];

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _preferences = await SharedPreferences.getInstance();

    _favoriteIds = (_preferences?.getStringList(_favoritesKey) ?? <String>[])
        .toSet();

    _recentIds =
        _preferences?.getStringList(_recentlyPlayedKey) ?? <String>[];

    _initialized = true;
  }

  // ===========================================================================
  // FAVORITES
  // ===========================================================================

  bool isFavorite(String soundId) {
    return _favoriteIds.contains(soundId);
  }

  List<Sound> get favoriteSounds {
    return SoundData.allSounds
        .where((sound) => _favoriteIds.contains(sound.id))
        .toList();
  }

  Future<bool> toggleFavorite(String soundId) async {
    await initialize();

    if (_favoriteIds.contains(soundId)) {
      _favoriteIds.remove(soundId);
    } else {
      _favoriteIds.add(soundId);
    }

    await _saveFavorites();

    return _favoriteIds.contains(soundId);
  }

  Future<void> removeFavorite(String soundId) async {
    await initialize();

    _favoriteIds.remove(soundId);

    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    await _preferences?.setStringList(
      _favoritesKey,
      _favoriteIds.toList(),
    );
  }

  // ===========================================================================
  // RECENTLY PLAYED
  // ===========================================================================

  List<Sound> get recentlyPlayedSounds {
    final sounds = <Sound>[];

    for (final id in _recentIds) {
      final sound = SoundData.findById(id);

      if (sound != null) {
        sounds.add(sound);
      }
    }

    return sounds;
  }

  Future<void> addRecentlyPlayed(String soundId) async {
    await initialize();

    _recentIds.remove(soundId);

    _recentIds.insert(0, soundId);

    // Keep the recent list intentionally small and clean.
    if (_recentIds.length > 10) {
      _recentIds = _recentIds.take(10).toList();
    }

    await _preferences?.setStringList(
      _recentlyPlayedKey,
      _recentIds,
    );
  }

  Future<void> clearRecentlyPlayed() async {
    await initialize();

    _recentIds.clear();

    await _preferences?.setStringList(
      _recentlyPlayedKey,
      <String>[],
    );
  }

  // ===========================================================================
  // COUNTS
  // ===========================================================================

  int get favoriteCount => _favoriteIds.length;

  int get recentlyPlayedCount => _recentIds.length;
}