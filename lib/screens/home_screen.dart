import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/real_exercise.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/exercise_image.dart';
import '../widgets/tactile_button.dart';
import '../widgets/top_bar.dart';
import 'workout_session_screen.dart';

// ── Step Types ────────────────────────────────────────────────────────────────

enum _StepType { strength, mobility, stability, cardio, recovery, milestone, boss }

extension _StepTypeX on _StepType {
  Color get color => switch (this) {
        _StepType.strength  => AppColors.primary,
        _StepType.mobility  => const Color(0xFFB55E00),
        _StepType.stability => AppColors.secondary,
        _StepType.cardio    => AppColors.error,
        _StepType.recovery  => AppColors.tertiary,
        _StepType.milestone => AppColors.onTertiaryFixed,
        _StepType.boss      => const Color(0xFFB8860B),
      };
  Color get lightColor => switch (this) {
        _StepType.strength  => AppColors.primaryContainer,
        _StepType.mobility  => const Color(0xFFFFE0B2),
        _StepType.stability => AppColors.secondaryContainer,
        _StepType.cardio    => const Color(0xFFFFCDD2),
        _StepType.recovery  => AppColors.tertiaryContainer,
        _StepType.milestone => AppColors.tertiaryContainer,
        _StepType.boss      => const Color(0xFFFFD700),
      };
  Color get shadowColor => switch (this) {
        _StepType.strength  => AppColors.primaryDim,
        _StepType.mobility  => const Color(0xFF7A3F00),
        _StepType.stability => AppColors.secondaryDim,
        _StepType.cardio    => AppColors.errorDim,
        _StepType.recovery  => AppColors.tertiaryDim,
        _StepType.milestone => AppColors.tertiaryDim,
        _StepType.boss      => const Color(0xFF8B6914),
      };
  IconData get icon => switch (this) {
        _StepType.strength  => Icons.fitness_center_rounded,
        _StepType.mobility  => Icons.self_improvement_rounded,
        _StepType.stability => Icons.shield_rounded,
        _StepType.cardio    => Icons.bolt_rounded,
        _StepType.recovery  => Icons.spa_rounded,
        _StepType.milestone => Icons.emoji_events_rounded,
        _StepType.boss      => Icons.emoji_events_rounded,
      };
}

// ── Path Data ─────────────────────────────────────────────────────────────────

class _PathChapter {
  final int number;
  final String title;
  final String subtitle;
  const _PathChapter(this.number, this.title, this.subtitle);
}

class _PathStep {
  final String id;           // Main exercise ID (empty for milestones)
  final String warmUpId;     // Warm-up exercise ID
  final String coolDownId;   // Cool-down exercise ID
  final String label;        // Short node label
  final String fullName;
  final String description;
  final _StepType type;
  final int chapterIndex;
  final int sets;
  final int reps;
  final int holdSecs;
  final String coachingCue;
  final String sessionTitle;

  const _PathStep({
    this.id = '',
    this.warmUpId = 'Arm_Circles',
    this.coolDownId = 'Dynamic_Chest_Stretch',
    required this.label,
    required this.fullName,
    required this.description,
    required this.type,
    required this.chapterIndex,
    this.sets = 2,
    this.reps = 8,
    this.holdSecs = 0,
    this.coachingCue = '',
    this.sessionTitle = '',
  });

  bool get isMilestone => type == _StepType.milestone;
  bool get isBoss => type == _StepType.boss;
  bool get hasExercise => id.isNotEmpty;
}

const _pathChapters = [
  _PathChapter(1, 'Try It Out',     'One rep is all it takes to start'),
  _PathChapter(2, 'Find the Floor', 'Lower the angle, raise your game'),
  _PathChapter(3, 'First Real Rep', 'Standard push-ups start here'),
  _PathChapter(4, 'Tricep Power',   'Build the muscle that drives one-arm PUs'),
  _PathChapter(5, 'Load Up',        'More weight, more power, more you'),
  _PathChapter(6, 'One Side',       'Shift to single-arm prep'),
  _PathChapter(7, 'Final Boss',     'The one-arm push-up awaits'),
];

