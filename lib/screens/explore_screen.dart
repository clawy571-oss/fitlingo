import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../models/real_exercise.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/tactile_button.dart';
import '../widgets/top_bar.dart';
import 'workout_session_screen.dart';

// ── Workout Template Data ─────────────────────────────────────────────────────

/// A single exercise slot inside a ready-to-go workout.
class _ExerciseSlot {
  final String id;
  final int sets;
  final int reps;
  final int holdSecs;
  final String cue;
  final bool isWarmup;
  final bool isCooldown;
  const _ExerciseSlot(this.id, {
    this.sets = 3,
    this.reps = 10,
    this.holdSecs = 0,
    this.cue = '',
    this.isWarmup = false,
    this.isCooldown = false,
  });
}

class _WorkoutTemplate {
  final String name;
  final String emoji;
  final String durationLabel;
  final String description;
  final WorkoutCategory category;
  final Color color;
  final Color shadow;
  final List<_ExerciseSlot> slots;
  final String tag; // short uppercase label on the card

  const _WorkoutTemplate({
    required this.name,
    required this.emoji,
    required this.durationLabel,
    required this.description,
    required this.category,
    required this.color,
    required this.shadow,
    required this.slots,
    required this.tag,
  });
}

const _allWorkouts = <_WorkoutTemplate>[
  // ── Full Body ──────────────────────────────────────────────────────────────
  _WorkoutTemplate(
    name: 'Full Body Blast',
    emoji: '🔥',
    durationLabel: '30 MIN',
    description: 'Push-ups, squats, core, and cardio — hits everything. The perfect balanced session.',
    category: WorkoutCategory.full,
    color: AppColors.primary,
    shadow: AppColors.primaryDim,
    tag: 'FULL BODY',
    slots: [
      _ExerciseSlot('Arm_Circles', sets: 1, reps: 15, cue: 'Loosen up the shoulders.', isWarmup: true),
      _ExerciseSlot('Pushups', sets: 3, reps: 10, cue: 'Chest nearly touches the floor every rep.'),
      _ExerciseSlot('Bodyweight_Squat', sets: 3, reps: 15, cue: 'Knees track over toes — sit deep.'),
      _ExerciseSlot('Plank', sets: 3, holdSecs: 30, cue: 'Squeeze glutes and abs hard.'),
      _ExerciseSlot('Bodyweight_Walking_Lunge', sets: 3, reps: 10, cue: 'Big step — front knee at 90°.'),
      _ExerciseSlot('Mountain_Climbers', sets: 2, reps: 20, cue: 'Drive knees fast — keep hips level.'),
      _ExerciseSlot('Cat_Stretch', sets: 1, holdSecs: 30, cue: 'Slow breathing — release tension.', isCooldown: true),
    ],
  ),
  _WorkoutTemplate(
    name: 'Quick 10',
    emoji: '⚡',
    durationLabel: '10 MIN',
    description: 'Short on time? This no-excuses circuit hits the whole body in 10 minutes flat.',
    category: WorkoutCategory.full,
    color: AppColors.secondary,
    shadow: AppColors.secondaryDim,
    tag: 'EXPRESS',
    slots: [
      _ExerciseSlot('Pushups', sets: 2, reps: 10, cue: 'Full range — no half reps.'),
      _ExerciseSlot('Bodyweight_Squat', sets: 2, reps: 15, cue: 'Deep and controlled.'),
      _ExerciseSlot('Mountain_Climbers', sets: 2, reps: 20, cue: 'Keep the pace up!'),
      _ExerciseSlot('Plank', sets: 2, holdSecs: 20, cue: 'Straight line ear to heel.'),
      _ExerciseSlot('Dynamic_Chest_Stretch', sets: 1, reps: 10, cue: 'Breathe out on each rep.', isCooldown: true),
    ],
  ),

  // ── Upper Body ─────────────────────────────────────────────────────────────
  _WorkoutTemplate(
    name: 'Upper Body Power',
    emoji: '💪',
    durationLabel: '25 MIN',
    description: 'Push, press, and pull. Chest, shoulders, triceps, and back — complete upper body.',
    category: WorkoutCategory.upper,
    color: const Color(0xFF5C3317),
    shadow: const Color(0xFF3B2010),
    tag: 'UPPER',
    slots: [
      _ExerciseSlot('Arm_Circles', sets: 1, reps: 20, cue: 'Big circles forward and back.', isWarmup: true),
      _ExerciseSlot('Pushups', sets: 3, reps: 12, cue: 'Elbows at 45° from your body.'),
      _ExerciseSlot('Push-Ups_-_Close_Triceps_Position', sets: 3, reps: 8, cue: 'Elbows brush your ribs — feel the triceps.'),
      _ExerciseSlot('Bench_Dips', sets: 3, reps: 12, cue: 'Lower until upper arms are parallel to the floor.'),
      _ExerciseSlot('Bodyweight_Mid_Row', sets: 3, reps: 10, cue: 'Squeeze your shoulder blades together at the top.'),
      _ExerciseSlot('Dynamic_Chest_Stretch', sets: 1, reps: 12, cue: 'Feel the chest open up.', isCooldown: true),
    ],
  ),
  _WorkoutTemplate(
    name: 'Push-Up Pyramid',
    emoji: '🏗️',
    durationLabel: '20 MIN',
    description: 'Every push-up angle: incline → standard → decline → plyometric. Total chest and shoulder work.',
    category: WorkoutCategory.upper,
    color: AppColors.primary,
    shadow: AppColors.primaryDim,
    tag: 'PUSH-UPS',
    slots: [
      _ExerciseSlot('Arm_Circles', sets: 1, reps: 15, cue: 'Warm up those shoulder joints.', isWarmup: true),
      _ExerciseSlot('Incline_Push-Up', sets: 2, reps: 12, cue: 'Establish perfect form here before going flat.'),
      _ExerciseSlot('Pushups', sets: 3, reps: 10, cue: 'Controlled descent — 2 seconds down.'),
      _ExerciseSlot('Push-Up_Wide', sets: 2, reps: 8, cue: 'Wide hands = max chest stretch.'),
      _ExerciseSlot('Decline_Push-Up', sets: 2, reps: 8, cue: 'Feet elevated — upper chest fires.'),
      _ExerciseSlot('Plyo_Push-up', sets: 2, reps: 5, cue: 'Explode off the floor — land soft.'),
      _ExerciseSlot('Dynamic_Chest_Stretch', sets: 1, reps: 10, cue: 'Let the chest fully relax.', isCooldown: true),
    ],
  ),
  _WorkoutTemplate(
    name: 'Arms & Triceps',
    emoji: '💎',
    durationLabel: '20 MIN',
    description: 'Focused tricep and arm work that directly builds toward the one-arm push-up lockout.',
    category: WorkoutCategory.upper,
    color: const Color(0xFF6A0DAD),
    shadow: const Color(0xFF3D007A),
    tag: 'ARMS',
    slots: [
      _ExerciseSlot('Arm_Circles', sets: 1, reps: 15, cue: 'Small circles first, then big.', isWarmup: true),
      _ExerciseSlot('Bench_Dips', sets: 3, reps: 12, cue: 'Keep your back close to the bench.'),
      _ExerciseSlot('Push-Ups_-_Close_Triceps_Position', sets: 3, reps: 10, cue: 'Strict elbows in — no flaring.'),
      _ExerciseSlot('Body_Tricep_Press', sets: 3, reps: 10, cue: 'Lean forward on descent for more tricep stretch.'),
      _ExerciseSlot('Bodyweight_Flyes', sets: 2, reps: 10, cue: 'Slow and controlled — really feel the chest.'),
      _ExerciseSlot('Dynamic_Chest_Stretch', sets: 1, reps: 10, cue: 'Relax and breathe.', isCooldown: true),
    ],
  ),

  // ── Core ───────────────────────────────────────────────────────────────────
  _WorkoutTemplate(
    name: 'Core Crusher',
    emoji: '🔥',
    durationLabel: '20 MIN',
    description: 'Plank, crunches, leg raises, Superman — every core angle covered. Your abs will thank you tomorrow.',
    category: WorkoutCategory.core,
    color: AppColors.error,
    shadow: AppColors.errorDim,
    tag: 'CORE',
    slots: [
      _ExerciseSlot('Arm_Circles', sets: 1, reps: 15, cue: 'Prepare the whole body.', isWarmup: true),
      _ExerciseSlot('Plank', sets: 3, holdSecs: 35, cue: 'Squeeze everything — abs, glutes, quads.'),
      _ExerciseSlot('3_4_Sit-Up', sets: 3, reps: 15, cue: 'Controlled descent — don\'t just fall back.'),
      _ExerciseSlot('Mountain_Climbers', sets: 3, reps: 20, cue: 'Drive each knee fully to your chest.'),
      _ExerciseSlot('Flat_Bench_Lying_Leg_Raise', sets: 3, reps: 12, cue: 'Lower legs slowly — resist gravity.'),
      _ExerciseSlot('Superman', sets: 3, reps: 12, cue: 'Squeeze at the top and hold 1 second.'),
      _ExerciseSlot('Cat_Stretch', sets: 1, holdSecs: 25, cue: 'Decompress the lower back.', isCooldown: true),
    ],
  ),
  _WorkoutTemplate(
    name: 'Ab Finisher',
    emoji: '💥',
    durationLabel: '15 MIN',
    description: 'A core-only burnout to add on after any workout — or use it when you want a quick mid-section hit.',
    category: WorkoutCategory.core,
    color: const Color(0xFFE91E93),
    shadow: const Color(0xFF9C1360),
    tag: 'ABS',
    slots: [
      _ExerciseSlot('Plank', sets: 3, holdSecs: 30, cue: 'Start strong.'),
      _ExerciseSlot('Push_Up_to_Side_Plank', sets: 3, reps: 8, cue: 'Hold the side plank for 2 full seconds.'),
      _ExerciseSlot('Jackknife_Sit-Up', sets: 3, reps: 12, cue: 'Meet in the middle — touch feet to hands.'),
      _ExerciseSlot('Side_Leg_Raises', sets: 2, reps: 15, cue: 'Both sides equally.'),
      _ExerciseSlot('Cat_Stretch', sets: 1, holdSecs: 20, cue: 'Breathe into the stretch.', isCooldown: true),
    ],
  ),

  // ── Legs ───────────────────────────────────────────────────────────────────
  _WorkoutTemplate(
    name: 'Leg Day',
    emoji: '🦵',
    durationLabel: '30 MIN',
    description: 'Squats, lunges, glute bridges, and calf raises — complete lower body work with no equipment.',
    category: WorkoutCategory.legs,
    color: AppColors.tertiary,
    shadow: AppColors.tertiaryDim,
    tag: 'LEGS',
    slots: [
      _ExerciseSlot('Arm_Circles', sets: 1, reps: 15, cue: 'Get the whole body moving.', isWarmup: true),
      _ExerciseSlot('Bodyweight_Squat', sets: 3, reps: 18, cue: 'Sit back into the squat — chest stays up.'),
      _ExerciseSlot('Bodyweight_Walking_Lunge', sets: 3, reps: 12, cue: 'Step long — front knee at 90°.'),
      _ExerciseSlot('Butt_Lift_Bridge', sets: 3, reps: 15, cue: 'Squeeze glutes hard at the top.'),
      _ExerciseSlot('Glute_Kickback', sets: 3, reps: 15, cue: 'Full extension — feel the squeeze.'),
      _ExerciseSlot('Calf_Raises_-_With_Bands', sets: 3, reps: 20, cue: 'Slow and full range.'),
      _ExerciseSlot('Cat_Stretch', sets: 1, holdSecs: 30, cue: 'Lower back relief.', isCooldown: true),
    ],
  ),
  _WorkoutTemplate(
    name: 'Glutes Focus',
    emoji: '🍑',
    durationLabel: '25 MIN',
    description: 'Targeted glute and hip work. Great for balance, posture, and building the posterior chain.',
    category: WorkoutCategory.legs,
    color: AppColors.onTertiaryFixed,
    shadow: const Color(0xFF7A5F00),
    tag: 'GLUTES',
    slots: [
      _ExerciseSlot('Arm_Circles', sets: 1, reps: 15, cue: 'Full body warm-up.', isWarmup: true),
      _ExerciseSlot('Butt_Lift_Bridge', sets: 4, reps: 20, cue: 'Pulse at the top for extra burn.'),
      _ExerciseSlot('Glute_Kickback', sets: 3, reps: 20, cue: 'Keep the hips square to the floor.'),
      _ExerciseSlot('Rear_Leg_Raises', sets: 3, reps: 15, cue: 'Don\'t swing — controlled movement.'),
      _ExerciseSlot('Bodyweight_Walking_Lunge', sets: 3, reps: 12, cue: 'Drive through the front heel.'),
      _ExerciseSlot('Cat_Stretch', sets: 1, holdSecs: 25, cue: 'Hip flexor release.', isCooldown: true),
    ],
  ),

  // ── Cardio ─────────────────────────────────────────────────────────────────
  _WorkoutTemplate(
    name: 'Cardio HIIT',
    emoji: '💨',
    durationLabel: '20 MIN',
    description: 'High-intensity intervals that burn calories and boost endurance. Short rest, high effort.',
    category: WorkoutCategory.cardio,
    color: AppColors.error,
    shadow: AppColors.errorDim,
    tag: 'HIIT',
    slots: [
      _ExerciseSlot('Arm_Circles', sets: 1, reps: 20, cue: 'Warm up — focus on breathing.', isWarmup: true),
      _ExerciseSlot('Mountain_Climbers', sets: 3, reps: 30, cue: 'Push the pace — knees all the way to chest.'),
      _ExerciseSlot('Air_Bike', sets: 3, reps: 20, cue: 'Elbow to opposite knee — really crunch.'),
      _ExerciseSlot('Plyo_Push-up', sets: 3, reps: 8, cue: 'Max explosion — push yourself off the floor.'),
      _ExerciseSlot('Rope_Jumping', sets: 3, holdSecs: 45, cue: 'Light on your feet — wrists do the work.'),
      _ExerciseSlot('Dynamic_Chest_Stretch', sets: 1, reps: 12, cue: 'Breathe and let the heart rate come down.', isCooldown: true),
    ],
  ),

  // ── Recovery ───────────────────────────────────────────────────────────────
  _WorkoutTemplate(
    name: 'Active Recovery',
    emoji: '🌿',
    durationLabel: '15 MIN',
    description: 'Gentle movement and stretching to help your muscles recover and reduce soreness.',
    category: WorkoutCategory.recovery,
    color: AppColors.tertiary,
    shadow: AppColors.tertiaryDim,
    tag: 'RECOVERY',
    slots: [
      _ExerciseSlot('Arm_Circles', sets: 1, reps: 12, cue: 'Slow and easy.', isWarmup: true),
      _ExerciseSlot('Cat_Stretch', sets: 2, holdSecs: 25, cue: 'Breathe into each position.'),
      _ExerciseSlot('Superman', sets: 2, reps: 10, cue: 'Gentle lower back activation.'),
      _ExerciseSlot('Dynamic_Chest_Stretch', sets: 2, reps: 12, cue: 'Let the chest fully open.'),
      _ExerciseSlot('Bodyweight_Squat', sets: 1, reps: 10, cue: 'Light and easy — just movement.'),
      _ExerciseSlot('Cat_Stretch', sets: 1, holdSecs: 30, cue: 'Final deep breath — relax everything.', isCooldown: true),
    ],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final Map<String, RealExercise> _exercises = {};
  WorkoutCategory? _selectedCategory; // null = show all

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    await ExerciseDatabase.instance.load();
    if (!mounted) return;
    final db = ExerciseDatabase.instance;
    final allIds = <String>{};
    for (final w in _allWorkouts) {
      for (final s in w.slots) {
        allIds.add(s.id);
      }
    }
    for (final id in allIds) {
      final ex = db.byId(id);
      if (ex != null) _exercises[id] = ex;
    }
    if (mounted) setState(() {});
  }

  void _launchWorkout(_WorkoutTemplate template) {
    HapticFeedback.mediumImpact();
    final prescriptions = <ExercisePrescription>[];
    for (final slot in template.slots) {
      final ex = _exercises[slot.id];
      if (ex == null) continue;
      prescriptions.add(ExercisePrescription(
        exercise: ex,
        sets: slot.sets,
        reps: slot.reps,
        holdSecs: slot.holdSecs,
        coachingCue: slot.cue,
        isWarmup: slot.isWarmup,
        isCooldown: slot.isCooldown,
      ));
    }
    if (prescriptions.isEmpty) return;

    gLogWorkout(template.category);

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => WorkoutSessionScreen(prescriptions: prescriptions),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  List<_WorkoutTemplate> get _filteredWorkouts {
    if (_selectedCategory == null) return _allWorkouts;
    return _allWorkouts.where((w) => w.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final recommended = _getRecommendedWorkout();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FitLingoTopBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Greeting
            _GreetingHeader().animate().fadeIn(duration: 350.ms),
            const SizedBox(height: 24),

            // Smart Recommendation Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _RecommendationCard(
                workout: recommended,
                reason: gGetRecommendationReason(),
                onTap: () => _launchWorkout(recommended),
              ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.05, end: 0),
            ),
            const SizedBox(height: 28),

            // "What do you want to train?" + focus chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'WHAT DO YOU WANT TO TRAIN?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
            ).animate(delay: 180.ms).fadeIn(),
            const SizedBox(height: 12),
            _FocusChips(
              selected: _selectedCategory,
              onSelect: (cat) => setState(() {
                _selectedCategory = _selectedCategory == cat ? null : cat;
              }),
            ).animate(delay: 220.ms).fadeIn(),
            const SizedBox(height: 24),

            // Workout list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (int i = 0; i < _filteredWorkouts.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _WorkoutCard(
                        workout: _filteredWorkouts[i],
                        onTap: () => _launchWorkout(_filteredWorkouts[i]),
                        delay: 280 + i * 60,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _WorkoutTemplate _getRecommendedWorkout() {
    final recommendedCat = gGetRecommendedCategory();
    // Find first workout matching the recommended category
    final match = _allWorkouts.firstWhere(
      (w) => w.category == recommendedCat,
      orElse: () => _allWorkouts.first,
    );
    return match;
  }
}

