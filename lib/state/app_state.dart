/// Global in-memory app state (persists for the session; use SharedPreferences in production)

// ── Onboarding ────────────────────────────────────────────────────────────────

bool gOnboardingComplete = false;

/// Index into _pathSteps where the user's push-up journey begins.
/// Set by the onboarding assessment screen.
int gPathCompletedCount = 0;

// ── Workout History & Recommendations ────────────────────────────────────────

enum WorkoutCategory { full, upper, core, legs, cardio, recovery }

extension WorkoutCategoryX on WorkoutCategory {
  String get label => switch (this) {
        WorkoutCategory.full     => 'Full Body',
        WorkoutCategory.upper    => 'Upper Body',
        WorkoutCategory.core     => 'Core',
        WorkoutCategory.legs     => 'Legs',
        WorkoutCategory.cardio   => 'Cardio',
        WorkoutCategory.recovery => 'Recovery',
      };
  String get emoji => switch (this) {
        WorkoutCategory.full     => '💪',
        WorkoutCategory.upper    => '🏋️',
        WorkoutCategory.core     => '🔥',
        WorkoutCategory.legs     => '🦵',
        WorkoutCategory.cardio   => '⚡',
        WorkoutCategory.recovery => '🌿',
      };
}

class WorkoutRecord {
  final WorkoutCategory category;
  final DateTime date;
  const WorkoutRecord(this.category, this.date);
}

final List<WorkoutRecord> gWorkoutHistory = [];

void gLogWorkout(WorkoutCategory category) {
  gWorkoutHistory.insert(0, WorkoutRecord(category, DateTime.now()));
  if (gWorkoutHistory.length > 30) gWorkoutHistory.removeLast();
}

/// Smart next-workout recommendation based on training history.
WorkoutCategory gGetRecommendedCategory() {
  if (gWorkoutHistory.isEmpty) return WorkoutCategory.full;
  // Count what's been done in last 5 sessions
  final recent = gWorkoutHistory.take(5).map((r) => r.category).toList();
  final last = recent.first;

  // Avoid repeating the same category twice in a row
  return switch (last) {
    WorkoutCategory.upper    => WorkoutCategory.legs,
    WorkoutCategory.legs     => WorkoutCategory.upper,
    WorkoutCategory.core     => WorkoutCategory.full,
    WorkoutCategory.cardio   => WorkoutCategory.recovery,
    WorkoutCategory.recovery => WorkoutCategory.full,
    WorkoutCategory.full     => WorkoutCategory.core,
  };
}

String gGetRecommendationReason() {
  if (gWorkoutHistory.isEmpty) return 'Perfect starting point for day 1';
  final last = gWorkoutHistory.first.category;
  return switch (last) {
    WorkoutCategory.upper    => 'You trained upper body last — legs will balance it out',
    WorkoutCategory.legs     => 'Legs are recovering — hit upper body today',
    WorkoutCategory.core     => 'Mix it up with a full body session',
    WorkoutCategory.cardio   => 'Your body needs active recovery after cardio',
    WorkoutCategory.recovery => 'Feeling rested? Time for a full session',
    WorkoutCategory.full     => 'Give your full body a rest, focus on core',
  };
}
