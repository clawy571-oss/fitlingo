import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/exercise_library.dart';
import '../models/real_exercise.dart';
import '../theme/app_colors.dart';
import '../widgets/exercise_animation.dart';
import '../widgets/exercise_image.dart';
import '../widgets/tactile_button.dart';
import 'celebration_screen.dart';

// ── Exercise Prescription ─────────────────────────────────────────────────────

class ExercisePrescription {
  final RealExercise exercise;
  final int sets;
  final int reps;
  final int holdSecs;
  final String coachingCue;
  final bool isWarmup;
  final bool isCooldown;
  const ExercisePrescription({
    required this.exercise,
    this.sets = 2,
    this.reps = 10,
    this.holdSecs = 0,
    this.coachingCue = '',
    this.isWarmup = false,
    this.isCooldown = false,
  });
}

// ── Entry point ───────────────────────────────────────────────────────────────

class WorkoutSessionScreen extends StatefulWidget {
  final WorkoutPlan? plan;
  /// When provided, uses real exercises from the free-exercise-db dataset
  final List<RealExercise>? exercises;
  /// When provided, uses prescriptions with per-exercise sets/reps/cues
  final List<ExercisePrescription>? prescriptions;

  const WorkoutSessionScreen({super.key, this.plan, this.exercises, this.prescriptions});

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  WorkoutPlan? _plan;
  List<RealExercise>? _realExercises;
  List<ExercisePrescription>? _prescriptions;
  int _exerciseIndex = 0;
  _SessionState _state = _SessionState.preview;

  bool get _usingReal => _realExercises != null;

  ExercisePrescription? get _currentPrescription =>
      _prescriptions != null ? _prescriptions![_exerciseIndex] : null;

  @override
  void initState() {
    super.initState();
    if (widget.prescriptions != null && widget.prescriptions!.isNotEmpty) {
      _prescriptions = widget.prescriptions;
      _realExercises = widget.prescriptions!.map((p) => p.exercise).toList();
    } else if (widget.exercises != null && widget.exercises!.isNotEmpty) {
      _realExercises = widget.exercises;
    } else {
      _plan = widget.plan ?? WorkoutLibrary.get('pushup_paradise')!;
    }
  }

  Exercise? get _currentExercise =>
      _usingReal ? null : _plan!.exercises[_exerciseIndex];
  RealExercise? get _currentReal =>
      _usingReal ? _realExercises![_exerciseIndex] : null;

  int get _totalCount =>
      _usingReal ? _realExercises!.length : _plan!.exercises.length;

  void _startExercise() => setState(() => _state = _SessionState.active);

  void _finishSet() {
    if (_exerciseIndex >= _totalCount - 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const CelebrationScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } else {
      setState(() {
        _exerciseIndex++;
        _state = _SessionState.rest;
      });
    }
  }

