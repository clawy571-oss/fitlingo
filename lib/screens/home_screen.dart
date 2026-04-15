import 'package:flutter/material.dart';

import '../data/models.dart';
import '../state/fitlingo_store.dart';
import '../theme/app_colors.dart';
import '../widgets/top_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = FitlingoScope.of(context);

    return Scaffold(
      appBar: const FitlingoTopBar(
        title: 'Push-Up Path',
        subtitle: 'Simple daily progression',
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
              _TodayCard(store: store),
              const SizedBox(height: 18),
              const _PacingCard(),
              const SizedBox(height: 18),
              const Text(
                '0 → 5 → 10 → 20',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              _PathView(
                milestones: store.milestones,
                todayPushups: store.todayPushups,
                currentTarget: store.nextMilestoneTarget,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.store});

  final FitlingoStore store;

  @override
  Widget build(BuildContext context) {
    final progress = (store.todayPushups / store.milestones.last.target)
        .clamp(0, 1)
        .toDouble();

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
            'Today',
            style: TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${store.todayPushups} reps',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Next checkpoint: ${store.nextMilestoneTarget} push-ups',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.surfaceSoft,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _PacingCard extends StatelessWidget {
  const _PacingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pacing',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 8),
          Text('0 → 5: 2 sets (3 + 2) with clean form'),
          Text('5 → 10: 2 sets of 5 with 30s rest'),
          Text('10 → 20: 4 sets of 5 with 30-45s rest'),
        ],
      ),
    );
  }
}

class _PathView extends StatelessWidget {
  const _PathView({
    required this.milestones,
    required this.todayPushups,
    required this.currentTarget,
  });

  final List<PushupMilestone> milestones;
  final int todayPushups;
  final int currentTarget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: milestones.asMap().entries.map((entry) {
        final i = entry.key;
        final milestone = entry.value;
        final achieved = todayPushups >= milestone.target;
        final current = milestone.target == currentTarget && !achieved;
        final alignRight = i.isOdd;

        return Column(
          children: [
            Align(
              alignment: alignRight
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Row(
                  children: [
                    if (alignRight)
                      SizedBox(
                        width: 102,
                        child: Text(
                          milestone.subtitle,
                          textAlign: TextAlign.end,
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                    Container(
                      width: 58,
                      height: 58,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: achieved
                            ? AppColors.primary
                            : current
                            ? AppColors.accent
                            : AppColors.surfaceSoft,
                        border: Border.all(
                          color: achieved || current
                              ? Colors.transparent
                              : AppColors.border,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        achieved
                            ? Icons.check_rounded
                            : Icons.fitness_center_rounded,
                        color: achieved || current
                            ? Colors.white
                            : AppColors.textMuted,
                      ),
                    ),
                    if (!alignRight)
                      SizedBox(
                        width: 102,
                        child: Text(
                          '${milestone.target} reps\n${milestone.subtitle}',
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                    if (alignRight)
                      SizedBox(
                        width: 102,
                        child: Text(
                          '${milestone.target} reps',
                          style: const TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (i != milestones.length - 1)
              Container(
                margin: EdgeInsets.only(
                  left: alignRight ? 0 : 30,
                  right: alignRight ? 30 : 0,
                ),
                width: 3,
                height: 24,
                color: AppColors.border,
              ),
          ],
        );
      }).toList(),
    );
  }
}
