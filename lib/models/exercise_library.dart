import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ── Exercise Model ────────────────────────────────────────────────────────────

class Exercise {
  final String id;
  final String name;
  final String shortDesc;
  final ExerciseType type;
  final List<String> muscleGroups;
  final List<String> secondaryMuscles;
  final String difficulty;
  final List<ExerciseStep> steps;
  final List<String> tips;
  final String proTip;
  final int defaultReps;
  final int defaultSets;
  final int restSeconds;
  final IconData icon;
  final Color color;
  final String category;

  const Exercise({
    required this.id,
    required this.name,
    required this.shortDesc,
    required this.type,
    required this.muscleGroups,
    this.secondaryMuscles = const [],
    required this.difficulty,
    required this.steps,
    this.tips = const [],
    this.proTip = '',
    required this.defaultReps,
    this.defaultSets = 3,
    this.restSeconds = 60,
    required this.icon,
    required this.color,
    required this.category,
  });
}

class ExerciseStep {
  final String title;
  final String description;
  const ExerciseStep(this.title, this.description);
}

enum ExerciseType {
  pushup,
  squat,
  plank,
  lunge,
  jumpingJack,
  crunch,
  burpee,
  run,
  generic,
}

// ── Exercise Library ──────────────────────────────────────────────────────────

class ExerciseLibrary {
  static const Map<String, Exercise> _all = {
    // ── PUSHUPS ───────────────────────────────────────────────────────────
    'standard_pushup': Exercise(
      id: 'standard_pushup',
      name: 'Standard Pushup',
      shortDesc: 'The foundation of upper-body strength',
      type: ExerciseType.pushup,
      muscleGroups: ['Chest', 'Triceps', 'Shoulders'],
      secondaryMuscles: ['Core', 'Lower Back'],
      difficulty: 'Beginner',
      steps: [
        ExerciseStep('Starting Position',
            'Place your hands slightly wider than shoulder-width apart on the floor. Your fingers should point forward or slightly outward.'),
        ExerciseStep('Align Your Body',
            'Straighten your arms and lift yourself up. Form a straight line from your heels through your hips to your shoulders — no sagging or piking.'),
        ExerciseStep('Engage Your Core',
            'Brace your abdominals as if you\'re about to take a punch. Keep this tension throughout the entire movement.'),
        ExerciseStep('Lower Down',
            'Bend your elbows to lower your chest toward the floor. Keep your elbows at about a 45° angle from your torso — not flared out wide.'),
        ExerciseStep('Touch & Press',
            'Lower until your chest nearly touches the floor (don\'t rest!), then explosively press back up to the starting position.'),
      ],
      tips: [
        'Keep your neck neutral — don\'t crane it up or tuck it down',
        'Exhale as you push up; inhale as you lower',
        'If full pushups are too hard, start from your knees',
      ],
      proTip: 'Squeeze your glutes during the movement. It locks your hips in place and adds surprising upper-body strength.',
      defaultReps: 10,
      defaultSets: 3,
      restSeconds: 60,
      icon: Icons.fitness_center_rounded,
      color: AppColors.primary,
      category: 'Strength',
    ),

    'wide_pushup': Exercise(
      id: 'wide_pushup',
      name: 'Wide-Grip Pushup',
      shortDesc: 'More chest, less triceps',
      type: ExerciseType.pushup,
      muscleGroups: ['Chest', 'Shoulders'],
      secondaryMuscles: ['Triceps', 'Core'],
      difficulty: 'Beginner',
      steps: [
        ExerciseStep('Wide Hand Position',
            'Place your hands 1.5× shoulder-width apart. Your hands should be flat and fingers pointing forward.'),
        ExerciseStep('Body Alignment',
            'Maintain a perfectly straight body line from head to heels. Pull your belly button toward your spine.'),
        ExerciseStep('Controlled Descent',
            'Lower slowly (2-3 seconds) keeping your elbows tracking outward — this is the key difference from a standard pushup.'),
        ExerciseStep('Deep Stretch',
            'Lower until you feel a strong stretch in your chest. Your elbows should form a T-shape at the bottom.'),
        ExerciseStep('Press Back Up',
            'Drive through your palms and press up powerfully, squeezing your chest at the top.'),
      ],
      proTip: 'Pause for 1 second at the bottom to eliminate momentum and maximize chest activation.',
      defaultReps: 8,
      defaultSets: 3,
      restSeconds: 60,
      icon: Icons.fitness_center_rounded,
      color: AppColors.secondary,
      category: 'Strength',
    ),

    'diamond_pushup': Exercise(
      id: 'diamond_pushup',
      name: 'Diamond Pushup',
      shortDesc: 'Tricep isolation powerhouse',
      type: ExerciseType.pushup,
      muscleGroups: ['Triceps', 'Chest'],
      secondaryMuscles: ['Shoulders', 'Core'],
      difficulty: 'Intermediate',
      steps: [
        ExerciseStep('Form the Diamond',
            'Place your hands together under your chest, touching your index fingers and thumbs to form a diamond (or triangle) shape.'),
        ExerciseStep('Elevated Starting Position',
            'Your hands will be directly under your sternum. This is intentional — it shifts load to your triceps.'),
        ExerciseStep('Maintain Alignment',
            'Keep your core tight and body straight. Your hips must not sag — this is even more critical than with standard pushups.'),
        ExerciseStep('Straight-Down Descent',
            'Lower straight down, letting your elbows track backward (not outward). They should graze your sides.'),
        ExerciseStep('Lockout at Top',
            'Press up and fully extend your arms at the top. Squeeze your triceps hard at the lockout for 1 second.'),
      ],
      proTip: 'Can\'t do the full movement? Do them from your knees first. Tricep strength builds quickly.',
      defaultReps: 6,
      defaultSets: 3,
      restSeconds: 90,
      icon: Icons.diamond_rounded,
      color: AppColors.errorContainer,
      category: 'Strength',
    ),

    // ── SQUATS ────────────────────────────────────────────────────────────
    'bodyweight_squat': Exercise(
      id: 'bodyweight_squat',
      name: 'Bodyweight Squat',
      shortDesc: 'Build powerful legs and glutes',
      type: ExerciseType.squat,
      muscleGroups: ['Quads', 'Glutes', 'Hamstrings'],
      secondaryMuscles: ['Core', 'Calves'],
      difficulty: 'Beginner',
      steps: [
        ExerciseStep('Set Your Stance',
            'Stand with feet shoulder-width apart. Point your toes slightly outward (10-15°). Arms relaxed at your sides.'),
        ExerciseStep('Brace & Initiate',
            'Take a deep breath, brace your core, and begin the movement by pushing your hips back (not by bending your knees first).'),
        ExerciseStep('Sit Into It',
            'Lower yourself as if sitting onto a chair that\'s just out of reach. Keep your chest up and proud — no hunching forward.'),
        ExerciseStep('Depth',
            'Aim to get your thighs parallel to the floor or lower. Keep your heels flat on the ground throughout.'),
        ExerciseStep('Drive Up',
            'Push through your entire foot (not just heels) to stand back up. Squeeze your glutes hard at the top.'),
      ],
      tips: [
        'If your heels rise, place a small wedge under them while you build ankle flexibility',
        'Knees should track over your toes — don\'t let them cave inward',
        'Look at a spot 2-3 metres ahead on the floor to keep your spine neutral',
      ],
      proTip: 'Add a 2-second pause at the bottom to build explosive power. It\'s called a "pause squat" and transforms the exercise.',
      defaultReps: 15,
      defaultSets: 3,
      restSeconds: 60,
      icon: Icons.airline_seat_legroom_extra_rounded,
      color: AppColors.primary,
      category: 'Strength',
    ),

    'jump_squat': Exercise(
      id: 'jump_squat',
      name: 'Jump Squat',
      shortDesc: 'Explosive power + cardio in one',
      type: ExerciseType.squat,
      muscleGroups: ['Quads', 'Glutes', 'Calves'],
      secondaryMuscles: ['Core', 'Hip Flexors'],
      difficulty: 'Intermediate',
      steps: [
        ExerciseStep('Squat Down',
            'Lower into a regular squat position — feet shoulder-width, thighs parallel to floor. Arms swing back slightly.'),
        ExerciseStep('Load the Jump',
            'At the bottom of your squat, swing your arms forward and upward while driving through your feet.'),
        ExerciseStep('Explode Up',
            'Launch yourself off the ground as high as you can. Fully extend your hips, knees, and ankles (triple extension).'),
        ExerciseStep('Land Softly',
            'Land toe-to-heel with soft, bent knees. Never land on straight legs — your joints will thank you.'),
        ExerciseStep('Flow Into Next Rep',
            'Use the landing momentum to flow directly into the next squat. Keep the rhythm consistent.'),
      ],
      proTip: 'Swing your arms forcefully — arm drive can add 10-15% to your jump height.',
      defaultReps: 10,
      defaultSets: 3,
      restSeconds: 90,
      icon: Icons.keyboard_double_arrow_up_rounded,
      color: AppColors.errorContainer,
      category: 'HIIT',
    ),

    // ── CORE ──────────────────────────────────────────────────────────────
    'plank': Exercise(
      id: 'plank',
      name: 'Plank Hold',
      shortDesc: 'The core stability king',
      type: ExerciseType.plank,
      muscleGroups: ['Core', 'Abs', 'Lower Back'],
      secondaryMuscles: ['Shoulders', 'Glutes', 'Quads'],
      difficulty: 'Beginner',
      steps: [
        ExerciseStep('Forearm Position',
            'Place your forearms flat on the ground, elbows directly under your shoulders. Clasp your hands or keep palms flat.'),
        ExerciseStep('Lift Into Position',
            'Raise your body off the ground, balancing on forearms and toes. Your body should form a completely straight line.'),
        ExerciseStep('Engage Everything',
            'Contract your abs, squeeze your glutes, push your heels backward, and press your forearms into the ground — simultaneously.'),
        ExerciseStep('Breathe Steadily',
            'Take slow, controlled breaths. Exhale through your mouth to maintain core tension.'),
        ExerciseStep('Hold & Count',
            'Maintain the position for the target time. If your form breaks, rest and try again rather than continuing with bad form.'),
      ],
      tips: [
        'Push the floor away with your forearms — this activates your serratus anterior',
        'Tuck your pelvis slightly — this prevents the common "sagging hip" mistake',
      ],
      proTip: 'An RKC plank (squeeze everything maximally for 10 seconds) is harder than a 60-second regular plank.',
      defaultReps: 30,
      defaultSets: 3,
      restSeconds: 45,
      icon: Icons.horizontal_rule_rounded,
      color: AppColors.secondary,
      category: 'Core',
    ),

    'crunch': Exercise(
      id: 'crunch',
      name: 'Crunch',
      shortDesc: 'Direct ab activation',
      type: ExerciseType.crunch,
      muscleGroups: ['Abs', 'Core'],
      secondaryMuscles: ['Hip Flexors'],
      difficulty: 'Beginner',
      steps: [
        ExerciseStep('Lie Down',
            'Lie on your back with knees bent and feet flat on the floor, hip-width apart.'),
        ExerciseStep('Hand Placement',
            'Place your hands lightly behind your head — elbows wide. Do NOT interlace fingers and pull on your neck.'),
        ExerciseStep('Flatten Your Back',
            'Press your lower back into the floor. This is the key setup step most people skip.'),
        ExerciseStep('Curl Up',
            'Exhale and curl your upper body forward. Lift your shoulder blades off the floor. Your lower back stays down.'),
        ExerciseStep('Control Down',
            'Slowly lower back down on the inhale. Don\'t fully relax at the bottom — keep the tension in your abs.'),
      ],
      proTip: 'The crunch is only about 30° of movement. Focus on shortening the distance between your ribs and pelvis.',
      defaultReps: 15,
      defaultSets: 3,
      restSeconds: 45,
      icon: Icons.sports_gymnastics_rounded,
      color: AppColors.primary,
      category: 'Core',
    ),

    // ── CARDIO ────────────────────────────────────────────────────────────
    'jumping_jack': Exercise(
      id: 'jumping_jack',
      name: 'Jumping Jack',
      shortDesc: 'Full-body cardio classic',
      type: ExerciseType.jumpingJack,
      muscleGroups: ['Calves', 'Shoulders', 'Glutes'],
      secondaryMuscles: ['Core', 'Hip Abductors'],
      difficulty: 'Beginner',
      steps: [
        ExerciseStep('Starting Position',
            'Stand upright with feet together and arms at your sides.'),
        ExerciseStep('Jump Out',
            'Jump and simultaneously spread your feet to shoulder-width while raising your arms overhead — meeting above your head.'),
        ExerciseStep('Clap or Touch',
            'At the top, clap your hands or touch them above your head. Full arm extension.'),
        ExerciseStep('Jump Back',
            'Jump back to starting position, bringing feet together and arms back down to sides.'),
        ExerciseStep('Maintain Rhythm',
            'Find a steady, bouncy rhythm. Land softly on the balls of your feet to protect your joints.'),
      ],
      proTip: 'To increase intensity, slow down your tempo by 50% and fully extend everything at each position. Quality > speed.',
      defaultReps: 20,
      defaultSets: 3,
      restSeconds: 30,
      icon: Icons.directions_run_rounded,
      color: AppColors.tertiaryContainer,
      category: 'Cardio',
    ),

    'burpee': Exercise(
      id: 'burpee',
      name: 'Burpee',
      shortDesc: 'The ultimate full-body conditioner',
      type: ExerciseType.burpee,
      muscleGroups: ['Full Body', 'Chest', 'Legs'],
      secondaryMuscles: ['Core', 'Shoulders', 'Cardio System'],
      difficulty: 'Intermediate',
      steps: [
        ExerciseStep('Stand Tall',
            'Start standing with feet shoulder-width apart, arms at sides.'),
        ExerciseStep('Squat Down',
            'Drop into a deep squat and place your hands on the floor just inside your feet.'),
        ExerciseStep('Jump Back',
            'Kick or jump both feet back simultaneously into a pushup (plank) position. Hips level, body straight.'),
        ExerciseStep('Pushup',
            'Perform a pushup — chest to floor, then press up. (Beginners can skip this step at first.)'),
        ExerciseStep('Jump Forward & Up',
            'Jump your feet forward to your hands, then explode upward, reaching your arms overhead. That\'s one rep.'),
      ],
      tips: [
        'Go at YOUR pace — a clean slow burpee beats a sloppy fast one',
        'The hardest part is the 3rd and 4th rep. Push through.',
      ],
      proTip: 'Add a tuck jump at the top to make it a "jump burpee" — this dramatically raises your heart rate.',
      defaultReps: 8,
      defaultSets: 3,
      restSeconds: 120,
      icon: Icons.bolt_rounded,
      color: AppColors.errorContainer,
      category: 'HIIT',
    ),

    // ── LEGS ─────────────────────────────────────────────────────────────
    'lunge': Exercise(
      id: 'lunge',
      name: 'Forward Lunge',
      shortDesc: 'Single-leg strength and balance',
      type: ExerciseType.lunge,
      muscleGroups: ['Quads', 'Glutes', 'Hamstrings'],
      secondaryMuscles: ['Core', 'Balance'],
      difficulty: 'Beginner',
      steps: [
        ExerciseStep('Stand Tall',
            'Stand with feet hip-width apart. Hands on hips or clasped in front of chest.'),
        ExerciseStep('Step Forward',
            'Take a large step forward with your right foot. Land heel-first.'),
        ExerciseStep('Lower Down',
            'Lower your back knee toward the floor. Stop 2-3 cm before it touches. Front shin should be near-vertical.'),
        ExerciseStep('Check Your Knee',
            'Front knee should be directly above your ankle — not pushed past your toes. This protects the joint.'),
        ExerciseStep('Push Back',
            'Drive through your front heel to return to standing. Bring your feet together. Switch legs.'),
      ],
      proTip: 'Keep your torso perfectly upright. The moment you lean forward, the glutes disengage and your quads do all the work.',
      defaultReps: 12,
      defaultSets: 3,
      restSeconds: 60,
      icon: Icons.directions_walk_rounded,
      color: AppColors.primary,
      category: 'Strength',
    ),
  };