  void _finishRest() => setState(() => _state = _SessionState.preview);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: _usingReal
            ? _buildRealState()
            : _buildLegacyState(),
      ),
    );
  }

  Widget _buildRealState() {
    final ex = _currentReal!;
    final pres = _currentPrescription;
    return switch (_state) {
      _SessionState.preview => RealExercisePreviewPage(
          key: ValueKey('real_preview_$_exerciseIndex'),
          exercise: ex,
          index: _exerciseIndex,
          total: _totalCount,
          sets: pres?.sets ?? 3,
          targetReps: pres?.reps ?? 10,
          holdSecs: pres?.holdSecs ?? 0,
          coachingCue: pres?.coachingCue ?? '',
          isWarmup: pres?.isWarmup ?? false,
          isCooldown: pres?.isCooldown ?? false,
          onStart: _startExercise,
          onBack: () => Navigator.pop(context),
        ),
      _SessionState.active => RealActiveExercisePage(
          key: ValueKey('real_active_$_exerciseIndex'),
          exercise: ex,
          sets: pres?.sets ?? 3,
          targetReps: pres?.reps ?? 10,
          holdSecs: pres?.holdSecs ?? 0,
          coachingCue: pres?.coachingCue ?? '',
          onFinish: _finishSet,
        ),
      _SessionState.rest => RestPage(
          key: ValueKey('real_rest_$_exerciseIndex'),
          nextExerciseName: _realExercises![_exerciseIndex].name,
          nextExerciseReal: _realExercises![_exerciseIndex],
          seconds: 60,
          onSkip: _finishRest,
          onDone: _finishRest,
        ),
    };
  }

  Widget _buildLegacyState() {
    final ex = _currentExercise!;
    return switch (_state) {
      _SessionState.preview => ExercisePreviewPage(
          key: ValueKey('preview_$_exerciseIndex'),
          exercise: ex,
          index: _exerciseIndex,
          total: _totalCount,
          planName: _plan!.name,
          onStart: _startExercise,
          onBack: () => Navigator.pop(context),
        ),
      _SessionState.active => ActiveExercisePage(
          key: ValueKey('active_$_exerciseIndex'),
          exercise: ex,
          onFinish: _finishSet,
        ),
      _SessionState.rest => RestPage(
          key: ValueKey('rest_$_exerciseIndex'),
          nextExerciseName: _plan!.exercises[_exerciseIndex].name,
          seconds: _currentExercise!.restSeconds,
          onSkip: _finishRest,
          onDone: _finishRest,
        ),
    };
  }
}

enum _SessionState { preview, active, rest }

// ── Exercise Preview Page ─────────────────────────────────────────────────────

class ExercisePreviewPage extends StatelessWidget {
  final Exercise exercise;
  final int index;
  final int total;
  final String planName;
  final VoidCallback onStart;
  final VoidCallback onBack;

  const ExercisePreviewPage({
    super.key,
    required this.exercise,
    required this.index,
    required this.total,
    required this.planName,
    required this.onStart,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          _PreviewHeader(
            exercise: exercise,
            index: index,
            total: total,
            planName: planName,
            onBack: onBack,
          ),
          // Scrollable body
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animation card
                  _AnimationCard(exercise: exercise)
                      .animate()
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: 0.04, end: 0),
                  const SizedBox(height: 20),
                  // Muscle groups
                  _MuscleGroupRow(exercise: exercise)
                      .animate(delay: 80.ms)
                      .fadeIn(),
                  const SizedBox(height: 24),
                  // Instructions
                  _SectionLabel('How To Do It'),
                  const SizedBox(height: 12),
                  ...exercise.steps.asMap().entries.map(
                        (e) => _StepCard(
                          number: e.key + 1,
                          step: e.value,
                          color: exercise.color,
                          delay: 120 + e.key * 60,
                        ),
                      ),
                  if (exercise.tips.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _SectionLabel('Tips'),
                    const SizedBox(height: 12),
                    ..._buildTips(exercise),
                  ],
                  if (exercise.proTip.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _ProTipCard(text: exercise.proTip)
                        .animate(delay: 500.ms)
                        .fadeIn(),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          // Sticky footer
          _PreviewFooter(exercise: exercise, onStart: onStart),
        ],
      ),
    );
  }

  List<Widget> _buildTips(Exercise exercise) {
    return exercise.tips.asMap().entries.map((e) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: exercise.color,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                e.value,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ).animate(delay: Duration(milliseconds: 460 + e.key * 40)).fadeIn();
    }).toList();
  }
}

// ── Preview Header ────────────────────────────────────────────────────────────

class _PreviewHeader extends StatelessWidget {
  final Exercise exercise;
  final int index;
  final int total;
  final String planName;
  final VoidCallback onBack;

