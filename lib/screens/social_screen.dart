import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/tactile_button.dart';
import '../widgets/top_bar.dart';

// ── Shared workout post model ──────────────────────────────────────────────────
class _WorkoutPost {
  final String name;
  final String initials;
  final Color avatarColor;
  final String exercise;
  final String reps;
  final String mood;
  final String caption;
  final String time;
  int kudos;
  bool kudosed;

  _WorkoutPost({
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.exercise,
    required this.reps,
    required this.mood,
    required this.caption,
    required this.time,
    required this.kudos,
    this.kudosed = false,
  });
}

// Global mutable feed list (persists within session)
final _feedPosts = <_WorkoutPost>[
  _WorkoutPost(name: 'Lola Chen', initials: 'LC', avatarColor: AppColors.secondaryContainer,
    exercise: 'Incline Push-Up', reps: '3 × 8', mood: '🔥', kudos: 7,
    caption: 'Finally hit 3 sets of 8! Day 9 complete 💪', time: '12m ago'),
  _WorkoutPost(name: 'Marcus Wu', initials: 'MW', avatarColor: const Color(0xFFB3E5FC),
    exercise: 'Diamond Push-Up', reps: '2 × 6', mood: '💎', kudos: 4,
    caption: 'Diamond push-ups are NO JOKE. Triceps destroyed 😂', time: '1h ago'),
  _WorkoutPost(name: 'Jia Park', initials: 'JP', avatarColor: AppColors.primaryContainer,
    exercise: 'Plank Hold', reps: '3 × 25s', mood: '😤', kudos: 11,
    caption: 'Core day. Not fun. Necessary. #discipline', time: '2h ago'),
  _WorkoutPost(name: 'Priya Nair', initials: 'PN', avatarColor: AppColors.tertiaryContainer,
    exercise: 'Standard Push-Up', reps: '3 × 8', mood: '⭐', kudos: 19,
    caption: 'Certified!! After 14 days I finally got my 3×8 💥', time: '3h ago'),
];

