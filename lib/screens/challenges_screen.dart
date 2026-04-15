import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/fitlingo_store.dart';
import '../theme/app_colors.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = FitlingoScope.of(context);

    return SafeArea(
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final challenge = store.challenge;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
            children: [
              const Text(
                'Daily challenge',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tap once for each completed push-up',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${store.todayPushups} / ${challenge.target} reps',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        store.repsRemaining == 0
                            ? 'Goal reached. Keep going for bonus reps.'
                            : '${store.repsRemaining} reps remaining',
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          minHeight: 10,
                          value: store.dayProgress,
                          backgroundColor: AppColors.surfaceSoft,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Race: You ${challenge.yourCount} - ${challenge.opponentName} ${challenge.opponentCount}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  HapticFeedback.selectionClick();
                  await store.incrementPushup();
                },
                child: Container(
                  height: 230,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.primaryDark,
                        offset: Offset(0, 8),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        color: Colors.white,
                        size: 64,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'TAP FOR +1 REP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: store.todayPushups > 0
                          ? () => store.decrementPushup()
                          : null,
                      icon: const Icon(Icons.remove_rounded),
                      label: const Text('Undo'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: store.todayPushups > 0
                          ? () => store.resetPushups()
                          : null,
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: const Text('Reset'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
