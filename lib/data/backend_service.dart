import 'dart:async';

import 'models.dart';

class BackendService {
  BackendService() : _posts = _seedPosts();

  final List<SocialPost> _posts;
  int _nextId = 1000;

  Future<List<SocialPost>> fetchFeed() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _posts
        .map((post) => post.copyWith(comments: [...post.comments]))
        .toList();
  }

  Future<void> sendChallengeCount({
    required String challengeId,
    required int count,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
  }

  Future<String> createPost({
    required String caption,
    required int pushupCount,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _nextId += 1;
    return _nextId.toString();
  }

  Future<void> sendLike({required String postId, required bool liked}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
  }

  Future<void> sendComment({
    required String postId,
    required String message,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
  }

  static List<SocialPost> _seedPosts() {
    final now = DateTime.now();

    return [
      SocialPost(
        id: '101',
        author: 'Nina',
        caption: 'Finished my 10 rep checkpoint before class.',
        imageUrl: 'https://picsum.photos/seed/fitlingo-a/1000/700',
        createdAt: now.subtract(const Duration(minutes: 12)),
        pushupCount: 10,
        likeCount: 21,
        likedByMe: false,
        comments: [
          SocialComment(
            id: 'c1',
            author: 'Leo',
            message: 'Solid pace. Keep it going.',
            createdAt: now.subtract(const Duration(minutes: 8)),
          ),
        ],
      ),
      SocialPost(
        id: '102',
        author: 'Mia',
        caption: '20 reps complete. Broke it into four clean sets.',
        imageUrl: 'https://picsum.photos/seed/fitlingo-b/1000/700',
        createdAt: now.subtract(const Duration(minutes: 34)),
        pushupCount: 20,
        likeCount: 31,
        likedByMe: true,
        comments: [
          SocialComment(
            id: 'c2',
            author: 'Arjun',
            message: 'That consistency is elite.',
            createdAt: now.subtract(const Duration(minutes: 28)),
          ),
          SocialComment(
            id: 'c3',
            author: 'Sara',
            message: 'I am copying your pacing plan tomorrow.',
            createdAt: now.subtract(const Duration(minutes: 25)),
          ),
        ],
      ),
      SocialPost(
        id: '103',
        author: 'Theo',
        caption: 'Early morning set done. 5 reps before breakfast.',
        imageUrl: 'https://picsum.photos/seed/fitlingo-c/1000/700',
        createdAt: now.subtract(const Duration(hours: 2)),
        pushupCount: 5,
        likeCount: 9,
        likedByMe: false,
        comments: const [],
      ),
    ];
  }
}
