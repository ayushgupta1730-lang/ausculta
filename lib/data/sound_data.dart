import 'package:flutter/material.dart';

import '../models/sound_model.dart';

/// ---------------------------------------------------------------------------
/// AUSCULTA SOUND LIBRARY
/// ---------------------------------------------------------------------------
///
/// Single source of truth for the sound library.
///
/// Audio files:
/// assets/audio/
///
/// Current library:
/// 21 available recordings.
///
/// Medical information is organized consistently as:
/// - Characteristics
/// - Location
/// - Pitch
/// - Timing
/// - Conditions
///
/// The wording is intentionally concise and note-like so the entire app
/// feels like one coherent study library.
/// ---------------------------------------------------------------------------

abstract final class SoundData {
  static const List<Sound> allSounds = [
    // =========================================================================
    // STRIDOR
    // =========================================================================

    Sound(
      id: 'stridor',
      name: 'Stridor',
      audioAsset: 'assets/audio/stridor.wav',
      searchText:
          'stridor upper airway larynx trachea obstruction',
      accent: Color(0xFFF2A9C5),
      characteristics:
          'High-pitched, harsh / screeching sound caused by narrowing of the '
          'upper airway.',
      location:
          'Upper airway, especially around the larynx and trachea.',
      pitch: 'High.',
      timing:
          'Usually inspiratory; may become biphasic with more severe or '
          'fixed upper-airway obstruction.',
      conditions:
          'Upper-airway narrowing due to swelling or obstruction. '
          'Epiglottitis, croup, anaphylaxis and foreign-body obstruction.',
    ),

    // =========================================================================
    // CRACKLES
    // =========================================================================

    Sound(
      id: 'fine_crackles',
      name: 'Fine Crackles',
      audioAsset: 'assets/audio/fine_crackles.mp3',
      searchText:
          'fine crackles crackle',
      accent: Color(0xFF8CB8FF),
      characteristics:
          'Very fine, brief popping / crackling sounds associated with the '
          'opening of small airways.',
      location:
          'Small airways, commonly heard over the dependent / lower lung areas.',
      pitch: 'High.',
      timing: 'Mainly during late inspiration.',
      conditions:
          'CHF, pneumonia, atelectasis and pulmonary fibrosis.',
    ),

    Sound(
      id: 'coarse_crackles',
      name: 'Coarse Crackles',
      audioAsset: 'assets/audio/coarse_crackles.mp3',
      searchText:
          'coarse crackles crackle',
      accent: Color(0xFFB9A9F7),
      characteristics:
          'Coarser, louder bubbling / crackling sounds associated with larger '
          'airways and airway secretions.',
      location:
          'Larger / more central airways; may be heard over broader lung areas.',
      pitch: 'Low.',
      timing:
          'Mainly during inspiration; may also occur during expiration.',
      conditions:
          'Bronchitis, pneumonia, COPD and airway secretions.',
    ),

    // =========================================================================
    // CREPITATIONS
    // =========================================================================
    //
    // Crepitations are commonly used interchangeably with crackles in
    // respiratory auscultation terminology. The app keeps separate entries
    // because there are separate recordings.
    // =========================================================================

    Sound(
      id: 'fine_crepitations',
      name: 'Fine Crepitations',
      audioAsset: 'assets/audio/fine_crepitations.mp3',
      searchText:
          'fine crepitations crepitation',
      accent: Color(0xFFD3C8FF),
      characteristics:
          'Fine, brief popping / crackling sounds associated with the opening '
          'of small airways.',
      location:
          'Small airways, commonly over dependent lung areas.',
      pitch: 'High.',
      timing: 'Mainly during late inspiration.',
      conditions:
          'Pneumonia, CHF, atelectasis, pulmonary fibrosis and other '
          'interstitial lung processes.',
    ),

    Sound(
      id: 'coarse_crepitations',
      name: 'Coarse Crepitations',
      audioAsset: 'assets/audio/coarse_crepitations.mp3',
      searchText:
          'coarse crepitations crepitation',
      accent: Color(0xFFC0B3F5),
      characteristics:
          'Coarse, louder bubbling / crackling sounds associated with larger '
          'airways and secretions.',
      location:
          'Larger / more central airways.',
      pitch: 'Low.',
      timing:
          'Mainly during inspiration; may also occur during expiration.',
      conditions:
          'Bronchitis, pneumonia, COPD and airway secretions.',
    ),

    // =========================================================================
    // WHEEZES
    // =========================================================================

    Sound(
      id: 'wheezes',
      name: 'Wheezes',
      audioAsset: 'assets/audio/wheezes.mp3',
      searchText:
          'wheezes wheeze wheezing',
      accent: Color(0xFF8CB8FF),
      characteristics:
          'Continuous, musical squeaky / whistling sound caused by narrowed '
          'airways.',
      location:
          'Throughout the respiratory system, depending on the affected airways.',
      pitch: 'High.',
      timing:
          'Mainly expiration, but can also occur during inspiration.',
      conditions:
          'Asthma, COPD and other conditions causing airway narrowing.',
    ),

    Sound(
      id: 'monophonic_wheeze',
      name: 'Monophonic Wheeze',
      audioAsset: 'assets/audio/monophonic_wheeze.mp3',
      searchText:
          'monophonic wheeze wheezes wheezing',
      accent: Color(0xFF9DBFFF),
      characteristics:
          'Single musical wheezing tone, often with one dominant frequency.',
      location:
          'Often localized to a particular airway or region.',
      pitch: 'High / single tone.',
      timing:
          'May occur during inspiration, expiration, or throughout the '
          'respiratory cycle depending on the obstruction.',
      conditions:
          'Localized airway obstruction such as mucus, foreign body, '
          'bronchial narrowing or an obstructing lesion.',
    ),

    Sound(
      id: 'polyphonic_wheeze',
      name: 'Polyphonic Wheeze',
      audioAsset: 'assets/audio/polyphonic_wheeze.mp3',
      searchText:
          'polyphonic wheeze wheezes wheezing',
      accent: Color(0xFFB8A9F5),
      characteristics:
          'Multiple musical wheezing tones occurring together.',
      location:
          'Multiple airways / more diffuse areas of the lungs.',
      pitch: 'High; multiple tones.',
      timing:
          'Predominantly expiratory.',
      conditions:
          'Diffuse airway narrowing, especially in asthma and COPD.',
    ),

    // =========================================================================
    // INSPIRATORY SQUEAK / SQUAWK
    // =========================================================================

    Sound(
      id: 'inspiratory_squeak',
      name: 'Inspiratory Squeak',
      audioAsset: 'assets/audio/inspiratory_squeak.mp3',
      searchText:
          'inspiratory squeak squeak',
      accent: Color(0xFFF0B4CF),
      characteristics:
          'Short, high-pitched musical squeak associated with narrowing or '
          'oscillation of small airways.',
      location:
          'Peripheral / small airways.',
      pitch: 'High.',
      timing:
          'Usually late inspiration.',
      conditions:
          'Interstitial lung disease, hypersensitivity pneumonitis and '
          'some small-airway diseases.',
    ),

    Sound(
      id: 'squawk',
      name: 'Squawk',
      audioAsset: 'assets/audio/squawk.mp3',
      searchText:
          'squawk',
      accent: Color(0xFFF2A9C5),
      characteristics:
          'Short, squeaky / musical sound resembling a brief inspiratory wheeze.',
      location:
          'Small / peripheral airways.',
      pitch: 'High.',
      timing:
          'Usually occurs during late inspiration.',
      conditions:
          'Hypersensitivity pneumonitis, interstitial lung disease, '
          'pneumonia and bronchiolitis obliterans.',
    ),

    // =========================================================================
    // RHONCHI
    // =========================================================================

    Sound(
      id: 'rhonchi',
      name: 'Rhonchi',
      audioAsset: 'assets/audio/rhonchi.mp3',
      searchText:
          'rhonchi rhonchus',
      accent: Color(0xFFF0B4CF),
      characteristics:
          'Low-pitched snoring / snorting sound associated with narrowing of '
          'larger airways; may change or improve after coughing.',
      location:
          'Large airways / tracheobronchial tree.',
      pitch: 'Low, but loud.',
      timing:
          'Mainly during expiration, but may also occur during inspiration.',
      conditions:
          'Bronchitis, pneumonia, COPD and airway secretions such as mucus.',
    ),

    // =========================================================================
    // PLEURAL / PERICARDIAL FRICTION
    // =========================================================================

    Sound(
      id: 'pleural_friction_rub',
      name: 'Pleural Friction Rub',
      audioAsset: 'assets/audio/pleural_friction_rub.mp3',
      searchText:
          'pleural friction rub',
      accent: Color(0xFFB9A9F7),
      characteristics:
          'Localized, grating / rubbing / creaking sound produced by inflamed '
          'pleural surfaces moving against each other.',
      location:
          'Localized area of the chest wall over the affected pleura.',
      pitch: 'Variable; often harsh / grating.',
      timing:
          'Usually heard during both inspiration and expiration.',
      conditions:
          'Pleurisy / pleural inflammation, pneumonia, pulmonary embolism '
          'and other conditions affecting the pleura.',
    ),

    Sound(
      id: 'pericardial_friction_rub',
      name: 'Pericardial Friction Rub',
      audioAsset: 'assets/audio/pericardial_friction_rub.mp3',
      searchText:
          'pericardial friction rub pericarditis',
      accent: Color(0xFFF2A9C5),
      characteristics:
          'High-pitched, scratchy / squeaky friction sound associated with '
          'pericardial inflammation.',
      location:
          'Best heard along the left sternal border.',
      pitch: 'High.',
      timing:
          'Classically triphasic, but may be biphasic or monophasic.',
      conditions:
          'Acute pericarditis.',
    ),

    // =========================================================================
    // BRONCHIAL / VESICULAR BREATH SOUNDS
    // =========================================================================

    Sound(
      id: 'bronchial_breath_sounds',
      name: 'Bronchial Breath Sounds',
      audioAsset: 'assets/audio/bronchial_breath_sounds.mp3',
      searchText:
          'bronchial breath sounds bronchial breathing',
      accent: Color(0xFF9CBFFF),
      characteristics:
          'Loud, high-pitched, tubular / hollow breath sound with a distinct '
          'pause between inspiration and expiration.',
      location:
          'Normally over the trachea / large central airways. If heard over '
          'peripheral lung fields, it may be abnormal.',
      pitch: 'High-pitched.',
      timing:
          'Inspiration and expiration are approximately equal in duration, '
          'with a distinct pause between phases.',
      conditions:
          'Normally heard over the trachea. Peripheral bronchial breathing '
          'may occur with lung consolidation such as pneumonia, above a '
          'pleural effusion, or with some forms of atelectasis.',
    ),

    Sound(
      id: 'vesicular_breath_sounds',
      name: 'Vesicular Breath Sounds',
      audioAsset: 'assets/audio/vesicular_breath_sounds.mp3',
      searchText:
          'vesicular breath sounds',
      accent: Color(0xFF9DBFFF),
      characteristics:
          'Soft, low-pitched, breezy / rustling normal breath sound.',
      location:
          'Most peripheral lung fields.',
      pitch: 'Low.',
      timing:
          'Predominantly during inspiration with a shorter, softer expiratory '
          'component.',
      conditions:
          'Normal breath sound over most healthy lung fields.',
    ),

    Sound(
      id: 'bronchovesicular_breath_sounds',
      name: 'Bronchovesicular Breath Sounds',
      audioAsset: 'assets/audio/bronchovesicular_breath_sounds.wav',
      searchText:
          'bronchovesicular breath sounds bronchovesicular',
      accent: Color(0xFFB9A9F7),
      characteristics:
          'Intermediate sound between bronchial and vesicular breathing.',
      location:
          'Anteriorly over the first and second intercostal spaces and '
          'posteriorly between the scapulae.',
      pitch: 'Intermediate.',
      timing:
          'Inspiration and expiration are approximately equal in duration.',
      conditions:
          'Normal in its expected locations; abnormal if heard elsewhere.',
    ),

    Sound(
      id: 'tracheal_breath_sounds',
      name: 'Tracheal Breath Sounds',
      audioAsset: 'assets/audio/tracheal_breath_sounds.mp3',
      searchText:
          'tracheal breath sounds tracheal breathing',
      accent: Color(0xFFF0B4CF),
      characteristics:
          'Very loud, harsh, hollow / tubular breath sound.',
      location:
          'Directly over the trachea, especially around the suprasternal notch.',
      pitch: 'High.',
      timing:
          'Both inspiration and expiration with a distinct pause between phases.',
      conditions:
          'Normal over the trachea.',
    ),

    // =========================================================================
    // AMPHORIC
    // =========================================================================

    Sound(
      id: 'amphoric_breath_sounds',
      name: 'Amphoric Breath Sounds',
      audioAsset: 'assets/audio/amphoric_breath_sounds.mp3',
      searchText:
          'amphoric breath sounds amphoric breathing',
      accent: Color(0xFFB9A9F7),
      characteristics:
          'Hollow, resonant, metallic breath sound with prominent high-pitched '
          'overtones; may resemble blowing across the mouth of an empty bottle.',
      location:
          'Over a superficial large pulmonary cavity or an open pneumothorax.',
      pitch:
          'High-pitched / resonant with metallic overtones.',
      timing:
          'During inspiration and expiration.',
      conditions:
          'Large superficial pulmonary cavity with a patent bronchus or '
          'open pneumothorax.',
    ),

    // =========================================================================
    // VOCAL / TRANSMISSION SOUNDS
    // =========================================================================

    Sound(
      id: 'egophony',
      name: 'Egophony Breath Sounds',
      audioAsset: 'assets/audio/egophony_breath_sounds.mp3',
      searchText:
          'egophony egophonic',
      accent: Color(0xFF8CB8FF),
      characteristics:
          'Altered vocal resonance in which a spoken "E" is heard as a nasal '
          '"A" sound over abnormal lung tissue.',
      location:
          'Over areas of lung consolidation; often just above the level of a '
          'pleural effusion.',
      pitch:
          'Voice resonance with a nasal / altered quality.',
      timing:
          'During vocalization rather than a normal inspiratory / expiratory phase.',
      conditions:
          'Pulmonary consolidation such as pneumonia and compressed lung '
          'above a pleural effusion.',
    ),

    // =========================================================================
    // COUGHS
    // =========================================================================

    Sound(
      id: 'whooping_cough',
      name: 'Whooping Cough',
      audioAsset: 'assets/audio/whooping_cough.mp3',
      searchText:
          'whooping cough pertussis',
      accent: Color(0xFFF2A9C5),
      characteristics:
          'Repeated rapid coughing bursts followed by a long inspiratory effort '
          'with a high-pitched "whoop".',
      location:
          'Respiratory tract; characteristic cough pattern.',
      pitch:
          'High-pitched inspiratory whoop.',
      timing:
          'Occurs in paroxysmal coughing attacks, especially during the '
          'inspiratory effort after coughing bursts.',
      conditions:
          'Pertussis (whooping cough).',
    ),

    Sound(
      id: 'staccato_cough',
      name: 'Staccato Cough',
      audioAsset: 'assets/audio/staccato_cough.mp3',
      searchText:
          'staccato cough',
      accent: Color(0xFFF0B4CF),
      characteristics:
          'Repetitive, short, staccato cough occurring in closely spaced bursts.',
      location:
          'Respiratory tract; characteristic clinical cough pattern.',
      pitch: 'Variable.',
      timing:
          'Repeated short coughs, often persistent / repetitive.',
      conditions:
          'Classically associated with Chlamydia trachomatis pneumonia '
          'in young infants.',
    ),
  ];

  // ===========================================================================
  // LIBRARY HELPERS
  // ===========================================================================

  /// Total number of sounds in the library.
  static int get count => allSounds.length;

  /// Returns sounds whose searchable text contains the query.
  ///
  /// Search is:
  /// - case-insensitive
  /// - contains-based
  /// - instant
  ///
  /// Search metadata intentionally contains only the sound identity
  /// and deliberate aliases, not the medical explanation fields.

  static List<Sound> search(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return allSounds;
    }

    return allSounds
        .where(
          (sound) => sound.matchesQuery(normalizedQuery),
        )
        .toList();
  }

  /// Finds a sound by its stable ID.
  static Sound? findById(String id) {
    for (final sound in allSounds) {
      if (sound.id == id) {
        return sound;
      }
    }

    return null;
  }
}