  static Exercise? get(String id) => _all[id];

  static List<Exercise> get all => _all.values.toList();

  static List<Exercise> byCategory(String category) =>
      _all.values.where((e) => e.category == category).toList();

  static List<Exercise> get beginnerFriendly =>
      _all.values.where((e) => e.difficulty == 'Beginner').toList();
}

// ── Workout Plan ──────────────────────────────────────────────────────────────

class WorkoutPlan {
  final String id;
  final String name;
  final String description;
  final List<String> exerciseIds;
  final int totalMinutes;
  final String difficulty;
  final String category;
  final Color color;

  const WorkoutPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.exerciseIds,
    required this.totalMinutes,
    required this.difficulty,
    required this.category,
    required this.color,
  });

  List<Exercise> get exercises =>
      exerciseIds.map((id) => ExerciseLibrary.get(id)!).toList();
}

class WorkoutLibrary {
  static const List<WorkoutPlan> plans = [
    WorkoutPlan(
      id: 'pushup_paradise',
      name: 'Pushup Paradise',
      description: 'Build chest and tricep strength from zero.',
      exerciseIds: ['standard_pushup', 'wide_pushup', 'diamond_pushup'],
      totalMinutes: 15,
      difficulty: 'Beginner',
      category: 'Strength',
      color: AppColors.primary,
    ),
    WorkoutPlan(
      id: 'leg_day_basics',
      name: 'Leg Day Basics',
      description: 'Powerful legs with zero equipment.',
      exerciseIds: ['bodyweight_squat', 'jump_squat', 'lunge'],
      totalMinutes: 18,
      difficulty: 'Beginner',
      category: 'Strength',
      color: AppColors.secondary,
    ),
    WorkoutPlan(
      id: 'core_blast',
      name: 'Core Blast',
      description: 'Build a rock-solid midsection.',
      exerciseIds: ['plank', 'crunch'],
      totalMinutes: 12,
      difficulty: 'Beginner',
      category: 'Core',
      color: AppColors.secondary,
    ),
    WorkoutPlan(
      id: 'hiit_starter',
      name: 'HIIT Starter',
      description: 'Burn calories fast with full-body intervals.',
      exerciseIds: ['jumping_jack', 'burpee', 'jump_squat'],
      totalMinutes: 20,
      difficulty: 'Intermediate',
      category: 'HIIT',
      color: AppColors.errorContainer,
    ),
  ];

  static WorkoutPlan? get(String id) =>
      plans.firstWhere((p) => p.id == id, orElse: () => plans.first);
}
