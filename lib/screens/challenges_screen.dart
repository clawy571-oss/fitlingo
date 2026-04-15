import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/fitlingo_store.dart';
import '../theme/app_colors.dart';
import '../widgets/top_bar.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  static const _checkpoints = [0, 5, 10, 20];

  @override
  Widget build(BuildContext context) {
    final store = FitlingoScope.of(context);

    return Scaffold(
      appBar: const FitlingoTopBar(
        title: 'Daily Challenge',
        subtitle: 'Tap once per completed push-up',
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final challenge = store.challenge;
          final progress = (challenge.yourCount / challenge.target)
              .clamp(0, 1)
              .toDouble();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
              _StatusCard(
                yourCount: challenge.yourCount,
                target: challenge.target,
                opponentName: challenge.opponentName,
                opponentCount: challenge.opponentCount,
                progress: progress,
              ),
              const SizedBox(height: 14),
              _CheckpointRow(count: challenge.yourCount),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  HapticFeedback.lightImpact();
                  await store.incrementPushup();
                },
                child: Container(
                  height: 220,
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
                        size: 58,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'TAP TO COUNT +1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Keep pace: short sets, clean reps',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (challenge.yourCount >= challenge.target)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accent, width: 2),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.emoji_events_rounded, color: AppColors.accent),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Challenge complete. 20 push-ups reached.',
                          style: TextStyle(fontWeight: FontWeight.w800),
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

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.yourCount,
    required this.target,
    required this.opponentName,
    required this.opponentCount,
    required this.progress,
  });

  final int yourCount;
  final int target;
  final String opponentName;
  final int opponentCount;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Count',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$yourCount / $target reps',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              backgroundColor: AppColors.surfaceSoft,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.person_rounded,
                size: 18,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text('You: $yourCount'),
              const SizedBox(width: 16),
              const Icon(
                Icons.flag_rounded,
                size: 18,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text('$opponentName: $opponentCount'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CheckpointRow extends StatelessWidget {
  const _CheckpointRow({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ChallengesScreen._checkpoints.map((cp) {
        final reached = count >= cp;
        final active = !reached && cp > 0 && count < cp;

        return Container(
          width: 72,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: reached
                ? AppColors.primary
                : active
                ? AppColors.accent
                : AppColors.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            '$cp',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: reached || active ? Colors.white : AppColors.textMuted,
            ),
          ),
        );
      }).toList(),
    );
  }
}