  const _PreviewHeader({
    required this.exercise,
    required this.index,
    required this.total,
    required this.planName,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 2),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.outlineVariant, width: 2),
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 20, color: AppColors.onSurfaceVariant),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    planName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    'Exercise ${index + 1} of $total',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (index + 1) / total,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation(exercise.color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animation Card ────────────────────────────────────────────────────────────

class _AnimationCard extends StatelessWidget {
  final Exercise exercise;
  const _AnimationCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: exercise.color.withAlpha(12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: exercise.color.withAlpha(50), width: 2),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _LightDotPainter(color: exercise.color),
            ),
          ),
          // Animation
          Center(
            child: ExerciseAnimation(
              type: exercise.type,
              color: exercise.color,
              size: 180,
            ),
          ),
          // Difficulty badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                    color: exercise.color.withAlpha(80), width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: exercise.color,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    exercise.difficulty,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sets/reps badge
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: exercise.color,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                exercise.type == ExerciseType.plank
                    ? '${exercise.defaultSets} × ${exercise.defaultReps}s'
                    : '${exercise.defaultSets} × ${exercise.defaultReps} reps',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Muscle Group Row ──────────────────────────────────────────────────────────

class _MuscleGroupRow extends StatelessWidget {
  final Exercise exercise;
  const _MuscleGroupRow({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...exercise.muscleGroups.map((m) => _Chip(
              label: m,
              color: exercise.color,
              isPrimary: true,
            )),
        ...exercise.secondaryMuscles.map((m) => _Chip(
              label: m,
              color: exercise.color,
              isPrimary: false,
            )),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isPrimary;
  const _Chip(
      {required this.label, required this.color, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPrimary ? color.withAlpha(18) : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isPrimary ? color.withAlpha(100) : AppColors.outlineVariant,
          width: 2,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isPrimary ? color : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

// ── Step Card ─────────────────────────────────────────────────────────────────

class _StepCard extends StatelessWidget {
  final int number;
  final ExerciseStep step;
  final Color color;
  final int delay;

  const _StepCard(
      {required this.number,
      required this.step,
      required this.color,
      required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.surfaceContainerHigh, width: 2),
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000),
              offset: Offset(0, 3),
              blurRadius: 0),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.description,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn().slideY(
          begin: 0.04,
          end: 0,
          duration: 300.ms,
        );
  }
}

// ── Pro Tip Card ──────────────────────────────────────────────────────────────

class _ProTipCard extends StatelessWidget {
  final String text;
  const _ProTipCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.tertiaryContainer, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.star_rounded,
              color: AppColors.tertiary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pro Tip',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppColors.tertiary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                    height: 1.5,
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

// ── Section Label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: AppColors.onSurfaceVariant,
        letterSpacing: 1.5,
      ),
    );
  }
}

// ── Preview Footer ────────────────────────────────────────────────────────────