// ── Screen ────────────────────────────────────────────────────────────────────
class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});
  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {

  void _openShareSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PostWorkoutShareSheet(
        onPost: (exercise, reps, mood, caption) {
          setState(() {
            _feedPosts.insert(0, _WorkoutPost(
              name: 'You', initials: 'YO', avatarColor: AppColors.primaryContainer,
              exercise: exercise, reps: reps, mood: mood,
              caption: caption.isEmpty ? 'Just finished a session! 💪' : caption,
              time: 'just now', kudos: 0,
            ));
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Posted to your squad! 🎉'), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 2)),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FitLingoTopBar(),
      floatingActionButton: GestureDetector(
        onTap: _openShareSheet,
        child: Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary, shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryDim, width: 3),
            boxShadow: const [BoxShadow(color: AppColors.primaryDim, offset: Offset(0, 5), blurRadius: 0)],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stories
            _StoriesStrip(onAddStory: _openShareSheet)
                .animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 4),
            // Section label
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text('SQUAD ACTIVITY', style: GoogleFonts.plusJakartaSans(
                fontSize: 11, fontWeight: FontWeight.w900,
                color: AppColors.onSurfaceVariant, letterSpacing: 1.5)),
            ),
            // Feed
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: List.generate(_feedPosts.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _WorkoutPostCard(
                      post: _feedPosts[i],
                      onKudos: () => setState(() {
                        _feedPosts[i].kudosed = !_feedPosts[i].kudosed;
                        _feedPosts[i].kudos += _feedPosts[i].kudosed ? 1 : -1;
                      }),
                    ).animate(delay: Duration(milliseconds: i * 80))
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.04, end: 0),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stories Strip ─────────────────────────────────────────────────────────────
class _StoriesStrip extends StatelessWidget {
  final VoidCallback onAddStory;
  const _StoriesStrip({required this.onAddStory});

  static const _friends = [
    ('Lola', AppColors.secondaryContainer, true, '🔥 Day 9'),
    ('Marcus', Color(0xFFB3E5FC), true, '💎 Day 18'),
    ('Jia', AppColors.primaryContainer, true, '😤 Core'),
    ('Priya', AppColors.tertiaryContainer, true, '⭐ Cert!'),
    ('Tom', AppColors.surfaceContainerHigh, false, ''),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: onAddStory,
            child: _StoryBubble(name: 'You', color: AppColors.surfaceContainerLowest, isAdd: true),
          ),
          const SizedBox(width: 12),
          ...List.generate(_friends.length, (i) {
            final f = _friends[i];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  if (!f.$3) return;
                  HapticFeedback.lightImpact();
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => _StoryViewSheet(name: f.$1, activity: f.$4, color: f.$2),
                  );
                },
                child: _StoryBubble(
                  name: f.$1, color: f.$2, isActive: f.$3,
                  activity: f.$4,
                ).animate(delay: Duration(milliseconds: i * 60))
                    .fadeIn().scale(begin: const Offset(0.8, 0.8), duration: 300.ms, curve: Curves.easeOut),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StoryBubble extends StatelessWidget {
  final String name;
  final Color color;
  final bool isAdd;
  final bool isActive;
  final String activity;
  const _StoryBubble({required this.name, required this.color, this.isAdd = false, this.isActive = true, this.activity = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isAdd
            ? Container(
                width: 66, height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerLowest,
                  border: Border.all(color: AppColors.outlineVariant, width: 3, style: BorderStyle.solid),
                ),
                child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 30),
              )
            : Container(
                width: 70, height: 70, padding: const EdgeInsets.all(3),
                decoration: isActive
                    ? const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(
                        colors: [AppColors.primaryContainer, AppColors.tertiaryContainer, AppColors.secondaryContainer]))
                    : BoxDecoration(shape: BoxShape.circle, color: AppColors.surfaceContainerHigh),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: color,
                    border: Border.all(color: AppColors.surfaceContainerLowest, width: 3),
                  ),
                  child: Center(
                    child: Text(activity.isNotEmpty ? activity.substring(0, min(2, activity.length)) : name[0],
                      style: GoogleFonts.plusJakartaSans(fontSize: activity.isNotEmpty ? 18 : 22, fontWeight: FontWeight.w900, color: AppColors.onSurface)),
                  ),
                ),
              ),
        const SizedBox(height: 4),
        Text(name, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 0.3)),
        if (activity.isNotEmpty && !isAdd)
          Text(activity, style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.primary)),
      ],
    );
  }
}

