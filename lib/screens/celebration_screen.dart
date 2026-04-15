import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/tactile_button.dart';

class CelebrationScreen extends StatelessWidget {
  final bool isLevelUp;
  final String title;
  final String subtitle;

  const CelebrationScreen({
    super.key,
    this.isLevelUp = false,
    this.title = 'NEW BADGE\nUNLOCKED!',
    this.subtitle = 'Master of Pushups',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Dot pattern
          Positioned.fill(child: CustomPaint(painter: _DotPainter())),
          // Sunburst background
          if (isLevelUp)
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 1.5,
                height: MediaQuery.of(context).size.width * 1.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.tertiaryContainer.withOpacity(0.3),
                      AppColors.background,
                    ],
                  ),
                ),
              ),
            ),
          // Confetti dots
          ..._confettiDots(),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Close button
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.popUntil(context, (r) => r.isFirst),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.outlineVariant, width: 2),
                        ),
                        child: const Icon(Icons.close_rounded,
                            color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          // Title
                          Text(
                            isLevelUp ? 'LEVEL UP!' : title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: isLevelUp ? 64 : 40,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              height: 1.05,
                              letterSpacing: -1,
                              shadows: [
                                Shadow(
                                  color: AppColors.primaryDim,
                                  offset: const Offset(0, 5),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .scale(
                                  begin: const Offset(0.4, 0.4),
                                  duration: 600.ms,
                                  curve: Curves.elasticOut),
                          const SizedBox(height: 8),
                          if (!isLevelUp)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.outlineVariant.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'MASTERY ACHIEVED',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.onSurfaceVariant,
                                  letterSpacing: 2,
                                ),
                              ),
                            )
                                .animate(delay: 200.ms)
                                .fadeIn(),
                          if (isLevelUp)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                    color: AppColors.secondary, width: 3),
                                boxShadow: const [
                                  BoxShadow(
                                      color: AppColors.secondaryDim,
                                      offset: Offset(0, 4),
                                      blurRadius: 0),
                                ],
                              ),
                              child: Text(
                                'LEVEL 5 REACHED',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.onSecondaryContainer,
                                ),
                              ),
                            )
                                .animate(delay: 200.ms)
                                .fadeIn(),
                          const SizedBox(height: 32),
                          // Badge / Mascot
                          isLevelUp
                              ? _LevelUpMascot()
                              : _BadgeCircle(subtitle: subtitle),
                          const SizedBox(height: 32),
                          // Stats grid
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  value: '+250',
                                  label: 'XP GAINED',
                                  valueColor: AppColors.secondary,
                                  delay: 600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _StatCard(
                                  value: '12',
                                  label: 'DAY STREAK',
                                  valueColor: AppColors.tertiary,
                                  delay: 700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // CTA button
                          TactileButton(
                            color: AppColors.primary,
                            shadowColor: AppColors.primaryDim,
                            onTap: () =>
                                Navigator.popUntil(context, (r) => r.isFirst),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isLevelUp
                                        ? 'CONTINUE'
                                        : 'COLLECT & CONTINUE',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.onPrimary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_rounded,
                                      color: AppColors.onPrimary, size: 22),
                                ],
                              ),
                            ),
                          )
                              .animate(delay: 800.ms)
                              .fadeIn()
                              .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (_) => _PostWorkoutCelebrationSheet(),
                              );
                            },
                            child: Text(
                              '📣  Share to Squad',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ).animate(delay: 900.ms).fadeIn(),
                          const SizedBox(height: 24),
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

  List<Widget> _confettiDots() {
    final positions = [
      const Offset(0.15, 0.1),
      const Offset(0.80, 0.12),
      const Offset(0.05, 0.6),
      const Offset(0.88, 0.65),
      const Offset(0.40, 0.08),
      const Offset(0.25, 0.75),
    ];
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.tertiaryContainer,
      AppColors.errorContainer,
      AppColors.primaryContainer,
      AppColors.secondaryContainer,
    ];
    return List.generate(6, (i) {
      return Positioned(
        left: positions[i].dx *
            1000, // approximate — will be clipped
        top: positions[i].dy * 900,
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: colors[i],
            borderRadius: BorderRadius.circular(4),
          ),
        )
            .animate(delay: (i * 100).ms)
            .fadeIn(duration: 400.ms)
            .scale(
                begin: const Offset(0, 0),
                duration: 500.ms,
                curve: Curves.elasticOut),
      );
    });
  }
}

