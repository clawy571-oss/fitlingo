class PushupMilestone {
  final int target;
  final String title;
  final String subtitle;

  const PushupMilestone({
    required this.target,
    required this.title,
    required this.subtitle,
  });
}

class ChallengeSession {
  final String id;
  final String opponentName;
  final int target;
  final int yourCount;
  final int opponentCount;
  final int daysLeft;

  const ChallengeSession({
    required this.id,
    required this.opponentName,
    required this.target,
    required this.yourCount,
    required this.opponentCount,
    required this.daysLeft,
  });

  ChallengeSession copyWith({
    String? id,
    String? opponentName,
    int? target,
    int? yourCount,
    int? opponentCount,
    int? daysLeft,
  }) {
    return ChallengeSession(
      id: id ?? this.id,
      opponentName: opponentName ?? this.opponentName,
      target: target ?? this.target,
      yourCount: yourCount ?? this.yourCount,
      opponentCount: opponentCount ?? this.opponentCount,
      daysLeft: daysLeft ?? this.daysLeft,
    );
  }
}

class SocialComment {
  final String id;
  final String author;
  final String message;
  final DateTime createdAt;

  const SocialComment({
    required this.id,
    required this.author,
    required this.message,
    required this.createdAt,
  });
}

class SocialPost {
  final String id;
  final String author;
  final String caption;
  final String imageUrl;
  final DateTime createdAt;
  final int pushupCount;
  final int likeCount;
  final bool likedByMe;
  final List<SocialComment> comments;

  const SocialPost({
    required this.id,
    required this.author,
    required this.caption,
    required this.imageUrl,
    required this.createdAt,
    required this.pushupCount,
    required this.likeCount,
    required this.likedByMe,
    required this.comments,
  });

  SocialPost copyWith({
    String? id,
    String? author,
    String? caption,
    String? imageUrl,
    DateTime? createdAt,
    int? pushupCount,
    int? likeCount,
    bool? likedByMe,
    List<SocialComment>? comments,
  }) {
    return SocialPost(
      id: id ?? this.id,
      author: author ?? this.author,
      caption: caption ?? this.caption,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      pushupCount: pushupCount ?? this.pushupCount,
      likeCount: likeCount ?? this.likeCount,
      likedByMe: likedByMe ?? this.likedByMe,
      comments: comments ?? this.comments,
    );
  }
}
