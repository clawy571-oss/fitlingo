import 'dart:convert';
import 'package:flutter/services.dart';

// ── Image CDN ─────────────────────────────────────────────────────────────────
// yuhonas/free-exercise-db · public domain (Unlicense)
// Images: raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/{id}/{n}.jpg
const _kBase =
    'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises';

// ── Model ─────────────────────────────────────────────────────────────────────

class RealExercise {
  final String id;
  final String name;
  final String? force;   // push / pull / static
  final String level;    // beginner / intermediate / expert
  final String? mechanic; // compound / isolation
  final String? equipment;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  final String category;
  final List<String> _imageRelPaths;

  const RealExercise({
    required this.id,
    required this.name,
    this.force,
    required this.level,
    this.mechanic,
    this.equipment,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.instructions,
    required this.category,
    required List<String> imagePaths,
  }) : _imageRelPaths = imagePaths;

  /// Full HTTPS URL for image at [index] (0 = start position, 1 = end position)
  String imageUrl(int index) {
    if (_imageRelPaths.isEmpty) return '';
    final path = _imageRelPaths[index.clamp(0, _imageRelPaths.length - 1)];
    return '$_kBase/$path';
  }

  int get imageCount => _imageRelPaths.length;

  bool get hasTwoImages => _imageRelPaths.length >= 2;

  factory RealExercise.fromJson(Map<String, dynamic> json) {
    return RealExercise(
      id: json['id'] as String,
      name: json['name'] as String,
      force: json['force'] as String?,
      level: json['level'] as String? ?? 'beginner',
      mechanic: json['mechanic'] as String?,
      equipment: json['equipment'] as String?,
      primaryMuscles: List<String>.from(json['primaryMuscles'] ?? []),
      secondaryMuscles: List<String>.from(json['secondaryMuscles'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      category: json['category'] as String? ?? 'strength',
      imagePaths: List<String>.from(json['images'] ?? []),
    );
  }
}

// ── Database ──────────────────────────────────────────────────────────────────

class ExerciseDatabase {
  ExerciseDatabase._();
  static final ExerciseDatabase instance = ExerciseDatabase._();

  List<RealExercise> _all = [];
  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/exercises.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _all = list.map((e) => RealExercise.fromJson(e as Map<String, dynamic>)).toList();
    _loaded = true;
  }

  List<RealExercise> get all => List.unmodifiable(_all);

  /// All unique categories in the dataset
  List<String> get categories =>
      _all.map((e) => e.category).toSet().toList()..sort();

  /// All unique muscle names
  List<String> get muscles =>
      _all.expand((e) => e.primaryMuscles).toSet().toList()..sort();

  List<RealExercise> byCategory(String cat) =>
      _all.where((e) => e.category == cat).toList();

  List<RealExercise> byMuscle(String muscle) =>
      _all.where((e) => e.primaryMuscles.contains(muscle)).toList();

  List<RealExercise> byLevel(String level) =>
      _all.where((e) => e.level == level).toList();

  List<RealExercise> search(String query) {
    final q = query.toLowerCase();
    return _all
        .where((e) =>
            e.name.toLowerCase().contains(q) ||
            e.primaryMuscles.any((m) => m.contains(q)) ||
            (e.equipment?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  RealExercise? byId(String id) {
    try {
      return _all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Curated beginner-friendly full-body workout (bodyweight only)
  List<RealExercise> get beginnerBodyweightWorkout {
    const ids = [
      'Pushups',
      'Bodyweight_Squat',
      'Plank',
      'Jumping_Jacks',
      'Crunches',
      'Lunges',
      'Mountain_Climbers',
      'Burpees',
      'Tricep_Dips_-_Chair',
      'Glute_Bridge',
    ];
    final result = <RealExercise>[];
    for (final id in ids) {
      final e = byId(id);
      if (e != null) result.add(e);
    }
    // Fill remaining spots from beginner bodyweight exercises
    if (result.length < 6) {
      final bodyweight = _all
          .where((e) =>
              e.level == 'beginner' &&
              (e.equipment == 'body only' || e.equipment == null) &&
              !result.any((r) => r.id == e.id))
          .take(6 - result.length)
          .toList();
      result.addAll(bodyweight);
    }
    return result;
  }
}