// ── Greeting Header ───────────────────────────────────────────────────────────

class _GreetingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning ☀️'
        : hour < 17
            ? 'Good Afternoon 🌤'
            : 'Good Evening 🌙';

    final hasHistory = gWorkoutHistory.isNotEmpty;
    final subtitle = hasHistory
        ? '${gWorkoutHistory.length} sessions logged — keep the streak!'
        : "Ready for your first session?";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.tertiaryContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.tertiaryFixedDim, width: 3),
              boxShadow: const [
                BoxShadow(color: AppColors.tertiaryDim, offset: Offset(0, 4), blurRadius: 0),
              ],
            ),
            child: Center(
              child: Text(
                hour < 12 ? '☀️' : hour < 17 ? '🌤' : '🌙',
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                  height: 1.1,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Recommendation Card ───────────────────────────────────────────────────────

class _RecommendationCard extends StatelessWidget {
  final _WorkoutTemplate workout;
  final String reason;
  final VoidCallback onTap;

  const _RecommendationCard({
    required this.workout,
    required this.reason,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: workout.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: workout.shadow, width: 3),
        boxShadow: [
          BoxShadow(color: workout.shadow, offset: const Offset(0, 8), blurRadius: 0),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Background decoration
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '⭐ RECOMMENDED FOR YOU',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workout.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            workout.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            reason,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                workout.durationLabel.split(' ')[0],
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                              Text(
                                'min',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${workout.slots.where((s) => !s.isWarmup && !s.isCooldown).length} exercises',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TactileButton(
                  color: Colors.white,
                  shadowColor: workout.shadow,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  onTap: onTap,
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, color: workout.color, size: 22),
                        const SizedBox(width: 6),
                        Text(
                          'START WORKOUT',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: workout.color,
                            letterSpacing: 0.5,
                          ),
                        ),
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
}

// ── Focus Chips ───────────────────────────────────────────────────────────────

class _FocusChips extends StatelessWidget {
  final WorkoutCategory? selected;
  final void Function(WorkoutCategory) onSelect;

  const _FocusChips({required this.selected, required this.onSelect});

  static const _options = [
    WorkoutCategory.full,
    WorkoutCategory.upper,
    WorkoutCategory.core,
    WorkoutCategory.legs,
    WorkoutCategory.cardio,
    WorkoutCategory.recovery,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (ctx, i) {
          final cat = _options[i];
          final isSelected = selected == cat;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onSelect(cat);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isSelected ? AppColors.primaryDim : AppColors.outlineVariant,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected ? AppColors.primaryDim : const Color(0x0A000000),
                    offset: const Offset(0, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Text(
                '${cat.emoji} ${cat.label}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : AppColors.onSurface,
                ),
              ),
            )
                .animate(delay: Duration(milliseconds: 220 + i * 40))
                .fadeIn(duration: 250.ms)
                .slideX(begin: 0.1, end: 0),
          );
        },
      ),
    );
  }
}

// ── Workout Card ──────────────────────────────────────────────────────────────

class _WorkoutCard extends StatelessWidget {
  final _WorkoutTemplate workout;
  final VoidCallback onTap;
  final int delay;

  const _WorkoutCard({
    required this.workout,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final exerciseCount = workout.slots.where((s) => !s.isWarmup && !s.isCooldown).length;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.outlineVariant, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              offset: Offset(0, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon bubble
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: workout.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: workout.color.withValues(alpha: 0.3), width: 2),
              ),
              child: Center(
                child: Text(workout.emoji, style: const TextStyle(fontSize: 30)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: workout.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          workout.tag,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: workout.color,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    workout.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    workout.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.schedule_rounded,
                        label: workout.durationLabel,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.fitness_center_rounded,
                        label: '$exerciseCount exercises',
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Play button
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: workout.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: workout.shadow,
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.06, end: 0);
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