const _pathSteps = <_PathStep>[

  // ── Chapter 1: Try It Out (4 sessions + milestone) ────────────────────────
  _PathStep(
    id: 'Incline_Push-Up', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: 'Just\nOne ⚡', fullName: 'Day 1 — Your First Rep',
    description: 'Stand an arm\'s length from a wall. Put your hands flat on it. Push yourself away one single time. That\'s it. One rep. You started.',
    type: _StepType.strength, chapterIndex: 0, sets: 1, reps: 1,
    coachingCue: 'Body in a straight line — from ears to heels.',
    sessionTitle: 'One Rep',
  ),
  _PathStep(
    id: 'Incline_Push-Up', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: 'Three\nTimes', fullName: 'Day 2 — Three Reps!',
    description: 'Same wall. This time do three. You\'ve already done one — three is just twice more.',
    type: _StepType.strength, chapterIndex: 0, sets: 1, reps: 3,
    coachingCue: 'Breathe out on each push away.',
    sessionTitle: 'Three Times',
  ),
  _PathStep(
    id: 'Incline_Push-Up', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: 'Five +\nFive', fullName: 'Day 3 — Two Sets of Five',
    description: 'Two sets of five. Rest a minute between. Notice how your chest and arms warm up after set 1.',
    type: _StepType.strength, chapterIndex: 0, sets: 2, reps: 5,
    coachingCue: 'Elbows at 45° — not straight out to the sides.',
    sessionTitle: 'Two Sets',
  ),
  _PathStep(
    id: 'Plank', warmUpId: 'Arm_Circles', coolDownId: 'Cat_Stretch',
    label: 'Plank\n🛡️', fullName: 'Day 4 — Core Foundation',
    description: 'Push-ups are planks in motion. Hold for 20 seconds. This builds the core rigidity that makes every rep cleaner.',
    type: _StepType.stability, chapterIndex: 0, sets: 2, holdSecs: 20,
    coachingCue: 'Squeeze glutes and abs — like bracing for a punch.',
    sessionTitle: 'Core Day',
  ),
  _PathStep(
    label: 'CH 1\nDONE', fullName: 'You Started! 🌱',
    description: 'You showed up and did the reps. That\'s the hardest part. The wall push-up pattern is in your brain. Now we lower the angle.',
    type: _StepType.milestone, chapterIndex: 0,
  ),

  // ── Chapter 2: Find the Floor (5 sessions + milestone) ────────────────────
  _PathStep(
    id: 'Incline_Push-Up_Medium', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: 'Desk\nLevel', fullName: 'Day 5 — Hands on a Desk',
    description: 'Hands on a desk or table (about hip height). More bodyweight than the wall — 4 reps is enough to feel the difference.',
    type: _StepType.strength, chapterIndex: 1, sets: 2, reps: 4,
    coachingCue: 'Shoulders directly over wrists at the top.',
    sessionTitle: 'Desk Push-Up',
  ),
  _PathStep(
    id: 'Incline_Push-Up_Medium', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: 'Desk\n×5', fullName: 'Day 6 — Five at Desk Height',
    description: '5 reps, 2 sets. The body adapts fast here — you should feel it getting easier already.',
    type: _StepType.strength, chapterIndex: 1, sets: 2, reps: 5,
    coachingCue: '2-second descent — slow = stronger.',
    sessionTitle: 'Building Volume',
  ),
  _PathStep(
    id: 'Incline_Push-Up_Medium', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: '3×5\nDesk', fullName: 'Day 7 — Three Sets',
    description: 'Three sets of five. The jump from 2 to 3 sets is bigger than you\'d think. Rest fully between each.',
    type: _StepType.strength, chapterIndex: 1, sets: 3, reps: 5,
    coachingCue: 'Breathe out on the push, in on the lower.',
    sessionTitle: 'Three Sets',
  ),
  _PathStep(
    id: 'Plank', warmUpId: 'Arm_Circles', coolDownId: 'Cat_Stretch',
    label: 'Plank\n3×25s', fullName: 'Day 8 — Stronger Core',
    description: '25 seconds now. Notice the difference from Day 4. Your core is already stronger.',
    type: _StepType.stability, chapterIndex: 1, sets: 3, holdSecs: 25,
    coachingCue: 'Eyes down, breathe steadily.',
    sessionTitle: 'Core Day 2',
  ),
  _PathStep(
    id: 'Incline_Push-Up_Medium', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: '3×8\nGraduate', fullName: 'Day 9 — Incline Graduate!',
    description: '3×8. You\'ve hit the graduation mark for this level. Time for the floor.',
    type: _StepType.strength, chapterIndex: 1, sets: 3, reps: 8,
    coachingCue: 'Full range — chest close to the surface.',
    sessionTitle: 'Graduated!',
  ),
  _PathStep(
    label: 'CH 2\nDONE', fullName: 'Incline Mastered 🔥',
    description: 'You\'ve trained at two angles. Your chest, shoulders, and triceps are building real strength. The floor is next.',
    type: _StepType.milestone, chapterIndex: 1,
  ),

  // ── Chapter 3: First Real Rep (5 sessions + milestone) ────────────────────
  _PathStep(
    id: 'Pushups', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: 'Floor.\nOne. 🎯', fullName: 'Day 10 — One Floor Push-Up',
    description: 'Hands on the floor. Just do one. One perfect, full-range floor push-up. Chest close to the floor. Arms fully extended at the top.',
    type: _StepType.strength, chapterIndex: 2, sets: 1, reps: 1,
    coachingCue: 'Hands just outside shoulders. Chest nearly touches the floor.',
    sessionTitle: 'The Real Thing',
  ),
  _PathStep(
    id: 'Pushups', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: 'Floor\n×3', fullName: 'Day 11 — Three on the Floor',
    description: 'Three reps. You\'ve already done one — this is just twice more. But the floor is harder than incline. Quality beats quantity every time.',
    type: _StepType.strength, chapterIndex: 2, sets: 2, reps: 3,
    coachingCue: 'Control the descent — 2 full seconds down.',
    sessionTitle: 'Three Reps',
  ),
  _PathStep(
    id: 'Pushups', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: 'Floor\n2×5', fullName: 'Day 12 — Two Sets of Five',
    description: '5 reps per set — the point where most beginners start to struggle. Rep 5 should feel hard. That\'s where strength grows.',
    type: _StepType.strength, chapterIndex: 2, sets: 2, reps: 5,
    coachingCue: 'Don\'t rush — slow reps build more strength.',
    sessionTitle: 'Five Reps',
  ),
  _PathStep(
    id: 'Pushups', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: 'Floor\n3×5', fullName: 'Day 13 — Three Sets of Five',
    description: 'Now with 3 sets. Notice how much more in control you feel compared to Day 10. That\'s weeks of adaptation compressed into days.',
    type: _StepType.strength, chapterIndex: 2, sets: 3, reps: 5,
    coachingCue: 'Lock out fully at the top — squeeze chest.',
    sessionTitle: 'Three Sets',
  ),
  _PathStep(
    id: 'Pushups', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: '3×8\n⭐', fullName: 'Day 14 — Push-Up Certified!',
    description: '3 sets of 8. The standard push-up benchmark. Most adults can\'t do this. You now own the standard push-up. Ready for harder.',
    type: _StepType.strength, chapterIndex: 2, sets: 3, reps: 8,
    coachingCue: 'Chest nearly touches the floor every single rep.',
    sessionTitle: 'Certified!',
  ),
  _PathStep(
    label: 'CH 3\nDONE', fullName: 'Push-Up Certified! 💪',
    description: 'You can do 3×8 clean floor push-ups. That puts you in the top third of adults. The advanced work starts now.',
    type: _StepType.milestone, chapterIndex: 2,
  ),

  // ── Chapter 4: Tricep Power (4 sessions + milestone) ─────────────────────
  _PathStep(
    id: 'Push-Ups_-_Close_Triceps_Position', warmUpId: 'Arm_Circles', coolDownId: 'Cat_Stretch',
    label: 'Elbows\nIn 💎', fullName: 'Day 15 — Elbows In',
    description: 'Same push-up but elbows track close to your ribs. Immediately shifts the load to your triceps — the most important muscle for the one-arm push-up.',
    type: _StepType.strength, chapterIndex: 3, sets: 2, reps: 4,
    coachingCue: 'Elbows brush your sides the whole way down and up.',
    sessionTitle: 'Tricep Mode',
  ),
  _PathStep(
    id: 'Push-Up_Wide', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: 'Go\nWide 🦅', fullName: 'Day 16 — Wide Grip',
    description: 'Hands wide (beyond shoulder width). Max chest stretch and activation. Balances the tricep-heavy work. Your chest will feel this differently.',
    type: _StepType.strength, chapterIndex: 3, sets: 3, reps: 5,
    coachingCue: 'Feel the stretch deep in your chest at the bottom.',
    sessionTitle: 'Wide Grip',
  ),
  _PathStep(
    id: 'Push-Ups_-_Close_Triceps_Position', warmUpId: 'Arm_Circles', coolDownId: 'Cat_Stretch',
    label: 'Tricep\n3×6', fullName: 'Day 17 — Tricep Volume',
    description: '6 reps with strict elbows-in. If elbows flare — stop. Quality is everything here. This is building the one-arm lockout strength.',
    type: _StepType.strength, chapterIndex: 3, sets: 3, reps: 6,
    coachingCue: 'If elbows flare out — stop and rest. Strict form only.',
    sessionTitle: 'Lockout Strength',
  ),
  _PathStep(
    id: 'Pushups_Close_and_Wide_Hand_Positions', warmUpId: 'Arm_Circles', coolDownId: 'Cat_Stretch',
    label: 'Diamond\n✦', fullName: 'Day 18 — Diamond Push-Up',
    description: 'Thumb to thumb, index to index — diamond under your chest. Maximum tricep + chest load. This is genuinely hard. 4 clean reps is a real achievement.',
    type: _StepType.strength, chapterIndex: 3, sets: 2, reps: 4,
    coachingCue: 'Diamond under your sternum, not your face.',
    sessionTitle: 'Diamond Hands',
  ),
  _PathStep(
    label: 'CH 4\nDONE', fullName: 'Tricep Power Badge 💎',
    description: 'Wide, close, and diamond push-ups. Full spectrum chest and tricep strength. The one-arm push-up uses exactly this — amplified.',
    type: _StepType.milestone, chapterIndex: 3,
  ),

  // ── Chapter 5: Load Up (4 sessions + milestone) ───────────────────────────
  _PathStep(
    id: 'Decline_Push-Up', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: 'Feet\nUp 🚀', fullName: 'Day 19 — Feet Elevated',
    description: 'Feet on a chair, hands on the floor. More bodyweight shifts forward — upper chest and shoulders take over. Harder than it looks.',
    type: _StepType.strength, chapterIndex: 4, sets: 2, reps: 4,
    coachingCue: 'Hips level — don\'t let them pike up.',
    sessionTitle: 'Feet Elevated',
  ),
  _PathStep(
    id: 'Push_Up_to_Side_Plank', warmUpId: 'Arm_Circles', coolDownId: 'Cat_Stretch',
    label: 'Spin\nIt 🌀', fullName: 'Day 20 — Push-Up to Side Plank',
    description: 'Do a push-up, then rotate to a side plank. This lateral core stability prevents your body rotating in a one-arm push-up.',
    type: _StepType.stability, chapterIndex: 4, sets: 3, reps: 5,
    coachingCue: 'Hold the side plank for 2 full seconds — really feel it.',
    sessionTitle: 'Stability Combo',
  ),
  _PathStep(
    id: 'Decline_Push-Up', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: 'Decline\n3×6', fullName: 'Day 21 — Decline Volume',
    description: '6 decline reps. Upper chest and shoulder strength building. The forward-shifted load trains you for the one-arm position.',
    type: _StepType.strength, chapterIndex: 4, sets: 3, reps: 6,
    coachingCue: 'Chest leads the descent — don\'t just drop your face.',
    sessionTitle: 'Upper Chest Day',
  ),
  _PathStep(
    id: 'Plyo_Push-up', warmUpId: 'Arm_Circles', coolDownId: 'Dynamic_Chest_Stretch',
    label: 'BOOM\n💥', fullName: 'Day 22 — Explosive Push!',
    description: 'Push-up so explosive your hands leave the ground. The fast-twitch power you build drives through the sticking point of a one-arm push-up.',
    type: _StepType.cardio, chapterIndex: 4, sets: 2, reps: 5,
    coachingCue: 'Land soft — absorb into the next explosive rep.',
    sessionTitle: 'Explosive!',
  ),
  _PathStep(
    label: 'CH 5\nDONE', fullName: 'Power Builder Badge 🔥',
    description: 'Upper chest, lateral stability, explosive power — all unlocked. You\'re stronger than 90%+ of people who start. Time to go one-sided.',
    type: _StepType.milestone, chapterIndex: 4,
  ),

  // ── Chapter 6: One Side (4 sessions + milestone) ──────────────────────────
  _PathStep(
    id: 'Pushups_Close_and_Wide_Hand_Positions', warmUpId: 'Arm_Circles', coolDownId: 'Cat_Stretch',
    label: 'Archer\n2×4', fullName: 'Day 23 — Archer Push-Up',
    description: 'One arm bends while the other extends straight out. One arm carries ~70% of your weight. The most direct one-arm preparation. Do both sides equally.',
    type: _StepType.strength, chapterIndex: 5, sets: 2, reps: 4,
    coachingCue: 'Extended arm stays fully straight — don\'t cheat it.',
    sessionTitle: 'Asymmetric Load',
  ),
  _PathStep(
    id: 'Clock_Push-Up', warmUpId: 'Arm_Circles', coolDownId: 'Cat_Stretch',
    label: 'Clock\n🕐', fullName: 'Day 24 — Clock Push-Up',
    description: 'One hand is the "clock hand" that moves to different positions while the other does the push. Anti-rotation stability under load.',
    type: _StepType.stability, chapterIndex: 5, sets: 3, reps: 5,
    coachingCue: 'Resist the rotation — your core holds you square.',
    sessionTitle: 'Anti-Rotation',
  ),
  _PathStep(
    id: 'Pushups_Close_and_Wide_Hand_Positions', warmUpId: 'Arm_Circles', coolDownId: 'Cat_Stretch',
    label: 'Archer\n3×6', fullName: 'Day 25 — Archer Volume',
    description: '6 archer reps each side. One side will feel weaker — train both equally. The imbalance shrinks every session.',
    type: _StepType.strength, chapterIndex: 5, sets: 3, reps: 6,
    coachingCue: 'Don\'t rotate your hips — both shoulders stay square.',
    sessionTitle: 'Both Sides Equal',
  ),
  _PathStep(
    id: 'Incline_Push-Up', warmUpId: 'Arm_Circles', coolDownId: 'Cat_Stretch',
    label: 'One-Arm\nIncline', fullName: 'Day 26 — First One-Arm!',
    description: 'One hand on a bench, one arm behind your back. Full one-arm push-up pattern at reduced load. Even 4 reps each side is extraordinary.',
    type: _StepType.strength, chapterIndex: 5, sets: 2, reps: 4,
    coachingCue: 'Hand under chest, wide feet for balance.',
    sessionTitle: 'First One-Arm',
  ),
  _PathStep(
    label: 'CH 6\nDONE', fullName: 'One Side Ready 🦾',
    description: 'Asymmetric loading, anti-rotation core, and your first one-arm reps. The final boss is real.',
    type: _StepType.milestone, chapterIndex: 5,
  ),

  // ── Chapter 7: Final Boss (3 sessions + boss) ─────────────────────────────
  _PathStep(
    id: 'Incline_Push-Up', warmUpId: 'Arm_Circles', coolDownId: 'Cat_Stretch',
    label: 'One-Arm\nStronger', fullName: 'Day 27 — Incline One-Arm ×6',
    description: '6 reps each side at incline. Your one-arm form is getting clean. Each rep builds the neural pattern for the floor version.',
    type: _StepType.strength, chapterIndex: 6, sets: 3, reps: 6,
    coachingCue: 'Torso stays parallel — don\'t rotate to compensate.',
    sessionTitle: 'Refine the Form',
  ),
  _PathStep(
    id: 'Single-Arm_Push-Up', warmUpId: 'Arm_Circles', coolDownId: 'Cat_Stretch',
    label: 'Floor\nOne 🎯', fullName: 'Day 28 — First Floor One-Arm',
    description: 'On the floor. One hand. Just 3 each side. Even one clean rep is something most humans never achieve in their lives.',
    type: _StepType.strength, chapterIndex: 6, sets: 2, reps: 3,
    coachingCue: 'Wide feet, arm close to body, core braced like iron.',
    sessionTitle: 'Floor One-Arm',
  ),
  _PathStep(
    id: 'Single-Arm_Push-Up', warmUpId: 'Arm_Circles', coolDownId: 'Cat_Stretch',
    label: 'ONE\nARM 🏆', fullName: 'BOSS — One-Arm Push-Up 🏆',
    description: 'Full range. One arm. Perfect form. 3 sets of 5 each side. This is the summit. You built every single brick of this road.',
    type: _StepType.boss, chapterIndex: 6, sets: 3, reps: 5,
    coachingCue: 'Slow and controlled. Every rep is earned. You made it.',
    sessionTitle: 'ONE-ARM LEGEND',
  ),
];

