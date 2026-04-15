import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models.dart';

class BackendService {
  static final Uri _photosEndpoint = Uri.parse(
    'https://jsonplaceholder.typicode.com/photos?_limit=12',
  );
  static final Uri _postsEndpoint = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts',
  );
  static final Uri _commentsEndpoint = Uri.parse(
    'https://jsonplaceholder.typicode.com/comments',
  );

  Future<List<SocialPost>> fetchFeed() async {
    final response = await http.get(_photosEndpoint);
    if (response.statusCode != 200) {
      throw Exception('Unable to load social feed');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded.take(10).map((item) {
      final map = item as Map<String, dynamic>;
      final id = map['id'].toString();
      return SocialPost(
        id: id,
        author: 'Athlete ${(map['albumId'] ?? 0) as int}',
        caption: (map['title'] as String)
            .replaceAll('_', ' ')
            .replaceFirstMapped(
              RegExp(r'^[a-z]'),
              (m) => m.group(0)!.toUpperCase(),
            ),
        imageUrl: map['url'] as String,
        createdAt: DateTime.now().subtract(
          Duration(minutes: int.parse(id) * 3),
        ),
        pushupCount: 5 + (int.parse(id) % 16),
        likeCount: 2 + (int.parse(id) % 19),
        likedByMe: false,
        comments: const [],
      );
    }).toList();
  }

  Future<void> sendChallengeCount({
    required String challengeId,
    required int count,
  }) async {
    await http.post(
      _postsEndpoint,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'challengeId': challengeId,
        'count': count,
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );
  }

  Future<String> createPost({
    required String caption,
    required int pushupCount,
  }) async {
    final response = await http.post(
      _postsEndpoint,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'caption': caption, 'pushupCount': pushupCount}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to create post');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return decoded['id'].toString();
  }

  Future<void> sendLike({required String postId, required bool liked}) async {
    await http.post(
      _postsEndpoint,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'postId': postId, 'liked': liked}),
    );
  }

  Future<void> sendComment({
    required String postId,
    required String message,
  }) async {
    await http.post(
      _commentsEndpoint,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'postId': postId, 'body': message}),
    );
  }
}
