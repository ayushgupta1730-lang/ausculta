import 'package:flutter/material.dart';

/// Represents one auscultation sound inside Ausculta.
///
/// The model deliberately keeps audio, search, and educational information
/// together so the UI does not need to know where individual pieces of data
/// come from.
class Sound {
  final String id;
  final String name;
  final String audioAsset;
  final String searchText;

  final String? characteristics;
  final String? location;
  final String? conditions;
  final String? pitch;
  final String? timing;

  final Color accent;

  /// Whether the audio file is currently available in the project.
  ///
  /// Crackles and Wheezing are planned library entries but their audio files
  /// have not been added yet.
  final bool audioAvailable;

  const Sound({
    required this.id,
    required this.name,
    required this.audioAsset,
    required this.searchText,
    required this.accent,
    this.characteristics,
    this.location,
    this.conditions,
    this.pitch,
    this.timing,
    this.audioAvailable = true,
  });

  /// Text used by the live search system.
  ///
  /// Search is case-insensitive and contains-based.
  bool matchesQuery(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return true;
    }

    return searchText.toLowerCase().contains(normalizedQuery);
  }

  Sound copyWith({
    String? id,
    String? name,
    String? audioAsset,
    String? searchText,
    String? characteristics,
    String? location,
    String? conditions,
    String? pitch,
    String? timing,
    Color? accent,
    bool? audioAvailable,
  }) {
    return Sound(
      id: id ?? this.id,
      name: name ?? this.name,
      audioAsset: audioAsset ?? this.audioAsset,
      searchText: searchText ?? this.searchText,
      characteristics: characteristics ?? this.characteristics,
      location: location ?? this.location,
      conditions: conditions ?? this.conditions,
      pitch: pitch ?? this.pitch,
      timing: timing ?? this.timing,
      accent: accent ?? this.accent,
      audioAvailable: audioAvailable ?? this.audioAvailable,
    );
  }
}