class _PreviewFooter extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onStart;
  const _PreviewFooter({required this.exercise, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: const Border(
          top: BorderSide(color: Color(0xFFEEEEEE), width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            offset: const Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      child: Row(
        children: [
          // Stats
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise.type == ExerciseType.plank
                    ? '${exercise.defaultReps} seconds'
                    : '${exercise.defaultReps} reps',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                '${exercise.defaultSets} sets · ${exercise.restSeconds}s rest',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TactileButton(
              color: exercise.color,
              shadowColor: _darken(exercise.color),
              onTap: onStart,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'START EXERCISE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Active Exercise Page ──────────────────────────────────────────────────────

class ActiveExercisePage extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback onFinish;

  const ActiveExercisePage({
    super.key,
    required this.exercise,
    required this.onFinish,
  });

  @override
  State<ActiveExercisePage> createState() => _ActiveExercisePageState();
}

class _ActiveExercisePageState extends State<ActiveExercisePage>
    with SingleTickerProviderStateMixin {
  int _reps = 0;
  late final int _target;
  late AnimationController _pulseCtrl;
  bool _isPlank = false;

  @override
  void initState() {
    super.initState();
    _target = widget.exercise.defaultReps;
    _isPlank = widget.exercise.type == ExerciseType.plank;
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _tap() {
    HapticFeedback.lightImpact();
    _pulseCtrl.forward().then((_) => _pulseCtrl.reverse());
    setState(() {
      _reps = (_reps + 1).clamp(0, _target);
    });
    if (_reps >= _target) {
      Future.delayed(const Duration(milliseconds: 300), widget.onFinish);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _target > 0 ? _reps / _target : 0.0;
    final ex = widget.exercise;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => _QuitDialog(onQuit: widget.onFinish),
                    ),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.outlineVariant, width: 2),
                      ),
                      child: const Icon(Icons.close_rounded,
                          size: 20,
                          color: AppColors.onSurfaceVariant),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    ex.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            // Circular progress + counter
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Rep circle
                  ScaleTransition(
                    scale: Tween<double>(begin: 1.0, end: 1.06).animate(
                      CurvedAnimation(
                          parent: _pulseCtrl, curve: Curves.easeOut),
                    ),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainerLowest,
                        border: Border.all(
                            color: AppColors.surfaceContainerHigh, width: 3),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x12000000),
                              offset: Offset(0, 6),
                              blurRadius: 0),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Circular progress ring
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 10,
                              backgroundColor: AppColors.surfaceContainerHigh,
                              valueColor:
                                  AlwaysStoppedAnimation(ex.color),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(
                                        scale: anim, child: child),
                                child: Text(
                                  '$_reps',
                                  key: ValueKey(_reps),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w900,
                                    color: ex.color,
                                    height: 1,
                                  ),
                                ),
                              ),
                              Text(
                                'of $_target ${_isPlank ? 'sec' : 'reps'}',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Exercise name + muscles
                  Text(
                    ex.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ex.muscleGroups.join(' · '),
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Rep dots
                  if (!_isPlank)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: List.generate(_target, (i) {
                        final done = i < _reps;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          width: done ? 22 : 18,
                          height: done ? 22 : 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: done
                                ? ex.color
                                : AppColors.surfaceContainerHigh,
                            border: Border.all(
                              color: done
                                  ? ex.color
                                  : AppColors.outlineVariant,
                              width: 2,
                            ),
                            boxShadow: done
                                ? [
                                    BoxShadow(
                                        color: ex.color.withAlpha(100),
                                        offset: const Offset(0, 3),
                                        blurRadius: 0)
                                  ]
                                : null,
                          ),
                          child: done
                              ? const Center(
                                  child: Icon(Icons.check_rounded,
                                      size: 12, color: Colors.white))
                              : null,
                        );
                      }),
                    ),
                ],
              ),
            ),
            // Footer buttons
            Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 0, 20, MediaQuery.of(context).padding.bottom + 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _tap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      decoration: BoxDecoration(
                        color: ex.color,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                            color: _darken(ex.color), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: _darken(ex.color),
                            offset: const Offset(0, 6),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _isPlank ? 'COUNT SECOND' : 'TAP PER REP',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: widget.onFinish,
                          child: Text(
                            'Finish Set Early',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurfaceVariant,
                            ),
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
}

// ── Rest Page ─────────────────────────────────────────────────────────────────

class RestPage extends StatefulWidget {
  final String nextExerciseName;
  final RealExercise? nextExerciseReal; // for the preview image
  final int seconds;
  final VoidCallback onSkip;
  final VoidCallback onDone;

  const RestPage({
    super.key,
    required this.nextExerciseName,
    this.nextExerciseReal,
    required this.seconds,
    required this.onSkip,
    required this.onDone,
  });

  @override
  State<RestPage> createState() => _RestPageState();
}

