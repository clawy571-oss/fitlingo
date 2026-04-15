import 'package:flutter/material.dart';

import '../state/fitlingo_store.dart';
import '../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = FitlingoScope.of(context);

    return SafeArea(
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final myPosts = store.feed
              .where((post) => post.author == 'You')
              .length;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.surface,
                    child: Icon(Icons.person_rounded, size: 34),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        'Daily consistency tracker',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _StatCard(
                title: 'Today\'s push-ups',
                value: '${store.todayPushups}',
              ),
              const SizedBox(height: 10),
              _StatCard(
                title: 'Path milestones reached',
                value:
                    '${store.reachedMilestones} / ${store.milestones.length}',
              ),
              const SizedBox(height: 10),
              _StatCard(title: 'Posts shared', value: '$myPosts'),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
