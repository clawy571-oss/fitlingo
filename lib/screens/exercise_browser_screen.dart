import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/real_exercise.dart';
import '../theme/app_colors.dart';
import '../widgets/exercise_image.dart';
import 'exercise_detail_screen.dart';

class ExerciseBrowserScreen extends StatefulWidget {
  final String? initialCategory;
  final String? initialMuscle;

  const ExerciseBrowserScreen({
    super.key,
    this.initialCategory,
    this.initialMuscle,
  });

  @override
  State<ExerciseBrowserScreen> createState() => _ExerciseBrowserScreenState();
}

class _ExerciseBrowserScreenState extends State<ExerciseBrowserScreen>
    with SingleTickerProviderStateMixin {
  final _db = ExerciseDatabase.instance;
  final _searchController = TextEditingController();

  bool _loading = true;
  String _query = '';
  String? _selectedCategory;
  String? _selectedMuscle;
  String? _selectedLevel;
  List<RealExercise> _results = [];

  static const _levels = ['beginner', 'intermediate', 'expert'];

  static const _categoryIcons = <String, IconData>{
    'strength': Icons.fitness_center_rounded,
    'cardio': Icons.directions_run_rounded,
    'stretching': Icons.self_improvement_rounded,
    'plyometrics': Icons.bolt_rounded,
    'powerlifting': Icons.sports_gymnastics_rounded,
    'olympic weightlifting': Icons.military_tech_rounded,
    'strongman': Icons.construction_rounded,
  };

  static const _categoryColors = <String, Color>{
    'strength': AppColors.primary,
    'cardio': Color(0xFFb02500),
    'stretching': Color(0xFF00628c),
    'plyometrics': Color(0xFF725800),
    'powerlifting': Color(0xFF4a0072),
    'olympic weightlifting': Color(0xFF1a5276),
    'strongman': Color(0xFF784212),
  };

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
        _applyFilters();
      });
    });
  }

  Future<void> _loadData() async {
    await _db.load();
    setState(() {
      _loading = false;
      if (widget.initialCategory != null) {
        _selectedCategory = widget.initialCategory;
      }
      if (widget.initialMuscle != null) {
        _selectedMuscle = widget.initialMuscle;
      }
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<RealExercise> base =
        _query.isEmpty ? _db.all.toList() : _db.search(_query);

    if (_selectedCategory != null) {
      base = base.where((e) => e.category == _selectedCategory).toList();
    }
    if (_selectedMuscle != null) {
      base = base
          .where((e) => e.primaryMuscles.contains(_selectedMuscle))
          .toList();
    }
    if (_selectedLevel != null) {
      base = base.where((e) => e.level == _selectedLevel).toList();
    }
    _results = base;
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedMuscle = null;
      _selectedLevel = null;
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasFilters =>
      _selectedCategory != null ||
      _selectedMuscle != null ||
      _selectedLevel != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          _buildSearchBar(),
          _buildFilterRow(),
          if (_loading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else
            Expanded(child: _buildGrid()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 12, 20, 16),
      color: AppColors.surfaceContainerLowest,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: const Color(0xFFE5E5E5), width: 2),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xFFE5E5E5),
                      offset: Offset(0, 3),
                      blurRadius: 0),
                ],
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: AppColors.onSurface, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exercise Library',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onSurface,
                  ),
                ),
                if (!_loading)
                  Text(
                    '${_results.length} of ${_db.all.length} exercises',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: AppColors.outlineVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          if (_hasFilters)
            GestureDetector(
              onTap: _clearFilters,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.errorContainer.withValues(alpha: 0.3),
                      width: 2),
                ),
                child: Text(
                  'Clear',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.errorContainer,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppColors.surfaceContainerLowest,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
        ),
        child: TextField(
          controller: _searchController,
          style: GoogleFonts.beVietnamPro(
              fontSize: 15, color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: 'Search exercises, muscles, equipment…',
            hintStyle: GoogleFonts.beVietnamPro(
                fontSize: 15, color: AppColors.outlineVariant),
            prefixIcon: const Icon(Icons.search_rounded,
                color: AppColors.outlineVariant, size: 22),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.outlineVariant, size: 20),
                    onPressed: () => _searchController.clear(),
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    final cats = _db.categories;
    return Container(
      color: AppColors.surfaceContainerLowest,
      child: Column(
        children: [
          // Category chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              children: [
                ...cats.map((cat) {
                  final active = _selectedCategory == cat;
                  final color = _categoryColors[cat] ?? AppColors.primary;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedCategory = active ? null : cat;
                          _applyFilters();
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: active
                              ? color
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: active
                                ? color
                                : const Color(0xFFE5E5E5),
                            width: 2,
                          ),
                          boxShadow: active
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.4),
                                    offset: const Offset(0, 3),
                                    blurRadius: 0,
                                  )
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _categoryIcons[cat] ??
                                  Icons.fitness_center_rounded,
                              size: 14,
                              color: active
                                  ? Colors.white
                                  : AppColors.outlineVariant,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _capitalize(cat),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: active
                                    ? Colors.white
                                    : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          // Level chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              children: _levels.map((lvl) {
                final active = _selectedLevel == lvl;
                final color = _levelColor(lvl);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedLevel = active ? null : lvl;
                        _applyFilters();
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: active ? color : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active
                              ? color
                              : color.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        _capitalize(lvl),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color:
                              active ? Colors.white : color,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E5E5)),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 56, color: AppColors.outlineVariant),
            const SizedBox(height: 12),
            Text(
              'No exercises found',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.outlineVariant,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _results.length,
      itemBuilder: (_, i) => _ExerciseCard(
        exercise: _results[i],
        index: i,
      ).animate(delay: Duration(milliseconds: (i % 6) * 40))
          .fadeIn(duration: 250.ms)
          .slideY(begin: 0.15, curve: Curves.easeOutCubic),
    );
  }

  Color _levelColor(String level) {
    return switch (level) {
      'beginner' => AppColors.primary,
      'intermediate' => const Color(0xFF725800),
      'expert' => const Color(0xFFb02500),
      _ => AppColors.outlineVariant,
    };
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ── Card ──────────────────────────────────────────────────────────────────────

class _ExerciseCard extends StatelessWidget {
  final RealExercise exercise;
  final int index;

  const _ExerciseCard({required this.exercise, required this.index});

  @override
  Widget build(BuildContext context) {
    final levelColor = _levelColor(exercise.level);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, anim, __) =>
                ExerciseDetailScreen(exercise: exercise),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 250),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFE5E5E5),
              offset: Offset(0, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: Container(
                  color: AppColors.surfaceContainerLow,
                  child: ExerciseImageWidget(
                    exercise: exercise,
                    width: double.infinity,
                    height: double.infinity,
                    frameMs: 800 + (index % 4) * 100,
                  ),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: levelColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          exercise.level[0].toUpperCase() +
                              exercise.level.substring(1),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: levelColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          exercise.primaryMuscles.take(2).join(', '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 9,
                            color: AppColors.outlineVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _levelColor(String level) {
    return switch (level) {
      'beginner' => AppColors.primary,
      'intermediate' => const Color(0xFF725800),
      'expert' => const Color(0xFFb02500),
      _ => AppColors.outlineVariant,
    };
  }
}
