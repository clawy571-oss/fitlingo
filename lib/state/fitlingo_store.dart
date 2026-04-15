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
      subtitle: 'Open app and set posture',
    ),
    PushupMilestone(target: 5, title: 'Warmup', subtitle: 'First clean set'),
    PushupMilestone(
      target: 10,
      title: 'Steady',
      subtitle: 'Two full sets complete',
    ),
    PushupMilestone(
      target: 15,
      title: 'Focus',
      subtitle: 'Hold form under fatigue',
    ),
    PushupMilestone(
      target: 20,
      title: 'Strong',
      subtitle: 'Daily goal unlocked',
    ),
    PushupMilestone(
      target: 30,
      title: 'Elite',
      subtitle: 'Bonus reps for streaks',
    ),
  ];

  bool loadingFeed = true;
  String? error;
  int todayPushups = 0;
  ChallengeSession challenge = const ChallengeSession(
    id: 'daily-pushup-challenge',
    opponentName: 'Alex',
    target: 20,
    yourCount: 0,
    opponentCount: 8,
    daysLeft: 1,
  );
  List<SocialPost> feed = const [];

  int get reachedMilestones =>
      milestones.where((m) => todayPushups >= m.target).length;

  int get currentStepIndex {
    for (var i = 0; i < milestones.length; i++) {
      if (todayPushups < milestones[i].target) {
        return i;
      }
    }
    return milestones.length - 1;
  }

  int get nextMilestoneTarget => milestones[currentStepIndex].target;

  int get repsRemaining =>
      (challenge.target - todayPushups).clamp(0, challenge.target);

  double get dayProgress {
    if (challenge.target == 0) return 0;
    return (todayPushups / challenge.target).clamp(0, 1);
  }

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
    final next = todayPushups + 1;
    await _setPushupCount(next);
  }

  Future<void> decrementPushup() async {
    if (todayPushups == 0) return;
    final next = todayPushups - 1;
    await _setPushupCount(next);
  }

  Future<void> resetPushups() async {
    await _setPushupCount(0);
  }

  Future<void> _setPushupCount(int count) async {
    todayPushups = count.clamp(0, milestones.last.target * 3);
    final simulatedOpponent =
        (challenge.opponentCount + (todayPushups / 3).floor()).clamp(
          0,
          challenge.target + 6,
        );

    challenge = challenge.copyWith(
      yourCount: todayPushups,
      opponentCount: simulatedOpponent,
    );
    notifyListeners();

    try {
      await _backend.sendChallengeCount(
        challengeId: challenge.id,
        count: challenge.yourCount,
      );
    } catch (_) {
      // Keep optimistic state.
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
