import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/real_exercise.dart';
import '../theme/app_colors.dart';
import '../widgets/exercise_image.dart';
import '../widgets/tactile_button.dart';
import 'workout_session_screen.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final RealExercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  bool _animating = true;

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context, ex),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildMetaRow(ex),
                const SizedBox(height: 20),
                _buildMuscleSection(ex),
                const SizedBox(height: 20),
                _buildInstructions(ex),
                if (ex.equipment != null && ex.equipment != 'body only') ...[
                  const SizedBox(height: 20),
                  _buildEquipmentCard(ex),
                ],
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, ex),
    );
  }

  Widget _buildAppBar(BuildContext context, RealExercise ex) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.surfaceContainerLowest,
          child: Stack(
            children: [
              // Exercise images
              Positioned.fill(
                child: ExerciseImageWidget(
                  exercise: ex,
                  width: double.infinity,
                  height: double.infinity,
                  animate: _animating,
                  frameMs: 900,
                ),
              ),
              // Back button overlay
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: AppColors.onSurface, size: 20),
                  ),
                ),
              ),
              // Animate toggle
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _animating = !_animating);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _animating
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _animating
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 16,
                          color:
                              _animating ? Colors.white : AppColors.onSurface,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _animating ? 'Animating' : 'Paused',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: _animating
                                ? Colors.white
                                : AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Text(
          ex.name,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
          ),
        ),
        titlePadding:
            const EdgeInsetsDirectional.fromSTEB(56, 0, 16, 16),
        collapseMode: CollapseMode.pin,
      ),
    );
  }

  Widget _buildMetaRow(RealExercise ex) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        if (ex.force != null)
          _MetaChip(
            icon: ex.force == 'push'
                ? Icons.arrow_upward_rounded
                : ex.force == 'pull'
                    ? Icons.arrow_downward_rounded
                    : Icons.compare_arrows_rounded,
            label: _capitalize(ex.force!),
            color: AppColors.primary,
          ),
        _MetaChip(
          icon: Icons.bar_chart_rounded,
          label: _capitalize(ex.level),
          color: _levelColor(ex.level),
        ),
        _MetaChip(
          icon: Icons.category_rounded,
          label: _capitalize(ex.category),
          color: const Color(0xFF00628c),
        ),
        if (ex.mechanic != null)
          _MetaChip(
            icon: Icons.settings_rounded,
            label: _capitalize(ex.mechanic!),
            color: const Color(0xFF725800),
          ),
        if (ex.equipment != null)
          _MetaChip(
            icon: Icons.sports_gymnastics_rounded,
            label: _capitalize(ex.equipment!),
            color: const Color(0xFF4a0072),
          ),
      ],
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2);
  }

  Widget _buildMuscleSection(RealExercise ex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Muscles Worked',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        if (ex.primaryMuscles.isNotEmpty) ...[
          Text(
            'PRIMARY',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.outlineVariant,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ex.primaryMuscles
                .map((m) => _MuscleChip(name: m, primary: true))
                .toList(),
          ),
        ],
        if (ex.secondaryMuscles.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'SECONDARY',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.outlineVariant,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ex.secondaryMuscles
                .map((m) => _MuscleChip(name: m, primary: false))
                .toList(),
          ),
        ],
      ],
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2);
  }

  Widget _buildInstructions(RealExercise ex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How to do it',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ...ex.instructions.asMap().entries.map((entry) {
          final i = entry.key;
          final step = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.primaryDim,
                        offset: Offset(0, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFFE5E5E5), width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFE5E5E5),
                          offset: Offset(0, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      step,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ).animate(delay: Duration(milliseconds: 180 + i * 60))
                .fadeIn()
                .slideX(begin: 0.1, curve: Curves.easeOutCubic),
          );
        }),
      ],
    );
  }

  Widget _buildEquipmentCard(RealExercise ex) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF725800).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF725800).withValues(alpha: 0.2), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF725800).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.sports_gymnastics_rounded,
                color: Color(0xFF725800), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Equipment needed',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.outlineVariant,
                  ),
                ),
                Text(
                  _capitalize(ex.equipment!),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF725800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildBottomBar(BuildContext context, RealExercise ex) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border:
            const Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 2)),
      ),
      child: TactileButton(
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, anim, __) =>
                  WorkoutSessionScreen(exercises: [ex]),
              transitionsBuilder: (_, anim, __, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
        color: AppColors.primary,
        shadowColor: AppColors.primaryDim,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.play_arrow_rounded,
                  color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                'Start Exercise',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
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

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MuscleChip extends StatelessWidget {
  final String name;
  final bool primary;

  const _MuscleChip({required this.name, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primary
            ? AppColors.primaryContainer.withValues(alpha: 0.35)
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primary
              ? AppColors.primary.withValues(alpha: 0.4)
              : const Color(0xFFE5E5E5),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (primary)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 5),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          Text(
            name[0].toUpperCase() + name.substring(1),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: primary ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