class _RestPageState extends State<RestPage> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        _timer?.cancel();
        widget.onDone();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _remaining / widget.seconds;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Rest badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withAlpha(50),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                      color: AppColors.secondary.withAlpha(80), width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.self_improvement_rounded,
                        color: AppColors.secondary, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'REST TIME',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms),
              const Spacer(),
              // Timer circle
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: AppColors.surfaceContainerHigh,
                      valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                      strokeCap: StrokeCap.round,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_remaining',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            color: AppColors.secondary,
                            height: 1,
                          ),
                        ),
                        Text(
                          'seconds',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Take a breather',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Next up: ${widget.nextExerciseName}',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              // Next exercise preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primary.withAlpha(60),
                      width: 2),
                ),
                child: Row(
                  children: [
                    if (widget.nextExerciseReal != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: ExerciseImageWidget(
                            exercise: widget.nextExerciseReal!,
                            width: 56,
                            height: 56,
                            animate: false,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.fitness_center_rounded,
                            color: AppColors.primary, size: 26),
                      ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COMING UP',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurfaceVariant,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            widget.nextExerciseName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.04, end: 0),
              const SizedBox(height: 20),
              TactileButton(
                color: AppColors.surfaceContainerLow,
                shadowColor: AppColors.outlineVariant,
                border: Border.all(
                    color: AppColors.outlineVariant, width: 2),
                onTap: widget.onSkip,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'SKIP REST',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quit Dialog ───────────────────────────────────────────────────────────────

class _QuitDialog extends StatelessWidget {
  final VoidCallback onQuit;
  const _QuitDialog({required this.onQuit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: AppColors.errorContainer, size: 40),
            const SizedBox(height: 12),
            Text(
              'End Workout?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your progress for this set will be lost.',
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      side: const BorderSide(
                          color: AppColors.outlineVariant, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Keep Going',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorContainer,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      'End',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Color _darken(Color color) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
}

class _LightDotPainter extends CustomPainter {
  final Color color;
  _LightDotPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withAlpha(20);
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Real Exercise Preview Page ────────────────────────────────────────────────
// Uses actual photos from the free-exercise-db dataset

class RealExercisePreviewPage extends StatelessWidget {
  final RealExercise exercise;
  final int index;
  final int total;
  final int sets;
  final int targetReps;
  final int holdSecs;
  final String coachingCue;
  final bool isWarmup;
  final bool isCooldown;
  final VoidCallback onStart;
  final VoidCallback onBack;

  const RealExercisePreviewPage({
    super.key,
    required this.exercise,
    required this.index,
    required this.total,
    this.sets = 3,
    this.targetReps = 10,
    this.holdSecs = 0,
    this.coachingCue = '',
    this.isWarmup = false,
    this.isCooldown = false,
    required this.onStart,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header with progress bar
          Container(
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              border: Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE), width: 2)),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 20,
              right: 20,
              bottom: 16,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onBack,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.outlineVariant, width: 2),
                        ),
                        child: const Icon(Icons.close_rounded,
                            size: 20, color: AppColors.onSurfaceVariant),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _capitalize(exercise.category),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Exercise ${index + 1} of $total',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (index + 1) / total,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated image card
                  Container(
                    width: double.infinity,
                    height: 240,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: const Color(0xFFE5E5E5), width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFE5E5E5),
                          offset: Offset(0, 6),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: ExerciseImageWidget(
                        exercise: exercise,
                        width: double.infinity,
                        height: 240,
                        frameMs: 850,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: 0.04, end: 0),
                  const SizedBox(height: 16),
                  // Name + level
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          exercise.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.onSurface,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _levelColor(exercise.level)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _levelColor(exercise.level)
                                .withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          _capitalize(exercise.level),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: _levelColor(exercise.level),
                          ),
                        ),
                      ),
                    ],
                  ).animate(delay: 80.ms).fadeIn(),
                  const SizedBox(height: 10),
                  // Muscle chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...exercise.primaryMuscles.map((m) => _RealChip(
                            label: m,
                            isPrimary: true,
                          )),
                      ...exercise.secondaryMuscles.map((m) => _RealChip(
                            label: m,
                            isPrimary: false,
                          )),
                    ],
                  ).animate(delay: 120.ms).fadeIn(),
                  const SizedBox(height: 24),
                  // Instructions section
                  Text(
                    'HOW TO DO IT',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...exercise.instructions.asMap().entries.map((e) {
                    final i = e.key;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.surfaceContainerHigh, width: 2),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x08000000),
                              offset: Offset(0, 3),
                              blurRadius: 0),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              e.value,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.onSurface,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate(
                        delay: Duration(milliseconds: 140 + i * 50))
                        .fadeIn()
                        .slideY(begin: 0.04, end: 0, duration: 300.ms);
                  }),
                  if (exercise.equipment != null &&
                      exercise.equipment != 'body only') ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF725800).withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF725800).withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.sports_gymnastics_rounded,
                              color: Color(0xFF725800), size: 18),
                          const SizedBox(width: 10),
                          Text(
                            'Equipment: ${_capitalize(exercise.equipment!)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF725800),
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: 400.ms).fadeIn(),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          // Sticky footer
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              border: const Border(
                  top: BorderSide(color: Color(0xFFEEEEEE), width: 2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  offset: const Offset(0, -4),
                  blurRadius: 12,
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(
                20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isWarmup || isCooldown
                          ? (holdSecs > 0 ? '${holdSecs}s hold' : '$sets × $targetReps reps')
                          : (holdSecs > 0 ? '$sets × ${holdSecs}s hold' : '$sets × $targetReps reps'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      isWarmup ? 'Warm-up' : (isCooldown ? 'Cool-down' : '45s rest between sets'),
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isWarmup
                            ? const Color(0xFF725800)
                            : (isCooldown ? AppColors.tertiary : AppColors.onSurfaceVariant),
                      ),
                    ),
                    if (coachingCue.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '💡 $coachingCue',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TactileButton(
                    color: AppColors.primary,
                    shadowColor: AppColors.primaryDim,
                    onTap: onStart,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'START EXERCISE',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.play_arrow_rounded,
                            color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _levelColor(String level) => switch (level) {
        'beginner' => AppColors.primary,
        'intermediate' => const Color(0xFF725800),
        'expert' => const Color(0xFFb02500),
        _ => AppColors.outlineVariant,
      };

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ── Real Active Exercise Page ─────────────────────────────────────────────────

enum _Phase { working, scoring, resting }

class RealActiveExercisePage extends StatefulWidget {
  final RealExercise exercise;
  final int sets;
  final int targetReps;
  final int holdSecs;
  final String coachingCue;
  final VoidCallback onFinish;

  const RealActiveExercisePage({
    super.key,
    required this.exercise,
    this.sets = 3,
    this.targetReps = 10,
    this.holdSecs = 0,
    this.coachingCue = '',
    required this.onFinish,
  });

  @override
  State<RealActiveExercisePage> createState() => _RealActiveExercisePageState();
}

class _RealActiveExercisePageState extends State<RealActiveExercisePage> {
  static final Map<String, int> _personalBests = {};

  int _currentSet = 1;
  _Phase _phase = _Phase.working;
  int _restSecondsLeft = 45;
  Timer? _restTimer;
  int _sessionXP = 0;
  int _setScore = 0;
  bool _isNewBest = false;

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  void _completeSet() {
    HapticFeedback.mediumImpact();

    if (_currentSet >= widget.sets) {
      widget.onFinish();
    } else {
      setState(() { _phase = _Phase.scoring; _setScore = 0; });
    }
  }

  void _confirmScore(int reps) {
    HapticFeedback.mediumImpact();
    final key = widget.exercise.id;
    final prev = _personalBests[key] ?? 0;
    final newBest = reps > prev;
    if (newBest) _personalBests[key] = reps;
    _addXP(reps * 6 + (newBest ? 30 : 0));
    setState(() { _setScore = reps; _isNewBest = newBest; });
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      _startRest();
    });
  }

  void _startRest() {
    setState(() { _phase = _Phase.resting; _restSecondsLeft = 45; });
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_restSecondsLeft <= 1) {
          t.cancel();
          _phase = _Phase.working;
          _currentSet++;
        } else {
          _restSecondsLeft--;
        }
      });
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    HapticFeedback.lightImpact();
    setState(() { _phase = _Phase.working; _currentSet++; });
  }

  void _addXP(int amount) {
    setState(() {
      _sessionXP += amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with XP
            Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => _QuitDialog(onQuit: widget.onFinish),
                        ),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.outlineVariant, width: 2),
                          ),
                          child: const Icon(Icons.close_rounded, size: 20, color: AppColors.onSurfaceVariant),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.exercise.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      // XP badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryContainer,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.onTertiaryFixed.withValues(alpha: 0.3), width: 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('⚡', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 3),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                              child: Text(
                                '$_sessionXP',
                                key: ValueKey(_sessionXP),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13, fontWeight: FontWeight.w900,
                                  color: AppColors.onTertiaryFixed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Exercise image
                Container(
                  height: 140,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: ExerciseImageWidget(
                      exercise: widget.exercise, width: double.infinity, height: 140, frameMs: 700,
                    ),
                  ),
                ),
                // Phase content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOut,
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(anim),
                        child: child,
                      ),
                    ),
                    child: switch (_phase) {
                      _Phase.working  => _WorkView(key: ValueKey('work_$_currentSet'), context: context),
                      _Phase.scoring  => _ScoringView(key: ValueKey('score_$_currentSet'), context: context),
                      _Phase.resting  => _RestView(key: ValueKey('rest_$_currentSet'), context: context),
                    },
                  ),
                ),
              ],
        ),
      ),
    );
  }

  // ── Work Phase ───────────────────────────────────────────────────────────────

  Widget _WorkView({required Key key, required BuildContext context}) {
    final repLabel = widget.holdSecs > 0
        ? '${widget.holdSecs}s\nhold'
        : '${widget.targetReps}\nreps';
    final isLast = _currentSet >= widget.sets;

    return Padding(
      key: key,
      padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        children: [
          const Spacer(),
          // Set tracker
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.sets, (i) {
              final done = i < _currentSet - 1;
              final active = i == _currentSet - 1;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: active ? 46 : (done ? 36 : 32),
                height: active ? 46 : (done ? 36 : 32),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? AppColors.primary : (active ? AppColors.primaryContainer : AppColors.surfaceContainerHigh),
                  border: Border.all(
                    color: done ? AppColors.primary : (active ? AppColors.primary : AppColors.outlineVariant),
                    width: active ? 3 : 2,
                  ),
                  boxShadow: active ? const [BoxShadow(color: AppColors.primaryDim, offset: Offset(0, 4), blurRadius: 0)] : null,
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                      : Text('${i + 1}', style: GoogleFonts.plusJakartaSans(
                          fontSize: active ? 17 : 13, fontWeight: FontWeight.w900,
                          color: active ? AppColors.primary : AppColors.onSurfaceVariant)),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text('Set $_currentSet of ${widget.sets}',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 16),
          // Big target number card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.outlineVariant, width: 3),
              boxShadow: const [BoxShadow(color: Color(0x0D000000), offset: Offset(0, 6), blurRadius: 0)],
            ),
            child: Column(
              children: [
                Text(repLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 52, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1.05,
                  ), textAlign: TextAlign.center),
                if (widget.coachingCue.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('💡  ${widget.coachingCue}',
                      style: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant, height: 1.4),
                      textAlign: TextAlign.center),
                  ),
                ],
              ],
            ),
          ),
          const Spacer(),
          TactileButton(
            color: AppColors.primary, shadowColor: AppColors.primaryDim,
            onTap: _completeSet,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isLast ? 'FINISH  ✓' : 'SET DONE  ✓',
                    style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900,
                        color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => showDialog(context: context, builder: (_) => _QuitDialog(onQuit: widget.onFinish)),
            child: Text('Quit', style: GoogleFonts.plusJakartaSans(
                fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }

  // ── Scoring Phase ────────────────────────────────────────────────────────────

  Widget _ScoringView({required Key key, required BuildContext context}) {
    final alreadyConfirmed = _setScore > 0;
    return Padding(
      key: key,
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        children: [
          const Spacer(),
          if (!alreadyConfirmed) ...[
            Text('HOW MANY REPS?', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.onSurfaceVariant, letterSpacing: 2)),
            const SizedBox(height: 4),
            Text('Tap your count 👇', style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10, runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ...List.generate(10, (i) => _RepButton(n: i + 1, target: widget.targetReps, onTap: () => _confirmScore(i + 1))),
                _RepButton(n: 11, label: '10+', target: widget.targetReps, onTap: () => _confirmScore(11)),
              ],
            ),
          ] else ...[
            if (_isNewBest)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.onTertiaryFixed, width: 2),
                ),
                child: Text('🔥 NEW BEST!', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.onTertiaryFixed)),
              ).animate().scale(begin: const Offset(0.5, 0.5), duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            Text('$_setScore', style: GoogleFonts.plusJakartaSans(fontSize: 80, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1))
                .animate().scale(begin: const Offset(0.3, 0.3), duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 8),
            Text('reps logged! +${_setScore * 6 + (_isNewBest ? 30 : 0)} XP ⚡',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.onSurfaceVariant)),
          ],
          const Spacer(),
          if (!alreadyConfirmed)
            TextButton(
              onPressed: widget.onFinish,
              child: Text('Skip', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant)),
            ),
        ],
      ),
    );
  }

  // ── Rest Phase ───────────────────────────────────────────────────────────────

  Widget _RestView({required Key key, required BuildContext context}) {
    final progress = _restSecondsLeft / 45;
    return Padding(
      key: key,
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text('REST', style: GoogleFonts.plusJakartaSans(
              fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.onSurfaceVariant, letterSpacing: 3)),
          const SizedBox(height: 18),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150, height: 150,
                child: CircularProgressIndicator(
                  value: progress, strokeWidth: 10,
                  backgroundColor: AppColors.surfaceContainerHigh,
                  valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                  strokeCap: StrokeCap.round,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 120),
                transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                child: Text('$_restSecondsLeft', key: ValueKey(_restSecondsLeft),
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 58, fontWeight: FontWeight.w900, color: AppColors.secondary, height: 1)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Next → Set ${_currentSet + 1} of ${widget.sets}',
            style: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant)),
          const Spacer(),
          TactileButton(
            color: AppColors.secondary, shadowColor: AppColors.secondaryDim,
            onTap: _skipRest,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('SKIP REST', style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w900,
                      color: AppColors.onSecondaryContainer, letterSpacing: 0.5)),
                  const SizedBox(width: 8),
                  Icon(Icons.skip_next_rounded, color: AppColors.onSecondaryContainer, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('Recovery builds strength.', style: GoogleFonts.beVietnamPro(
              fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

// ── Rep Button ────────────────────────────────────────────────────────────────

class _RepButton extends StatelessWidget {
  final int n;
  final String? label;
  final int target;
  final VoidCallback onTap;
  const _RepButton({required this.n, this.label, required this.target, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isTarget = n == target;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 58, height: 58,
        decoration: BoxDecoration(
          color: isTarget ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isTarget ? AppColors.primary : AppColors.outlineVariant,
            width: isTarget ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isTarget ? AppColors.primaryDim : const Color(0x0D000000),
              offset: const Offset(0, 4), blurRadius: 0,
            )
          ],
        ),
        child: Center(
          child: Text(
            label ?? '$n',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20, fontWeight: FontWeight.w900,
              color: isTarget ? AppColors.primary : AppColors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Real chip helper ──────────────────────────────────────────────────────────

class _RealChip extends StatelessWidget {
  final String label;
  final bool isPrimary;
  const _RealChip({required this.label, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.primaryContainer.withValues(alpha: 0.3)
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isPrimary
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.outlineVariant,
          width: 2,
        ),
      ),
      child: Text(
        label[0].toUpperCase() + label.substring(1),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isPrimary ? AppColors.primary : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
