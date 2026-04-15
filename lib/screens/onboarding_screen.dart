import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/tactile_button.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _page = 0;
  int? _selectedLevel; // index into _levels

  static const _levels = [
    _AssessLevel(
      label: 'Zero — never done one',
      emoji: '🐣',
      detail: 'Complete beginner',
      pathStart: 0,
      description: "Day 1: One single rep at the wall. That's your mission.",
    ),
    _AssessLevel(
      label: '1–3 push-ups',
      emoji: '🌱',
      detail: 'Just getting started',
      pathStart: 2,
      description: "You'll skip the very basics and start building volume.",
    ),
    _AssessLevel(
      label: '4–8 push-ups',
      emoji: '💪',
      detail: 'Some experience',
      pathStart: 5,
      description: "We'll drop the angle and start real bodyweight training.",
    ),
    _AssessLevel(
      label: '9–15 push-ups',
      emoji: '🔥',
      detail: 'Getting solid',
      pathStart: 11,
      description: "You'll go straight to floor push-ups and build from there.",
    ),
    _AssessLevel(
      label: '16–25 push-ups',
      emoji: '⚡',
      detail: 'Strong foundation',
      pathStart: 17,
      description: "Straight into advanced variations — elbows in, diamond, wide.",
    ),
    _AssessLevel(
      label: '25+ push-ups',
      emoji: '🏆',
      detail: 'Advanced',
      pathStart: 22,
      description: "Decline, plyometric, and one-arm prep work starts immediately.",
    ),
  ];

  void _goToPage(int page) {
    _pageCtrl.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => _page = page);
  }

  void _selectLevel(int index) {
    HapticFeedback.mediumImpact();
    setState(() => _selectedLevel = index);
  }

  void _finish() {
    if (_selectedLevel == null) return;
    HapticFeedback.heavyImpact();
    gPathCompletedCount = _levels[_selectedLevel!].pathStart;
    gOnboardingComplete = true;
    widget.onComplete();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: PageView(
          controller: _pageCtrl,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _WelcomePage(onNext: () => _goToPage(1)),
            _AssessPage(
              levels: _levels,
              selected: _selectedLevel,
              onSelect: _selectLevel,
              onFinish: _finish,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Welcome Page ──────────────────────────────────────────────────────────────

class _WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const Spacer(flex: 2),
          // Mascot
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryDim, width: 5),
              boxShadow: const [
                BoxShadow(color: AppColors.primaryDim, offset: Offset(0, 8), blurRadius: 0),
              ],
            ),
            child: const Center(
              child: Text('💪', style: TextStyle(fontSize: 58)),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .moveY(begin: 0, end: -10, duration: 1800.ms, curve: Curves.easeInOut)
              .then()
              .moveY(begin: -10, end: 0, duration: 1800.ms, curve: Curves.easeInOut),
          const SizedBox(height: 36),
          // Title
          Text(
            'FitLingo',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
              height: 1,
            ),
          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),
          const SizedBox(height: 12),
          Text(
            'Your personal road to\nthe one-arm push-up.',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.15, end: 0),
          const SizedBox(height: 32),
          // Feature pills
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: const [
              _FeaturePill('🎮 Gamified path'),
              _FeaturePill('📈 Science-backed'),
              _FeaturePill('⚡ Just 15 min/day'),
              _FeaturePill('🤝 Social challenges'),
            ],
          ).animate(delay: 500.ms).fadeIn(),
          const Spacer(flex: 3),
          // CTA
          TactileButton(
            color: AppColors.primary,
            shadowColor: AppColors.primaryDim,
            padding: const EdgeInsets.symmetric(vertical: 18),
            onTap: onNext,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                "LET'S GET STARTED →",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ).animate(delay: 650.ms).fadeIn().slideY(begin: 0.1, end: 0),
          const SizedBox(height: 24),
          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Dot(active: true),
              const SizedBox(width: 8),
              _Dot(active: false),
            ],
          ).animate(delay: 700.ms).fadeIn(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final String text;
  const _FeaturePill(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.outlineVariant, width: 2),
      ),
      child: Text(
        text,
        style: GoogleFonts.beVietnamPro(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: active ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

// ── Assessment Page ───────────────────────────────────────────────────────────

class _AssessPage extends StatelessWidget {
  final List<_AssessLevel> levels;
  final int? selected;
  final void Function(int) onSelect;
  final VoidCallback onFinish;

  const _AssessPage({
    required this.levels,
    required this.selected,
    required this.onSelect,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              // Progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Dot(active: false),
                  const SizedBox(width: 8),
                  _Dot(active: true),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Quick question 🏋️',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ).animate().fadeIn(),
              const SizedBox(height: 8),
              Text(
                'How many push-ups\ncan you do right now?',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                  height: 1.15,
                ),
              ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1, end: 0),
              const SizedBox(height: 6),
              Text(
                'Be honest — this sets your starting level.',
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ).animate(delay: 200.ms).fadeIn(),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Level options list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: levels.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) => _LevelCard(
              level: levels[i],
              isSelected: selected == i,
              onTap: () => onSelect(i),
              delay: i * 60,
            ),
          ),
        ),
        // CTA footer
        Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 20),
          child: Column(
            children: [
              if (selected != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Row(
                    children: [
                      const Text('📍', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          levels[selected!].description,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 250.ms).scale(
                    begin: const Offset(0.95, 0.95), duration: 250.ms, curve: Curves.easeOut),
                const SizedBox(height: 12),
              ],
              TactileButton(
                color: selected != null ? AppColors.primary : AppColors.surfaceContainerHigh,
                shadowColor: selected != null ? AppColors.primaryDim : AppColors.outlineVariant,
                padding: const EdgeInsets.symmetric(vertical: 18),
                onTap: selected != null ? onFinish : null,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'START MY JOURNEY →',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: selected != null ? Colors.white : AppColors.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  final _AssessLevel level;
  final bool isSelected;
  final VoidCallback onTap;
  final int delay;

  const _LevelCard({
    required this.level,
    required this.isSelected,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer.withValues(alpha: 0.25) : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? AppColors.primaryDim : const Color(0x0D000000),
              offset: Offset(0, isSelected ? 5 : 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Text(level.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                  Text(
                    level.detail,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 250.ms)
        .slideX(begin: 0.05, end: 0);
  }
}

// ── Data Models ───────────────────────────────────────────────────────────────

class _AssessLevel {
  final String label;
  final String emoji;
  final String detail;
  final int pathStart;
  final String description;

  const _AssessLevel({
    required this.label,
    required this.emoji,
    required this.detail,
    required this.pathStart,
    required this.description,
  });
}
