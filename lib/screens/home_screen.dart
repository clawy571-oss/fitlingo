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
      appBar: FitlingoTopBar(
        title: 'Push-Up Path',
        subtitle: '${store.todayPushups} reps today',
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
            children: [
              _SummaryCard(store: store),
              const SizedBox(height: 20),
              const Text(
                'Progress 0 → 5 → 10 → 20',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              ...store.milestones.asMap().entries.map((entry) {
                final i = entry.key;
                final milestone = entry.value;
                final achieved = store.todayPushups >= milestone.target;
                final current =
                    !achieved && store.nextMilestoneTarget == milestone.target;
                final isLast = i == store.milestones.length - 1;

                return _MilestoneTile(
                  milestone: milestone,
                  achieved: achieved,
                  current: current,
                  showConnector: !isLast,
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.store});

  final FitlingoStore store;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s target',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${store.nextMilestoneTarget} push-ups',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 12,
              value: store.challengeProgress,
              backgroundColor: AppColors.surfaceSoft,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  const _MilestoneTile({
    required this.milestone,
    required this.achieved,
    required this.current,
    required this.showConnector,
  });

  final PushupMilestone milestone;
  final bool achieved;
  final bool current;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final dotColor = achieved
        ? AppColors.primary
        : current
        ? AppColors.accent
        : AppColors.border;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
              child: Icon(
                achieved ? Icons.check_rounded : Icons.fitness_center_rounded,
                color: achieved || current ? Colors.white : AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: current ? AppColors.accent : AppColors.border,
                    width: current ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${milestone.target} push-ups · ${milestone.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      milestone.subtitle,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (showConnector)
          Container(
            margin: const EdgeInsets.only(left: 20),
            width: 2,
            height: 20,
            color: AppColors.border,
          ),
      ],
    );
  }
}