// Computed getters
int get _totalSteps => _pathSteps.where((s) => !s.isMilestone && !s.isBoss).length;

// ── Screen ────────────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Persists across rebuilds via static — initialized once from app state (onboarding sets this)
  static bool _initialized = false;
  static int _completedCount = 0;

  Map<String, RealExercise> _exercises = {};

  @override
  void initState() {
    super.initState();
    // On first init, read the path start set by onboarding assessment
    if (!_initialized) {
      _initialized = true;
      _completedCount = gPathCompletedCount;
    }
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    await ExerciseDatabase.instance.load();
    if (!mounted) return;
    final db = ExerciseDatabase.instance;
    final map = <String, RealExercise>{};
    // Collect all unique IDs: main + warmup + cooldown
    final allIds = <String>{};
    for (final step in _pathSteps) {
      if (step.hasExercise) allIds.add(step.id);
      if (step.warmUpId.isNotEmpty) allIds.add(step.warmUpId);
      if (step.coolDownId.isNotEmpty) allIds.add(step.coolDownId);
    }
    for (final id in allIds) {
      final ex = db.byId(id);
      if (ex != null) map[id] = ex;
    }
    if (mounted) setState(() => _exercises = map);
  }

  // ── State Helpers ───────────────────────────────────────────────────────

  /// 0=completed, 1=active, 2=challenge(next 1-2), 3=locked
  int _nodeState(int index) {
    if (index < _completedCount) return 0; // completed
    if (index == _completedCount) return 1; // active
    if (index <= _completedCount + 2) return 2; // challenge-able
    return 3; // locked
  }

  void _markComplete(int stepIndex) {
    if (stepIndex != _completedCount) return; // only active step
    setState(() {
      _completedCount++;
      // Auto-skip milestones when chapter is complete
      while (_completedCount < _pathSteps.length &&
          _pathSteps[_completedCount].isMilestone) {
        _completedCount++;
      }
    });
    HapticFeedback.mediumImpact();
  }

  void _challengeJump(int stepIndex) {
    // Jump to this step, marking everything before as complete
    setState(() {
      _completedCount = stepIndex;
      // Auto-skip any milestones in between
      while (_completedCount < _pathSteps.length &&
          _pathSteps[_completedCount].isMilestone) {
        _completedCount++;
      }
      if (_completedCount > stepIndex) _completedCount = stepIndex;
    });
    HapticFeedback.mediumImpact();
  }

  // ── Navigation ──────────────────────────────────────────────────────────

  void _startExercise(int stepIndex, {bool fromChallenge = false}) {
    final step = _pathSteps[stepIndex];
    if (!step.hasExercise) return;
    final mainExercise = _exercises[step.id];
    if (mainExercise == null) return;

    // Build full session: warmup → main → cooldown
    final prescriptions = <ExercisePrescription>[];

    final warmup = _exercises[step.warmUpId];
    if (warmup != null) {
      prescriptions.add(ExercisePrescription(
        exercise: warmup,
        sets: 1,
        reps: 15,
        coachingCue: 'Warm up slowly — prepare your joints.',
        isWarmup: true,
      ));
    }

    prescriptions.add(ExercisePrescription(
      exercise: mainExercise,
      sets: step.sets,
      reps: step.reps,
      holdSecs: step.holdSecs,
      coachingCue: step.coachingCue,
    ));

    final cooldown = _exercises[step.coolDownId];
    if (cooldown != null) {
      prescriptions.add(ExercisePrescription(
        exercise: cooldown,
        sets: 1,
        reps: 10,
        holdSecs: step.coolDownId == 'Cat_Stretch' ? 20 : 0,
        coachingCue: 'Cool down — breathe and relax.',
        isCooldown: true,
      ));
    }

    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => WorkoutSessionScreen(
          prescriptions: prescriptions,
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ).then((_) {
      // After returning from workout, mark as complete if it was the active step
      if (mounted && (stepIndex == _completedCount || fromChallenge)) {
        _markComplete(stepIndex);
      }
    });
  }

  void _startChapterWorkout() {
    HapticFeedback.mediumImpact();
    // Gather all exercises in the current chapter
    final activeStep = _completedCount < _pathSteps.length
        ? _pathSteps[_completedCount]
        : _pathSteps.last;
    final chIdx = activeStep.chapterIndex;
    final chapterExercises = _pathSteps
        .where((s) => s.chapterIndex == chIdx && s.hasExercise)
        .map((s) => _exercises[s.id])
        .whereType<RealExercise>()
        .toList();

    if (chapterExercises.isEmpty) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => WorkoutSessionScreen(
          exercises: chapterExercises,
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  // ── Tap Handlers ────────────────────────────────────────────────────────

  void _handleTap(BuildContext context, int index) {
    final step = _pathSteps[index];
    final ns = _nodeState(index);

    if (step.isBoss) {
      _showBossDialog(context, index);
    } else if (step.isMilestone) {
      _showMilestoneDialog(context, step, ns == 0);
    } else if (ns == 0) {
      _showReplayDialog(context, index);
    } else if (ns == 1) {
      _startExercise(index);
    } else if (ns == 2) {
      _showChallengeDialog(context, index);
    } else {
      _showLockedDialog(context, step);
    }
  }

  // ── Dialogs ─────────────────────────────────────────────────────────────

  void _showReplayDialog(BuildContext context, int index) {
    HapticFeedback.lightImpact();
    final step = _pathSteps[index];
    final ex = _exercises[step.id];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _StepSheet(
        step: step,
        exercise: ex,
        badge: 'COMPLETED ✓',
        badgeColor: step.type.color,
        primaryLabel: 'Replay Exercise',
        primaryIcon: Icons.replay_rounded,
        onPrimary: () {
          Navigator.pop(context);
          _startExercise(index);
        },
        secondaryLabel: 'Close',
        onSecondary: () => Navigator.pop(context),
      ),
    );
  }

  void _showChallengeDialog(BuildContext context, int index) {
    HapticFeedback.mediumImpact();
    final step = _pathSteps[index];
    final ex = _exercises[step.id];
    final stepsAhead = index - _completedCount;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _StepSheet(
        step: step,
        exercise: ex,
        badge: stepsAhead == 1 ? '1 STEP AHEAD ⚡' : '2 STEPS AHEAD ⚡',
        badgeColor: const Color(0xFFB55E00),
        primaryLabel: 'Challenge Me! Jump Here',
        primaryIcon: Icons.flash_on_rounded,
        onPrimary: () {
          Navigator.pop(context);
          _challengeJump(index);
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) _startExercise(index, fromChallenge: true);
          });
        },
        secondaryLabel: 'Not yet — keep the order',
        onSecondary: () => Navigator.pop(context),
      ),
    );
  }

  void _showLockedDialog(BuildContext context, _PathStep step) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (_) => _PathDialog(
        icon: Icons.lock_rounded,
        iconColor: AppColors.onSurfaceVariant,
        iconBg: AppColors.surfaceContainerHigh,
        shadowColor: AppColors.outlineVariant,
        title: step.fullName,
        body: 'Complete the exercises ahead to unlock this one. Every step builds on the last.',
        buttonLabel: 'Keep Going! 💪',
        onButton: () => Navigator.pop(context),
      ),
    );
  }

  void _showMilestoneDialog(BuildContext context, _PathStep step, bool done) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (_) => _PathDialog(
        icon: Icons.emoji_events_rounded,
        iconColor: AppColors.onTertiaryFixed,
        iconBg: AppColors.tertiaryContainer,
        shadowColor: AppColors.tertiaryDim,
        title: step.fullName,
        body: step.description,
        buttonLabel: done ? 'Onwards! 🚀' : 'Complete the chapter first',
        onButton: () => Navigator.pop(context),
      ),
    );
  }

  void _showBossDialog(BuildContext context, int index) {
    HapticFeedback.mediumImpact();
    final step = _pathSteps[index];
    final ex = _exercises[step.id];
    final isUnlocked = _nodeState(index) != 3;

    if (isUnlocked && ex != null) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => _StepSheet(
          step: step,
          exercise: ex,
          badge: '🏆 FINAL BOSS',
          badgeColor: const Color(0xFFB8860B),
          primaryLabel: 'DO IT — One-Arm Push-Up!',
          primaryIcon: Icons.emoji_events_rounded,
          onPrimary: () {
            Navigator.pop(context);
            _startExercise(index);
          },
          secondaryLabel: 'Not ready yet',
          onSecondary: () => Navigator.pop(context),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => _PathDialog(
          icon: Icons.emoji_events_rounded,
          iconColor: const Color(0xFFB8860B),
          iconBg: const Color(0xFFFFF8DC),
          shadowColor: const Color(0xFF8B6914),
          title: step.fullName,
          body: 'Complete all chapters to unlock the ultimate challenge. I\'m waiting for you! 🔥',
          buttonLabel: 'I\'m coming for you! 🔥',
          onButton: () => Navigator.pop(context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FitLingoTopBar(),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DotPatternPainter())),
          _LearningPathBody(
            completedCount: _completedCount,
            onChapterWorkout: _startChapterWorkout,
            onNodeTap: (i) => _handleTap(context, i),
            exercises: _exercises,
          ),
        ],
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _LearningPathBody extends StatelessWidget {
  final int completedCount;
  final VoidCallback onChapterWorkout;
  final void Function(int index) onNodeTap;
  final Map<String, RealExercise> exercises;

  const _LearningPathBody({
    required this.completedCount,
    required this.onChapterWorkout,
    required this.onNodeTap,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _JourneyBanner(completedCount: completedCount),
          const SizedBox(height: 16),
          _ChapterHeader(
            completedCount: completedCount,
            onStartWorkout: onChapterWorkout,
          ),
          const SizedBox(height: 32),
          _LearningPath(
            completedCount: completedCount,
            onNodeTap: onNodeTap,
            exercises: exercises,
          ),
        ],
      ),
    );
  }
}

