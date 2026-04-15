import 'package:flutter/material.dart';

import '../data/backend_service.dart';
import '../data/models.dart';

class FitlingoStore extends ChangeNotifier {
  FitlingoStore(this._backend);

  final BackendService _backend;

  final milestones = const [
    PushupMilestone(
      target: 0,
      title: 'Start',
      subtitle: 'Open your stance and lock form',
    ),
    PushupMilestone(
      target: 5,
      title: 'Warm Up',
      subtitle: 'Hit five clean reps',
    ),
    PushupMilestone(
      target: 10,
      title: 'Momentum',
      subtitle: 'Double down to ten',
    ),
    PushupMilestone(
      target: 20,
      title: 'Win',
      subtitle: 'Finish the full challenge',
    ),
  ];

  bool loadingFeed = true;
  String? error;
  int todayPushups = 0;
  ChallengeSession challenge = const ChallengeSession(
    id: 'daily-pushup-duel',
    opponentName: 'Mia',
    target: 20,
    yourCount: 0,
    opponentCount: 8,
    daysLeft: 1,
  );
  List<SocialPost> feed = const [];

  int get nextMilestoneTarget {
    for (final milestone in milestones) {
      if (todayPushups < milestone.target) {
        return milestone.target;
      }
    }
    return milestones.last.target;
  }

  double get challengeProgress {
    if (challenge.target == 0) return 0;
    return (challenge.yourCount / challenge.target).clamp(0, 1);
  }

  int get reachedMilestones =>
      milestones.where((m) => todayPushups >= m.target).length;

  Future<void> initialize() async {
    if (!loadingFeed) return;
    await refreshFeed();
  }

  Future<void> refreshFeed() async {
    loadingFeed = true;
    error = null;
    notifyListeners();

    try {
      feed = await _backend.fetchFeed();
    } catch (_) {
      error = 'Could not load feed. Pull to retry.';
      if (feed.isEmpty) {
        feed = const [];
      }
    } finally {
      loadingFeed = false;
      notifyListeners();
    }
  }

  Future<void> incrementPushup() async {
    todayPushups += 1;
    challenge = challenge.copyWith(yourCount: challenge.yourCount + 1);
    notifyListeners();

    try {
      await _backend.sendChallengeCount(
        challengeId: challenge.id,
        count: challenge.yourCount,
      );
    } catch (_) {
      // UI is optimistic and keeps local progress.
    }
  }

  Future<void> addPost({
    required String caption,
    required String imageUrl,
  }) async {
    final id = await _backend.createPost(
      caption: caption,
      pushupCount: todayPushups,
    );

    final post = SocialPost(
      id: '${id}_${DateTime.now().millisecondsSinceEpoch}',
      author: 'You',
      caption: caption,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      pushupCount: todayPushups,
      likeCount: 0,
      likedByMe: false,
      comments: const [],
    );

    feed = [post, ...feed];
    notifyListeners();
  }

  Future<void> toggleLike(String postId) async {
    final index = feed.indexWhere((post) => post.id == postId);
    if (index < 0) return;

    final post = feed[index];
    final updated = post.copyWith(
      likedByMe: !post.likedByMe,
      likeCount: post.likedByMe ? post.likeCount - 1 : post.likeCount + 1,
    );

    final nextFeed = [...feed]..[index] = updated;
    feed = nextFeed;
    notifyListeners();

    try {
      await _backend.sendLike(postId: postId, liked: updated.likedByMe);
    } catch (_) {
      // Keep optimistic state.
    }
  }

  Future<void> addComment({
    required String postId,
    required String message,
  }) async {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;

    final index = feed.indexWhere((post) => post.id == postId);
    if (index < 0) return;

    final post = feed[index];
    final comment = SocialComment(
      id: 'c_${DateTime.now().microsecondsSinceEpoch}',
      author: 'You',
      message: trimmed,
      createdAt: DateTime.now(),
    );

    final updated = post.copyWith(comments: [...post.comments, comment]);
    final nextFeed = [...feed]..[index] = updated;
    feed = nextFeed;
    notifyListeners();

    try {
      await _backend.sendComment(postId: postId, message: trimmed);
    } catch (_) {
      // Keep optimistic comment.
    }
  }
}

class FitlingoScope extends InheritedNotifier<FitlingoStore> {
  const FitlingoScope({
    super.key,
    required FitlingoStore store,
    required super.child,
  }) : super(notifier: store);

  static FitlingoStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FitlingoScope>();
    if (scope == null || scope.notifier == null) {
      throw StateError('FitlingoScope is missing in widget tree.');
    }
    return scope.notifier!;
  }
}
