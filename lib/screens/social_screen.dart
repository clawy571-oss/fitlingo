import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../data/models.dart';
import '../state/fitlingo_store.dart';
import '../theme/app_colors.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = FitlingoScope.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
                children: [
                  const Text(
                    'Social feed',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Progress posts with photos, likes, and comments',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 14),
                  if (store.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
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
      ),
    );
  }

  void _openComposer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
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

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.surfaceSoft,
                  child: Text(
                    post.author.substring(0, 1).toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    post.author,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  '${post.pushupCount} reps',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _PostImage(imageUrl: post.imageUrl),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Text(post.caption),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
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
                Text(
                  '${post.comments.length} comments',
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          if (post.comments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: post.comments
                    .map(
                      (comment) => Padding(
                        padding: const EdgeInsets.only(bottom: 3),
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
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment',
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final message = _commentController.text;
                    _commentController.clear();
                    await store.addComment(postId: post.id, message: message);
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
    Widget image;

    if (imageUrl.startsWith('data:')) {
      final bytes = _decodeDataUrl(imageUrl);
      image = bytes == null
          ? const _BrokenImage()
          : Image.memory(bytes, fit: BoxFit.cover, width: double.infinity);
    } else {
      image = Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => const _BrokenImage(),
      );
    }

    return AspectRatio(aspectRatio: 16 / 10, child: image);
  }

  Uint8List? _decodeDataUrl(String dataUrl) {
    try {
      final index = dataUrl.indexOf(',');
      if (index < 0) return null;
      return base64Decode(dataUrl.substring(index + 1));
    } catch (_) {
      return null;
    }
  }
}

class _BrokenImage extends StatelessWidget {
  const _BrokenImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceSoft,
      alignment: Alignment.center,
      child: const Text('Image unavailable'),
    );
  }
}

class _PostComposerSheet extends StatefulWidget {
  const _PostComposerSheet();

  @override
  State<_PostComposerSheet> createState() => _PostComposerSheetState();
}

class _PostComposerSheetState extends State<_PostComposerSheet> {
  final _captionController = TextEditingController();
  final _imageUrlController = TextEditingController(
    text: 'https://picsum.photos/seed/newpost/1000/700',
  );
  Uint8List? _imageBytes;
  String _mimeType = 'image/jpeg';
  bool _posting = false;

  @override
  void dispose() {
    _captionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, inset + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create post',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _captionController,
            minLines: 2,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Share your session'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              hintText: 'Image URL (or upload below)',
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.upload_rounded),
            label: Text(
              _imageBytes == null ? 'Upload image' : 'Image selected',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _posting ? null : _submit,
              child: Text(_posting ? 'Posting...' : 'Post'),
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
    final store = FitlingoScope.of(context);
    final caption = _captionController.text.trim().isEmpty
        ? 'Completed another push-up set.'
        : _captionController.text.trim();

    String imageValue = _imageUrlController.text.trim();
    if (_imageBytes != null) {
      imageValue = 'data:$_mimeType;base64,${base64Encode(_imageBytes!)}';
    }
    if (imageValue.isEmpty) {
      imageValue = 'https://picsum.photos/seed/fallback/1000/700';
    }

    setState(() => _posting = true);

    try {
      await store.addPost(caption: caption, imageUrl: imageValue);
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
