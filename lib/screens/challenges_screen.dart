import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/fitlingo_store.dart';
import '../theme/app_colors.dart';
import '../widgets/top_bar.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = FitlingoScope.of(context);

    return Scaffold(
      appBar: const FitlingoTopBar(
        title: 'Daily Challenge',
        subtitle: 'Tap to count every rep',
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final challenge = store.challenge;
          final yourProgress = (challenge.yourCount / challenge.target)
              .clamp(0, 1)
              .toDouble();
          final opponentProgress = (challenge.opponentCount / challenge.target)
              .clamp(0, 1)
              .toDouble();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 120),
            children: [
              _DuelCard(
                opponentName: challenge.opponentName,
                daysLeft: challenge.daysLeft,
                target: challenge.target,
                yourCount: challenge.yourCount,
                opponentCount: challenge.opponentCount,
                yourProgress: yourProgress,
                opponentProgress: opponentProgress,
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () async {
                  HapticFeedback.lightImpact();
                  await store.incrementPushup();
                },
                child: Container(
                  height: 210,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
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
                        size: 58,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'TAP TO COUNT +1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Every tap logs a push-up',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              if (store.todayPushups >= store.milestones.last.target)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.accent, width: 2),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.emoji_events_rounded, color: AppColors.accent),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Challenge complete: you reached 20 push-ups.',
                          style: TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _DuelCard extends StatelessWidget {
  const _DuelCard({
    required this.opponentName,
    required this.daysLeft,
    required this.target,
    required this.yourCount,
    required this.opponentCount,
    required this.yourProgress,
    required this.opponentProgress,
  });

  final String opponentName;
  final int daysLeft;
  final int target;
  final int yourCount;
  final int opponentCount;
  final double yourProgress;
  final double opponentProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.whatshot_rounded, color: AppColors.accent),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Push-up Duel',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                '$daysLeft day left',
                style: const TextStyle(color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _ProgressRow(
            label: 'You',
            count: yourCount,
            target: target,
            value: yourProgress,
          ),
          const SizedBox(height: 10),
          _ProgressRow(
            label: opponentName,
            count: opponentCount,
            target: target,
            value: opponentProgress,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.count,
    required this.target,
    required this.value,
    this.color = AppColors.primary,
  });

  final String label;
  final int count;
  final int target;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $count / $target',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 10,
            value: value,
            backgroundColor: AppColors.surfaceSoft,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
