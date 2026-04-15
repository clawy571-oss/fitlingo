import 'package:flutter/material.dart';

import '../state/fitlingo_store.dart';
import '../theme/app_colors.dart';
import '../widgets/top_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = FitlingoScope.of(context);

    return Scaffold(
      appBar: const FitlingoTopBar(
        title: 'Profile',
        subtitle: 'Your progress summary',
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
            children: [
              _StatCard(
                title: 'Today\'s push-ups',
                value: '${store.todayPushups}',
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: 'Milestones reached',
                value:
                    '${store.reachedMilestones} / ${store.milestones.length}',
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: 'Posts shared',
                value:
                    '${store.feed.where((post) => post.author == 'You').length}',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
