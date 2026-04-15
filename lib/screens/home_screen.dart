import 'package:flutter/material.dart';

import '../data/models.dart';
import '../state/fitlingo_store.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenChallenge});

  final VoidCallback onOpenChallenge;

  @override
  Widget build(BuildContext context) {
    final store = FitlingoScope.of(context);

    return SafeArea(
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
            children: [
              const _Header(),
              const SizedBox(height: 14),
              _DailySummaryCard(store: store),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: onOpenChallenge,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(
                  store.repsRemaining == 0
                      ? 'Challenge complete - keep training'
                      : 'Continue challenge (${store.repsRemaining} left)',
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Today\'s path',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              _PathView(
                milestones: store.milestones,
                currentCount: store.todayPushups,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FitLingo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 2),
              Text(
                'Simple daily push-up progression',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.surface,
          child: Icon(Icons.bolt_rounded, color: AppColors.primary),
        ),
      ],
    );
  }
}

class _DailySummaryCard extends StatelessWidget {
  const _DailySummaryCard({required this.store});

  final FitlingoStore store;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress',
              style: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${store.todayPushups} reps today',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              store.repsRemaining == 0
                  ? 'Daily challenge complete'
                  : 'Next target: ${store.nextMilestoneTarget} reps',
              style: const TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: store.dayProgress,
                minHeight: 10,
                backgroundColor: AppColors.surfaceSoft,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PathView extends StatelessWidget {
  const _PathView({required this.milestones, required this.currentCount});

  final List<PushupMilestone> milestones;
  final int currentCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: milestones.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isComplete = currentCount >= step.target;
        final isCurrent =
            !isComplete &&
            (index == 0 || currentCount >= milestones[index - 1].target);

        return _PathTile(
          step: step,
          alignRight: index.isOdd,
          isComplete: isComplete,
          isCurrent: isCurrent,
          showConnector: index < milestones.length - 1,
        );
      }).toList(),
    );
  }
}

class _PathTile extends StatelessWidget {
  const _PathTile({
    required this.step,
    required this.alignRight,
    required this.isComplete,
    required this.isCurrent,
    required this.showConnector,
  });

  final PushupMilestone step;
  final bool alignRight;
  final bool isComplete;
  final bool isCurrent;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isComplete
        ? AppColors.primary
        : isCurrent
        ? AppColors.accent
        : AppColors.surface;

    final textColor = isComplete || isCurrent ? Colors.white : AppColors.text;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: alignRight
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!alignRight) _StepInfo(step: step),
              const SizedBox(width: 8),
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bubbleColor,
                  border: Border.all(
                    color: isComplete || isCurrent
                        ? Colors.transparent
                        : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Icon(
                  isComplete
                      ? Icons.check_rounded
                      : Icons.fitness_center_rounded,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 8),
              if (alignRight) _StepInfo(step: step),
            ],
          ),
          if (showConnector)
            Padding(
              padding: EdgeInsets.only(
                left: alignRight ? 0 : 180,
                right: alignRight ? 180 : 0,
              ),
              child: Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StepInfo extends StatelessWidget {
  const _StepInfo({required this.step});

  final PushupMilestone step;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${step.target} reps - ${step.title}',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          Text(
            step.subtitle,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