// ── Journey Banner ────────────────────────────────────────────────────────────

class _JourneyBanner extends StatelessWidget {
  final int completedCount;
  const _JourneyBanner({required this.completedCount});

  @override
  Widget build(BuildContext context) {
    final total = _totalSteps;
    final completed = _pathSteps
        .take(completedCount)
        .where((s) => !s.isMilestone && !s.isBoss)
        .length;
    final pct = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant, width: 2),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000), offset: Offset(0, 4), blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.tertiaryDim, width: 2),
              boxShadow: const [
                BoxShadow(
                    color: AppColors.tertiaryDim,
                    offset: Offset(0, 3),
                    blurRadius: 0),
              ],
            ),
            child: const Icon(Icons.emoji_events_rounded,
                color: AppColors.onTertiaryFixed, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ROAD TO ONE-ARM PUSH-UP',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      '$completed / $total',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: -0.05, end: 0);
  }
}

// ── Chapter Header ────────────────────────────────────────────────────────────

class _ChapterHeader extends StatelessWidget {
  final int completedCount;
  final VoidCallback onStartWorkout;

  const _ChapterHeader({
    required this.completedCount,
    required this.onStartWorkout,
  });

  @override
  Widget build(BuildContext context) {
    // Determine current chapter from active step
    final activeIdx = completedCount.clamp(0, _pathSteps.length - 1);
    final activeStep = _pathSteps[activeIdx];
    final chIdx = activeStep.chapterIndex;
    final chapter = _pathChapters[chIdx];

    final chSteps = _pathSteps
        .where((s) => s.chapterIndex == chIdx && !s.isMilestone && !s.isBoss)
        .toList();
    final chStart = _pathSteps.indexWhere((s) => s.chapterIndex == chIdx);
    final doneInChapter = (completedCount - chStart).clamp(0, chSteps.length);
    final totalInChapter = chSteps.length;
    final doneFromStart = doneInChapter.clamp(0, chSteps.length);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primaryDim, width: 4),
        boxShadow: const [
          BoxShadow(
              color: AppColors.primaryDim,
              offset: Offset(0, 8),
              blurRadius: 0),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _DotPatternPainter(
                  color: AppColors.primaryDim.withValues(alpha: 0.12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDim.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'CHAPTER ${chapter.number} OF ${_pathChapters.length}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        chapter.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chapter.subtitle,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Progress dots
                      Row(
                        children: List.generate(totalInChapter, (i) {
                          final isDone = i < doneFromStart;
                          final isActive = i == doneFromStart;
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: isActive ? 22 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isDone || isActive
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$doneFromStart / $totalInChapter exercises complete',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TactileButton(
                        color: AppColors.primaryContainer,
                        shadowColor: AppColors.primaryDim,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        onTap: onStartWorkout,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'START WORKOUT',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryDim,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(Icons.play_arrow_rounded,
                                color: AppColors.primaryDim, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _FloatingMascot(),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.08, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}

class _FloatingMascot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryDim, width: 4),
        boxShadow: const [
          BoxShadow(
              color: AppColors.primaryDim,
              offset: Offset(0, 6),
              blurRadius: 0),
        ],
      ),
      child: const Center(
        child: Icon(Icons.fitness_center_rounded,
            color: AppColors.primaryDim, size: 38),
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .moveY(
            begin: 0,
            end: -8,
            duration: 2000.ms,
            curve: Curves.easeInOut)
        .then()
        .moveY(
            begin: -8,
            end: 0,
            duration: 2000.ms,
            curve: Curves.easeInOut);
  }
}

// ── Learning Path ─────────────────────────────────────────────────────────────

class _LearningPath extends StatelessWidget {
  final int completedCount;
  final void Function(int index) onNodeTap;
  final Map<String, RealExercise> exercises;

  const _LearningPath({
    required this.completedCount,
    required this.onNodeTap,
    required this.exercises,
  });

  static const _stepH = 130.0;
  static const _startY = 60.0;

  List<Offset> _computeCenters(double width) {
    final centers = <Offset>[];
    int side = 0;
    for (int i = 0; i < _pathSteps.length; i++) {
      final step = _pathSteps[i];
      final y = _startY + i * _stepH;
      double x;
      if (step.isMilestone || step.isBoss) {
        x = width / 2;
      } else {
        x = side == 0 ? width - 52 : 52;
        side = 1 - side;
      }
      centers.add(Offset(x, y));
    }
    return centers;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final centers = _computeCenters(w);
        final totalH = _startY + (_pathSteps.length - 1) * _stepH + 140;

        return SizedBox(
          width: w,
          height: totalH,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Winding path
              Positioned.fill(
                child: CustomPaint(
                  painter: _WindingPathPainter(
                    centers: centers,
                    completedCount: completedCount,
                    challengeCount: (completedCount + 2).clamp(0, _pathSteps.length),
                  ),
                ),
              ),
              // Chapter labels
              ..._buildChapterLabels(w, centers),
              // Decorative floating icons
              ..._buildDecorations(centers),
              // Nodes
              ...List.generate(_pathSteps.length, (i) {
                return _buildNodeWidget(context, i, centers[i]);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNodeWidget(BuildContext context, int i, Offset center) {
    final step = _pathSteps[i];
    final ns = _nodeState(i);
    final nodeSize = step.isBoss
        ? 96.0
        : (step.isMilestone || ns == 1) ? 88.0 : 72.0;

    return Positioned(
      left: center.dx - nodeSize / 2,
      top: center.dy - nodeSize / 2,
      child: _PathNode(
        step: step,
        nodeState: ns,
        exercise: step.hasExercise ? exercises[step.id] : null,
        onTap: () => onNodeTap(i),
      )
          .animate(delay: Duration(milliseconds: 60 + i * 35))
          .fadeIn(duration: 300.ms)
          .scale(
            begin: const Offset(0.5, 0.5),
            duration: 380.ms,
            curve: Curves.elasticOut,
          ),
    );
  }

  int _nodeState(int index) {
    if (index < completedCount) return 0;
    if (index == completedCount) return 1;
    if (index <= completedCount + 2) return 2;
    return 3;
  }

  List<Widget> _buildChapterLabels(double w, List<Offset> centers) {
    final widgets = <Widget>[];
    int currentChapter = 0;
    for (int i = 0; i < _pathSteps.length; i++) {
      final step = _pathSteps[i];
      if (step.chapterIndex > currentChapter && !step.isMilestone) {
        currentChapter = step.chapterIndex;
        final chapter = _pathChapters[currentChapter];
        final labelY = centers[i].dy - _stepH * 0.48;
        final isActive = step.chapterIndex <=
            (_pathSteps[completedCount.clamp(0, _pathSteps.length - 1)]
                .chapterIndex);
        widgets.add(
          Positioned(
            top: labelY - 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primaryContainer.withValues(alpha: 0.3)
                      : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primaryContainer
                        : AppColors.outlineVariant,
                    width: 2,
                  ),
                ),
                child: Text(
                  'CHAPTER ${chapter.number} · ${chapter.title.toUpperCase()}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: isActive
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ).animate(delay: Duration(milliseconds: 80 + i * 25)).fadeIn(),
          ),
        );
      }
    }
    return widgets;
  }

  List<Widget> _buildDecorations(List<Offset> centers) {
    if (centers.length < 8) return [];
    final decorations = <(int, IconData, double, double)>[
      (0, Icons.self_improvement_rounded, -0.7, 0.15),
      (2, Icons.shield_rounded, 1.5, 0.18),
      (5, Icons.bolt_rounded, -0.7, 0.16),
      (8, Icons.fitness_center_rounded, 1.4, 0.14),
      (12, Icons.spa_rounded, -0.7, 0.16),
      (16, Icons.local_fire_department_rounded, 1.4, 0.16),
    ];
    return decorations
        .where((d) => d.$1 < centers.length)
        .map((d) {
          final center = centers[d.$1];
          return Positioned(
            left: center.dx + d.$3 * 28,
            top: center.dy - 16,
            child: Icon(d.$2,
                    color: AppColors.secondaryDim.withValues(alpha: d.$4),
                    size: 30)
                .animate(onPlay: (c) => c.repeat())
                .rotate(
                    begin: -0.1,
                    end: 0.1,
                    duration: 3200.ms,
                    curve: Curves.easeInOut)
                .then()
                .rotate(
                    begin: 0.1,
                    end: -0.1,
                    duration: 3200.ms,
                    curve: Curves.easeInOut),
          );
        })
        .toList();
  }
}

// ── Path Node ─────────────────────────────────────────────────────────────────

class _PathNode extends StatelessWidget {
  final _PathStep step;
  final int nodeState; // 0=done, 1=active, 2=challenge, 3=locked
  final RealExercise? exercise;
  final VoidCallback onTap;

  const _PathNode({
    required this.step,
    required this.nodeState,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (step.isBoss) return _buildBossNode();
    if (step.isMilestone) return _buildMilestoneNode();

    switch (nodeState) {
      case 0:
        return _buildCompletedNode();
      case 1:
        return _buildActiveNode();
      case 2:
        return _buildChallengeNode();
      default:
        return _buildLockedNode();
    }
  }

  // ── Node variants ──────────────────────────────────────────────────────

  Widget _buildCompletedNode() {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: step.type.color,
              shape: BoxShape.circle,
              border: Border.all(color: step.type.shadowColor, width: 4),
              boxShadow: [
                BoxShadow(
                    color: step.type.shadowColor,
                    offset: const Offset(0, 6),
                    blurRadius: 0),
              ],
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 34),
          ),
          const SizedBox(height: 8),
          _NodeLabel(
              label: step.label,
              color: AppColors.onSurface,
              small: true),
        ],
      ),
    );
  }

  Widget _buildActiveNode() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryDim, width: 4),
              boxShadow: const [
                BoxShadow(
                    color: AppColors.primaryDim,
                    offset: Offset(0, 8),
                    blurRadius: 0),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(step.type.icon, color: Colors.white.withValues(alpha: 0.3), size: 52),
                const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 44),
              ],
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.05, 1.05),
                  duration: 900.ms,
                  curve: Curves.easeInOut)
              .then()
              .scale(
                  begin: const Offset(1.05, 1.05),
                  end: const Offset(1.0, 1.0),
                  duration: 900.ms,
                  curve: Curves.easeInOut),
        ),
        const SizedBox(height: 8),
        _NodeLabel(
          label: step.label,
          color: AppColors.primary,
          isActive: true,
        ),
      ],
    );
  }

  Widget _buildChallengeNode() {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: 0.72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFFB55E00), width: 3,
                    style: BorderStyle.solid),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x22000000),
                      offset: Offset(0, 4),
                      blurRadius: 0),
                ],
              ),
              child: Icon(step.type.icon,
                  color: const Color(0xFFB55E00), size: 28),
            ),
            const SizedBox(height: 8),
            _NodeLabel(
                label: step.label,
                color: AppColors.onSurfaceVariant,
                small: true,
                isChallenge: true),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedNode() {
    return Opacity(
      opacity: 0.45,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.outlineVariant, width: 4),
                boxShadow: const [
                  BoxShadow(
                      color: AppColors.outlineVariant,
                      offset: Offset(0, 6),
                      blurRadius: 0),
                ],
              ),
              child: const Icon(Icons.lock_rounded,
                  color: AppColors.outlineVariant, size: 30),
            ),
            const SizedBox(height: 8),
            _NodeLabel(
                label: step.label,
                color: AppColors.onSurfaceVariant,
                small: true),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneNode() {
    final isDone = nodeState == 0;
    final bg = isDone ? AppColors.tertiaryContainer : AppColors.secondary;
    final shadow = isDone ? AppColors.tertiaryDim : AppColors.secondaryDim;
    final iconColor = isDone ? AppColors.onTertiaryFixed : Colors.white;
    final icon = isDone ? Icons.emoji_events_rounded : Icons.inventory_2_rounded;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TactileIconButton(
            size: 88,
            color: bg,
            shadowColor: shadow,
            border: Border.all(color: shadow, width: 4),
            borderRadius: BorderRadius.circular(24),
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 34),
                const SizedBox(height: 2),
                Text(
                  step.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: iconColor,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBossNode() {
    const gold = Color(0xFFFFD700);
    const goldDark = Color(0xFFB8860B);
    final isUnlocked = nodeState <= 2;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TactileIconButton(
            size: 96,
            color: isUnlocked ? gold : AppColors.surfaceContainerHigh,
            shadowColor: isUnlocked ? goldDark : AppColors.outlineVariant,
            border: Border.all(
              color: isUnlocked ? goldDark : AppColors.outlineVariant,
              width: 5,
            ),
            borderRadius: BorderRadius.circular(32),
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isUnlocked ? Icons.emoji_events_rounded : Icons.lock_rounded,
                  color: isUnlocked ? Colors.white : AppColors.outlineVariant,
                  size: 38,
                ),
                const SizedBox(height: 2),
                Text(
                  'GOAL',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: isUnlocked ? Colors.white : AppColors.outlineVariant,
                  ),
                ),
              ],
            ),
          )
              .animate(
                  onPlay: (c) => isUnlocked ? c.repeat() : null)
              .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.04, 1.04),
                  duration: 1400.ms,
                  curve: Curves.easeInOut)
              .then()
              .scale(
                  begin: const Offset(1.04, 1.04),
                  end: const Offset(1.0, 1.0),
                  duration: 1400.ms,
                  curve: Curves.easeInOut),
          const SizedBox(height: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? gold.withValues(alpha: 0.2)
                  : AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isUnlocked ? goldDark : AppColors.outlineVariant,
                width: 2,
              ),
            ),
            child: Text(
              'ONE-ARM PUSH-UP',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: isUnlocked ? goldDark : AppColors.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Node Label ────────────────────────────────────────────────────────────────

class _NodeLabel extends StatelessWidget {
  final String label;
  final Color color;
  final bool isActive;
  final bool isChallenge;
  final bool small;

  const _NodeLabel({
    required this.label,
    required this.color,
    this.isActive = false,
    this.isChallenge = false,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isActive
        ? AppColors.primary
        : isChallenge
            ? const Color(0xFFFFF3E0)
            : AppColors.surfaceContainerLowest;
    final border = isActive
        ? AppColors.primaryDim
        : isChallenge
            ? const Color(0xFFB55E00)
            : AppColors.outlineVariant;
    final shadow = isActive
        ? AppColors.primaryDim
        : isChallenge
            ? const Color(0x22B55E00)
            : const Color(0x14000000);
    final textColor = isActive
        ? Colors.white
        : isChallenge
            ? const Color(0xFFB55E00)
            : color;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isActive ? 14 : 10, vertical: isActive ? 7 : 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 2),
        boxShadow: [
          BoxShadow(color: shadow, offset: const Offset(0, 3), blurRadius: 0),
        ],
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(
          fontSize: small ? 10 : 11,
          fontWeight: FontWeight.w900,
          color: textColor,
          height: 1.2,
          letterSpacing: isActive ? 0.8 : 0.3,
        ),
      ),
    );
  }
}