class _BadgeCircle extends StatelessWidget {
  final String subtitle;
  const _BadgeCircle({required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Aura glow
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryContainer.withOpacity(0.25),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withOpacity(0.4),
                blurRadius: 40,
                spreadRadius: 20,
              ),
            ],
          ),
        ),
        // Badge outer ring
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainerLowest,
            border: Border.all(color: AppColors.primary, width: 6),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x22000000),
                  offset: Offset(0, 12),
                  blurRadius: 0),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.outlineVariant.withOpacity(0.5),
                    width: 3,
                    style: BorderStyle.solid),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surfaceContainerLowest,
                    AppColors.surfaceContainerLow,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppColors.onTertiaryFixed, width: 4),
                      boxShadow: const [
                        BoxShadow(
                            color: AppColors.tertiaryDim,
                            offset: Offset(0, 6),
                            blurRadius: 0),
                      ],
                    ),
                    child: Icon(Icons.fitness_center_rounded,
                        color: AppColors.onTertiaryFixed, size: 46),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        // XP badge
        Positioned(
          top: -8,
          right: -12,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.tertiaryContainer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.onTertiaryFixed, width: 3),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x44000000),
                    offset: Offset(0, 4),
                    blurRadius: 0),
              ],
            ),
            child: Text(
              'XP +500',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.onTertiaryFixed,
              ),
            ),
          )
              .animate(delay: 500.ms)
              .fadeIn()
              .rotate(begin: -0.15, end: 0.12, duration: 400.ms),
        ),
      ],
    )
        .animate(delay: 300.ms)
        .fadeIn(duration: 400.ms)
        .scale(
            begin: const Offset(0.5, 0.5),
            duration: 700.ms,
            curve: Curves.elasticOut);
  }
}

class _LevelUpMascot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.outlineVariant, width: 4),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x1A000000),
                  offset: Offset(0, 8),
                  blurRadius: 0),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.emoji_events_rounded,
              size: 110,
              color: AppColors.tertiaryContainer,
            ),
          ),
        ),
        Positioned(
          bottom: -12,
          right: -12,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.tertiaryContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.tertiaryDim, width: 4),
              boxShadow: [
                BoxShadow(
                    color: AppColors.tertiaryDim,
                    offset: const Offset(0, 4),
                    blurRadius: 0),
              ],
            ),
            child: Icon(Icons.workspace_premium_rounded,
                color: AppColors.onTertiaryFixed, size: 36),
          ).animate(delay: 400.ms).fadeIn().rotate(begin: 0, end: 0.2),
        ),
      ],
    )
        .animate(delay: 300.ms)
        .fadeIn()
        .scale(
            begin: const Offset(0.5, 0.5),
            duration: 700.ms,
            curve: Curves.elasticOut);
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final int delay;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant, width: 3),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000),
              offset: Offset(0, 6),
              blurRadius: 0),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn()
        .slideY(begin: 0.2, end: 0, duration: 400.ms);
  }
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x12E5E5E5);
    const spacing = 28.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Post Workout Celebration Share Sheet ──────────────────────────────────────

class _PostWorkoutCelebrationSheet extends StatefulWidget {
  @override
  State<_PostWorkoutCelebrationSheet> createState() => _PostWorkoutCelebrationSheetState();
}

class _PostWorkoutCelebrationSheetState extends State<_PostWorkoutCelebrationSheet> {
  String _selectedMood = '🏆';
  final _captionCtrl = TextEditingController();
  static const _moods = ['🏆', '🔥', '💪', '😅', '💎', '⭐', '😤', '😊'];

  @override
  void dispose() { _captionCtrl.dispose(); super.dispose(); }

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
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(999)))),
          const SizedBox(height: 20),
          Text('📣  Post to Squad!', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.onSurface)),
          const SizedBox(height: 4),
          Text('Share your win with the crew', style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _moods.map((m) => GestureDetector(
              onTap: () { HapticFeedback.lightImpact(); setState(() => _selectedMood = m); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: m == _selectedMood ? 52 : 44, height: m == _selectedMood ? 52 : 44,
                decoration: BoxDecoration(
                  color: m == _selectedMood ? AppColors.primaryContainer : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: m == _selectedMood ? AppColors.primary : AppColors.outlineVariant, width: m == _selectedMood ? 3 : 2),
                  boxShadow: m == _selectedMood ? const [BoxShadow(color: AppColors.primaryDim, offset: Offset(0, 3), blurRadius: 0)] : null,
                ),
                child: Center(child: Text(m, style: TextStyle(fontSize: m == _selectedMood ? 26 : 22))),
              ),
            )).toList(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _captionCtrl,
            maxLines: 2,
            style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: 'Tell them what you just did...',
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
                    HapticFeedback.mediumImpact();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Posted! $_selectedMood Squad sees your win 🎉'), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 3)),
                    );
                  },
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('POST IT!', style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white)),
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
