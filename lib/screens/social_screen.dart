import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../data/models.dart';
import '../state/fitlingo_store.dart';
import '../theme/app_colors.dart';
import '../widgets/top_bar.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = FitlingoScope.of(context);

    return Scaffold(
      appBar: const FitlingoTopBar(
        title: 'Social Feed',
        subtitle: 'Posts, likes, and comments',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openComposer(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_a_photo_rounded),
        label: const Text('Post'),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          if (store.loadingFeed && store.feed.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: store.refreshFeed,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: [
                if (store.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      store.error!,
                      style: const TextStyle(color: AppColors.danger),
                    ),
                  ),
                ...store.feed.map(
                  (post) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PostCard(post: post),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openComposer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) => const _PostComposerSheet(),
    );
  }
}

class _PostCard extends StatefulWidget {
  const _PostCard({required this.post});

  final SocialPost post;

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = FitlingoScope.of(context);
    final post = widget.post;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.surfaceSoft,
                  child: Text(
                    post.author.characters.first.toUpperCase(),
                    style: const TextStyle(color: AppColors.text),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    post.author,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  '${post.pushupCount} reps',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
            child: _PostImage(imageUrl: post.imageUrl),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Text(post.caption),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () => store.toggleLike(post.id),
                  icon: Icon(
                    post.likedByMe
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: post.likedByMe
                        ? AppColors.danger
                        : AppColors.textMuted,
                  ),
                  label: Text('${post.likeCount}'),
                ),
                const SizedBox(width: 8),
                Text(
                  '${post.comments.length} comments',
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          if (post.comments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 2, 14, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: post.comments
                    .map(
                      (comment) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${comment.author}: ${comment.message}',
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Write a comment',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final text = _commentController.text;
                    _commentController.clear();
                    await store.addComment(postId: post.id, message: text);
                  },
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('data:')) {
      final bytes = _decodeDataUrl(imageUrl);
      if (bytes != null) {
        return Image.memory(
          bytes,
          height: 210,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
    }

    return Image.network(
      imageUrl,
      height: 210,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        height: 210,
        color: AppColors.surfaceSoft,
        alignment: Alignment.center,
        child: const Text('Image failed to load'),
      ),
    );
  }

  Uint8List? _decodeDataUrl(String dataUrl) {
    try {
      final index = dataUrl.indexOf(',');
      if (index < 0) return null;
      final raw = dataUrl.substring(index + 1);
      return base64Decode(raw);
    } catch (_) {
      return null;
    }
  }
}

class _PostComposerSheet extends StatefulWidget {
  const _PostComposerSheet();

  @override
  State<_PostComposerSheet> createState() => _PostComposerSheetState();
}

class _PostComposerSheetState extends State<_PostComposerSheet> {
  final _captionController = TextEditingController();
  Uint8List? _imageBytes;
  String _mimeType = 'image/jpeg';
  bool _posting = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 18, 16, bottomInset + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Post',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: _imageBytes == null
                  ? const Center(child: Text('Tap to upload photo'))
                  : Image.memory(_imageBytes!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _captionController,
            minLines: 2,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'What did you train today?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _posting ? null : _submit,
              child: Text(_posting ? 'Posting...' : 'Post to feed'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    if (file.bytes == null) return;

    final ext = (file.extension ?? '').toLowerCase();
    final mime = switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };

    setState(() {
      _imageBytes = file.bytes;
      _mimeType = mime;
    });
  }

  Future<void> _submit() async {
    if (_imageBytes == null) return;

    setState(() => _posting = true);
    final store = FitlingoScope.of(context);
    final caption = _captionController.text.trim().isEmpty
        ? 'Completed another push-up set.'
        : _captionController.text.trim();

    final dataUrl = 'data:$_mimeType;base64,${base64Encode(_imageBytes!)}';

    try {
      await store.addPost(caption: caption, imageUrl: dataUrl);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() => _posting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to post right now')));
    }
  }
}