// ── Step Sheet (bottom sheet for exercises) ───────────────────────────────────

class _StepSheet extends StatelessWidget {
  final _PathStep step;
  final RealExercise? exercise;
  final String badge;
  final Color badgeColor;
  final String primaryLabel;
  final IconData primaryIcon;
  final VoidCallback onPrimary;
  final String secondaryLabel;
  final VoidCallback onSecondary;

  const _StepSheet({
    required this.step,
    required this.exercise,
    required this.badge,
    required this.badgeColor,
    required this.primaryLabel,
    required this.primaryIcon,
    required this.onPrimary,
    required this.secondaryLabel,
    required this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, 24 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: badgeColor.withValues(alpha: 0.3), width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(step.type.icon, color: badgeColor, size: 14),
                const SizedBox(width: 6),
                Text(
                  badge,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: badgeColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            step.fullName,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            step.description,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          // Session structure pill row
          if (step.hasExercise) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                _SessionPill(
                  label: 'Warm-up',
                  icon: Icons.self_improvement_rounded,
                  color: const Color(0xFFB55E00),
                ),
                const SizedBox(width: 8),
                _SessionPill(
                  label: step.holdSecs > 0
                      ? '${step.sets}×${step.holdSecs}s'
                      : '${step.sets}×${step.reps}',
                  icon: step.type.icon,
                  color: step.type.color,
                  isPrimary: true,
                ),
                const SizedBox(width: 8),
                _SessionPill(
                  label: 'Cool-down',
                  icon: Icons.spa_rounded,
                  color: AppColors.tertiary,
                ),
              ],
            ),
            if (step.coachingCue.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text('💡', style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        step.coachingCue,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
          // Exercise image preview
          if (exercise != null && exercise!.imageCount > 0) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: step.type.lightColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: step.type.color.withValues(alpha: 0.2), width: 2),
                ),
                child: ExerciseImageWidget(
                  exercise: exercise!,
                  width: double.infinity,
                  height: 160,
                  animate: true,
                  frameMs: 800,
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          // Primary CTA
          TactileButton(
            color: AppColors.primary,
            shadowColor: AppColors.primaryDim,
            onTap: onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(primaryIcon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    primaryLabel,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: onSecondary,
              child: Text(
                secondaryLabel,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Session Pill ──────────────────────────────────────────────────────────────

class _SessionPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isPrimary;

  const _SessionPill({
    required this.label,
    required this.icon,
    required this.color,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isPrimary ? 12 : 10, vertical: isPrimary ? 8 : 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isPrimary ? 0.14 : 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: color.withValues(alpha: isPrimary ? 0.4 : 0.2),
            width: isPrimary ? 2 : 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: isPrimary ? 14 : 12),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: isPrimary ? 13 : 11,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Path Dialog ───────────────────────────────────────────────────────────────

class _PathDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final Color shadowColor;
  final String title;
  final String body;
  final String buttonLabel;
  final VoidCallback onButton;
  const _PathDialog({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.shadowColor,
    required this.title,
    required this.body,
    required this.buttonLabel,
    required this.onButton,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: iconBg, width: 3),
          boxShadow: [
            BoxShadow(
                color: shadowColor.withValues(alpha: 0.4),
                offset: const Offset(0, 8),
                blurRadius: 0),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: shadowColor,
                      offset: const Offset(0, 5),
                      blurRadius: 0),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 34),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            TactileButton(
              color: AppColors.primary,
              shadowColor: AppColors.primaryDim,
              padding: const EdgeInsets.symmetric(vertical: 14),
              onTap: onButton,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  buttonLabel,
                  textAlign: TextAlign.center,
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
      ),
    );
  }
}

// ── Winding Path Painter ──────────────────────────────────────────────────────

class _WindingPathPainter extends CustomPainter {
  final List<Offset> centers;
  final int completedCount;
  final int challengeCount;

  const _WindingPathPainter({
    required this.centers,
    required this.completedCount,
    required this.challengeCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (centers.length < 2) return;

    // Gray base path
    final grayPaint = Paint()
      ..color = AppColors.surfaceContainerHighest
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Green completed path
    final greenPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Orange challenge path (dashed look via segments)
    final challengePaint = Paint()
      ..color = const Color(0xFFB55E00).withValues(alpha: 0.5)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw full gray path
    final fullPath = _buildPath(0, centers.length - 1);
    canvas.drawPath(fullPath, grayPaint);

    // Draw green completed segment
    if (completedCount > 0) {
      final donePath = _buildPath(0, completedCount.clamp(0, centers.length - 1));
      canvas.drawPath(donePath, greenPaint);
    }

    // Draw orange challenge segment (dashed simulation)
    if (challengeCount > completedCount) {
      final challengePath = _buildPath(
          completedCount.clamp(0, centers.length - 1),
          challengeCount.clamp(0, centers.length - 1));
      canvas.drawPath(challengePath, challengePaint);
    }
  }

  Path _buildPath(int fromIdx, int toIdx) {
    final path = Path();
    if (fromIdx >= centers.length || toIdx >= centers.length) return path;
    path.moveTo(centers[fromIdx].dx, centers[fromIdx].dy);
    for (int i = fromIdx + 1; i <= toIdx; i++) {
      final prev = centers[i - 1];
      final curr = centers[i];
      final dy = curr.dy - prev.dy;
      path.cubicTo(
        prev.dx, prev.dy + dy * 0.42,
        curr.dx, curr.dy - dy * 0.42,
        curr.dx, curr.dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(_WindingPathPainter old) =>
      old.completedCount != completedCount ||
      old.challengeCount != challengeCount ||
      old.centers != centers;
}

// ── Dot Pattern Painter ───────────────────────────────────────────────────────

class _DotPatternPainter extends CustomPainter {
  final Color color;
  _DotPatternPainter({this.color = const Color(0x10000000)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const spacing = 28.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