// ── Workout Post Card ─────────────────────────────────────────────────────────
class _WorkoutPostCard extends StatelessWidget {
  final _WorkoutPost post;
  final VoidCallback onKudos;
  const _WorkoutPostCard({required this.post, required this.onKudos});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceContainerHigh, width: 3),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), offset: Offset(0, 4), blurRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: post.avatarColor,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Center(child: Text(post.mood, style: const TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.name, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
                      Text('${post.exercise} · ${post.time}', style: GoogleFonts.beVietnamPro(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
                // Reps badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                  ),
                  child: Text(post.reps, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.primary)),
                ),
              ],
            ),
          ),
          // Exercise visual strip
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                post.avatarColor.withValues(alpha: 0.5),
                AppColors.primaryContainer.withValues(alpha: 0.2),
              ]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceContainerHigh, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(post.mood, style: const TextStyle(fontSize: 32)),
                    Text(post.exercise, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
                  ],
                ),
                Container(width: 2, height: 40, color: AppColors.outlineVariant),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(post.reps, style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
                    Text('sets × reps', style: GoogleFonts.beVietnamPro(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
                  ],
                ),
                Container(width: 2, height: 40, color: AppColors.outlineVariant),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${post.kudos + (post.kudosed ? 1 : 0)}', style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.secondary, height: 1)),
                    Text('kudos', style: GoogleFonts.beVietnamPro(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
          // Caption
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Text(post.caption, style: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.onSurface, height: 1.4)),
            ),
          // Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () { HapticFeedback.mediumImpact(); onKudos(); },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: post.kudosed ? AppColors.primary : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: post.kudosed ? AppColors.primaryDim : AppColors.outlineVariant,
                          width: 2,
                        ),
                        boxShadow: post.kudosed ? const [BoxShadow(color: AppColors.primaryDim, offset: Offset(0, 3), blurRadius: 0)] : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(post.kudosed ? '💪' : '🤜', style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(post.kudosed ? 'KUDOS!' : 'KUDOS',
                            style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w900,
                              color: post.kudosed ? Colors.white : AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Say hi to ${post.name.split(' ').first}! 👋'), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2)),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.outlineVariant, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 6),
                          Text('CHEER', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Post Workout Share Sheet ──────────────────────────────────────────────────
class _PostWorkoutShareSheet extends StatefulWidget {
  final void Function(String exercise, String reps, String mood, String caption) onPost;
  const _PostWorkoutShareSheet({required this.onPost});
  @override
  State<_PostWorkoutShareSheet> createState() => _PostWorkoutShareSheetState();
}

class _PostWorkoutShareSheetState extends State<_PostWorkoutShareSheet> {
  String _selectedMood = '💪';
  final _captionCtrl = TextEditingController();
  final _exerciseCtrl = TextEditingController(text: 'Push-Up');
  final _repsCtrl = TextEditingController(text: '3 × 8');

  static const _moods = ['🔥', '💪', '😅', '💎', '⭐', '😤', '🏆', '😊'];

  @override
  void dispose() { _captionCtrl.dispose(); _exerciseCtrl.dispose(); _repsCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(999)))),
          const SizedBox(height: 20),
          Text('Share to Squad 💪', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.onSurface)),
          const SizedBox(height: 4),
          Text('Let your crew know you showed up', style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 20),
          // Mood picker
          Text('HOW\'D IT FEEL?', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.onSurfaceVariant, letterSpacing: 1.5)),
          const SizedBox(height: 10),
          Row(
            children: _moods.map((m) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () { HapticFeedback.lightImpact(); setState(() => _selectedMood = m); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: m == _selectedMood ? 48 : 40, height: m == _selectedMood ? 48 : 40,
                  decoration: BoxDecoration(
                    color: m == _selectedMood ? AppColors.primaryContainer : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: m == _selectedMood ? AppColors.primary : AppColors.outlineVariant,
                      width: m == _selectedMood ? 3 : 2,
                    ),
                    boxShadow: m == _selectedMood ? const [BoxShadow(color: AppColors.primaryDim, offset: Offset(0, 3), blurRadius: 0)] : null,
                  ),
                  child: Center(child: Text(m, style: TextStyle(fontSize: m == _selectedMood ? 24 : 20))),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          // Caption field
          TextField(
            controller: _captionCtrl,
            maxLines: 2,
            style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: 'Say something about your workout...',
              hintStyle: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.onSurfaceVariant),
              filled: true, fillColor: AppColors.surfaceContainerLow,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.outlineVariant, width: 2)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.outlineVariant, width: 2)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.primary, width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TactileButton(
                  color: AppColors.primary, shadowColor: AppColors.primaryDim,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onPost(_exerciseCtrl.text, _repsCtrl.text, _selectedMood, _captionCtrl.text);
                  },
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('POST TO SQUAD', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                      const SizedBox(width: 8),
                      const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.outlineVariant, width: 2),
                  ),
                  child: Text('Skip', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Story View Sheet ──────────────────────────────────────────────────────────
class _StoryViewSheet extends StatelessWidget {
  final String name;
  final String activity;
  final Color color;
  const _StoryViewSheet({required this.name, required this.activity, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(999)))),
          const SizedBox(height: 24),
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: Border.all(color: AppColors.primary, width: 4)),
            child: Center(child: Text(activity.isNotEmpty ? activity.substring(0, 2) : name[0], style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.onSurface))),
          ),
          const SizedBox(height: 12),
          Text(name, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.onSurface)),
          Text(activity, style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.outlineVariant, width: 2),
              ),
              child: Text(
                '$name just completed a session: $activity 🎉\nKeep crushing it!',
                style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.onSurface, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
