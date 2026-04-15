import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/real_exercise.dart';
import '../theme/app_colors.dart';

/// Animated exercise image widget.
///
/// Shows a rich colored placeholder IMMEDIATELY (never a raw spinner).
/// Loads and cross-fades the real image in the background, then animates
/// between frame 0 and frame 1 once both are cached in memory.
class ExerciseImageWidget extends StatefulWidget {
  final RealExercise exercise;
  final double width;
  final double height;
  final bool animate;
  final int frameMs;

  const ExerciseImageWidget({
    super.key,
    required this.exercise,
    this.width = 260,
    this.height = 260,
    this.animate = true,
    this.frameMs = 900,
  });

  @override
  State<ExerciseImageWidget> createState() => _ExerciseImageWidgetState();
}

class _ExerciseImageWidgetState extends State<ExerciseImageWidget>
    with TickerProviderStateMixin {
  // Loaded image data
  ui.Image? _img0;
  ui.Image? _img1;
  int _frame = 0;

  Timer? _animTimer;
  late AnimationController _fadeCtrl;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _loadImages();
  }

  @override
  void didUpdateWidget(ExerciseImageWidget old) {
    super.didUpdateWidget(old);
    if (old.exercise.id != widget.exercise.id) {
      _animTimer?.cancel();
      _animTimer = null;
      _img0 = null;
      _img1 = null;
      _frame = 0;
      _fadeCtrl.reset();
      _loadImages();
    }
  }

  Future<void> _loadImages() async {
    if (widget.exercise.imageCount == 0) return;

    final url0 = widget.exercise.imageUrl(0);
    if (url0.isEmpty) return;

    // Load frame 0 first — show it ASAP
    final img0 = await _fetchImage(url0);
    if (_disposed || !mounted) return;
    setState(() => _img0 = img0);
    _fadeCtrl.forward();

    // Then load frame 1 in the background
    if (widget.exercise.hasTwoImages) {
      final img1 = await _fetchImage(widget.exercise.imageUrl(1));
      if (_disposed || !mounted) return;
      setState(() => _img1 = img1);
      if (widget.animate) _startAnimation();
    }
  }

  static Future<ui.Image?> _fetchImage(String url) async {
    try {
      final completer = Completer<ui.Image?>();
      final networkImage = NetworkImage(url);
      final stream = networkImage.resolve(ImageConfiguration.empty);
      late ImageStreamListener listener;
      listener = ImageStreamListener(
        (info, _) {
          if (!completer.isCompleted) completer.complete(info.image);
        },
        onError: (_, __) {
          if (!completer.isCompleted) completer.complete(null);
        },
      );
      stream.addListener(listener);
      // Timeout after 15 seconds
      final result = await completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () => null,
      );
      stream.removeListener(listener);
      return result;
    } catch (_) {
      return null;
    }
  }

  void _startAnimation() {
    _animTimer?.cancel();
    _animTimer = Timer.periodic(Duration(milliseconds: widget.frameMs), (_) {
      if (mounted) setState(() => _frame = _frame == 0 ? 1 : 0);
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _animTimer?.cancel();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Always-visible colored placeholder — shows instantly
            _buildPlaceholder(),
            // Real image fades in on top once loaded
            if (_img0 != null)
              FadeTransition(
                opacity: _fadeCtrl,
                child: _buildCurrentFrame(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentFrame() {
    final img = (_frame == 1 && _img1 != null) ? _img1! : (_img0 ?? _img1!);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 380),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: RawImage(
        key: ValueKey('${widget.exercise.id}_$_frame'),
        image: img,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildPlaceholder() {
    final color = _categoryColor(widget.exercise.category);
    final muscles = widget.exercise.primaryMuscles.take(2).join(' · ');

    return Container(
      color: color.withValues(alpha: 0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
            ),
            child: Icon(
              _categoryIcon(widget.exercise.category),
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              widget.exercise.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color.withValues(alpha: 0.8),
                height: 1.3,
              ),
            ),
          ),
          if (muscles.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              muscles,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: color.withValues(alpha: 0.5),
              ),
            ),
          ],
          // Small loading indicator only shown before ANY image arrives
          if (_img0 == null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color.withValues(alpha: 0.4),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Color _categoryColor(String cat) {
    return switch (cat.toLowerCase()) {
      'strength' => AppColors.primary,
      'cardio' => const Color(0xFFb02500),
      'stretching' => const Color(0xFF00628c),
      'plyometrics' => const Color(0xFF725800),
      'powerlifting' => const Color(0xFF4a0072),
      'olympic weightlifting' => const Color(0xFF1a5276),
      'strongman' => const Color(0xFF784212),
      _ => AppColors.outlineVariant,
    };
  }

  static IconData _categoryIcon(String cat) {
    return switch (cat.toLowerCase()) {
      'strength' => Icons.fitness_center_rounded,
      'cardio' => Icons.directions_run_rounded,
      'stretching' => Icons.self_improvement_rounded,
      'plyometrics' => Icons.bolt_rounded,
      'powerlifting' => Icons.sports_gymnastics_rounded,
      'olympic weightlifting' => Icons.military_tech_rounded,
      'strongman' => Icons.construction_rounded,
      _ => Icons.fitness_center_rounded,
    };
  }
}
