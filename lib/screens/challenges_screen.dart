import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/tactile_button.dart';
import '../widgets/top_bar.dart';
import 'squad_detail_screen.dart';
import 'exercise_browser_screen.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FitLingoTopBar(title: 'Challenges'),
      body: Column(
        children: [
          // Tab strip
          Container(
            color: AppColors.surfaceContainerLowest,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _TabStrip(controller: _tab),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              physics: const BouncingScrollPhysics(),
              children: [
                _ChallengesTab(),
                _SquadTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabStrip extends StatelessWidget {
  final TabController controller;
  const _TabStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80), width: 2),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
                color: AppColors.primaryDim,
                offset: Offset(0, 3),
                blurRadius: 0),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13, fontWeight: FontWeight.w900),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13, fontWeight: FontWeight.w700),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.onSurfaceVariant,
        tabs: const [
          Tab(text: 'Challenges'),
          Tab(text: 'My Squad'),
        ],
      ),
    );
  }
}

// ── Challenges Tab ────────────────────────────────────────────────────────────

class _ChallengesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active challenges
          _SectionHeader(
            title: 'Active Challenges',
            action: 'See All',
            padding: const EdgeInsets.symmetric(horizontal: 20),
            onAction: () {
              HapticFeedback.selectionClick();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Showing all active challenges'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                _ActiveChallengeCard(
                  opponent: 'Alex',
                  title: 'Pushup Battle',
                  yourProgress: 72,
                  theirProgress: 58,
                  daysLeft: 2,
                  color: AppColors.primary,
                ).animate(delay: 60.ms).fadeIn().slideX(begin: 0.05, end: 0),
                const SizedBox(width: 14),
                _ActiveChallengeCard(
                  opponent: 'Sarah',
                  title: 'Weekly Steps',
                  yourProgress: 45,
                  theirProgress: 81,
                  daysLeft: 4,
                  color: AppColors.secondary,
                ).animate(delay: 120.ms).fadeIn().slideX(begin: 0.05, end: 0),
                const SizedBox(width: 14),
                _ActiveChallengeCard(
                  opponent: 'Marcus',
                  title: 'Squat Challenge',
                  yourProgress: 90,
                  theirProgress: 87,
                  daysLeft: 1,
                  color: AppColors.errorContainer,
                ).animate(delay: 180.ms).fadeIn().slideX(begin: 0.05, end: 0),
              ],
            ),
          ),
          const SizedBox(height: 28),
          // Challenge a friend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SectionHeader(title: 'Challenge a Friend'),
          ).animate(delay: 200.ms).fadeIn(),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _ChallengeFriendSection()
                .animate(delay: 250.ms)
                .fadeIn()
                .slideY(begin: 0.04, end: 0),
          ),
          const SizedBox(height: 28),
          // Group challenges
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SectionHeader(title: 'Group Challenges'),
          ).animate(delay: 300.ms).fadeIn(),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _GroupChallengeCard(
                  title: '10,000 Pushup Club',
                  participants: 248,
                  daysLeft: 5,
                  progress: 0.62,
                  icon: Icons.fitness_center_rounded,
                  color: AppColors.primary,
                ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.04, end: 0),
                const SizedBox(height: 12),
                _GroupChallengeCard(
                  title: 'Family 5K Challenge',
                  participants: 6,
                  daysLeft: 12,
                  progress: 0.38,
                  icon: Icons.family_restroom_rounded,
                  color: AppColors.secondary,
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.04, end: 0),
                const SizedBox(height: 12),
                _GroupChallengeCard(
                  title: '30-Day Plank',
                  participants: 1043,
                  daysLeft: 18,
                  progress: 0.40,
                  icon: Icons.horizontal_rule_rounded,
                  color: AppColors.tertiary,
                ).animate(delay: 450.ms).fadeIn().slideY(begin: 0.04, end: 0),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Browse new challenges
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _BrowseChallengesButton()
                .animate(delay: 500.ms)
                .fadeIn(),
          ),
        ],
      ),
    );
  }
}

// ── Active Challenge Card ───────────────────────────────────────────��─────────

class _ActiveChallengeCard extends StatelessWidget {
  final String opponent;
  final String title;
  final int yourProgress;
  final int theirProgress;
  final int daysLeft;
  final Color color;

  const _ActiveChallengeCard({
    required this.opponent,
    required this.title,
    required this.yourProgress,
    required this.theirProgress,
    required this.daysLeft,
    required this.color,
  });

  void _showDetail(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ChallengeDetailSheet(
        title: title,
        opponent: opponent,
        yourProgress: yourProgress,
        theirProgress: theirProgress,
        daysLeft: daysLeft,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWinning = yourProgress > theirProgress;
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
      width: 200,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(60), width: 2),
        boxShadow: [
          BoxShadow(
              color: color.withAlpha(40),
              offset: const Offset(0, 5),
              blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isWinning
                      ? AppColors.primaryContainer.withAlpha(60)
                      : AppColors.errorContainer.withAlpha(20),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isWinning ? 'WINNING' : 'BEHIND',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: isWinning ? AppColors.primary : AppColors.error,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                '$daysLeft d left',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
            ),
          ),
          Text(
            'vs $opponent',
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          // You vs them
          _ProgressCompare(
            yourProgress: yourProgress,
            theirProgress: theirProgress,
            color: color,
          ),
        ],
      ),
    ),
    );
  }
}

class _ProgressCompare extends StatelessWidget {
  final int yourProgress;
  final int theirProgress;
  final Color color;
  const _ProgressCompare({
    required this.yourProgress,
    required this.theirProgress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Bar(label: 'You', value: yourProgress, color: color),
        const SizedBox(height: 6),
        _Bar(label: 'Them', value: theirProgress, color: AppColors.outlineVariant),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _Bar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 32,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              FractionallySizedBox(
                widthFactor: value / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$value%',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

// ── Challenge a Friend Section ────────────────────────────────────────────────

class _ChallengeFriendSection extends StatefulWidget {
  @override
  State<_ChallengeFriendSection> createState() =>
      _ChallengeFriendSectionState();
}

class _ChallengeFriendSectionState extends State<_ChallengeFriendSection> {
  int? _selected;

  static const _friends = [
    ('Lola', AppColors.secondaryContainer),
    ('Tom', AppColors.tertiaryContainer),
    ('Marcus', AppColors.surfaceContainerHigh),
    ('Jia', AppColors.primaryContainer),
    ('Sarah', AppColors.errorContainer),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.surfaceContainerHigh, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Who do you want to challenge?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: _friends.asMap().entries.map((e) {
              final isSelected = _selected == e.key;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _selected = isSelected ? null : e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: e.value.$2,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    const BoxShadow(
                                        color: AppColors.primaryDim,
                                        offset: Offset(0, 3),
                                        blurRadius: 0)
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              e.value.$1[0],
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e.value.$1,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TactileButton(
            color: _selected != null
                ? AppColors.primary
                : AppColors.surfaceContainerHigh,
            shadowColor: _selected != null
                ? AppColors.primaryDim
                : AppColors.outlineVariant,
            padding: const EdgeInsets.symmetric(vertical: 14),
            onTap: _selected == null ? null : () {
              HapticFeedback.mediumImpact();
              final name = _friends[_selected!].$1;
              setState(() => _selected = null);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Challenge sent to $name! 🏆'),
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                _selected != null
                    ? 'SEND CHALLENGE TO ${_friends[_selected!].$1.toUpperCase()}'
                    : 'SELECT A FRIEND',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: _selected != null
                      ? Colors.white
                      : AppColors.onSurfaceVariant,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Group Challenge Card ──────────────────────────────────────────────────────

class _GroupChallengeCard extends StatelessWidget {
  final String title;
  final int participants;
  final int daysLeft;
  final double progress;
  final IconData icon;
  final Color color;

  const _GroupChallengeCard({
    required this.title,
    required this.participants,
    required this.daysLeft,
    required this.progress,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: AppColors.surfaceContainerHigh, width: 2),
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000),
              offset: Offset(0, 4),
              blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withAlpha(18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withAlpha(60), width: 2),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.people_rounded,
                        size: 12, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 3),
                    Text(
                      '$participants joined',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.schedule_rounded,
                        size: 12, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 3),
                    Text(
                      '$daysLeft days left',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TactileButton(
            color: color,
            shadowColor: _darken(color),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            onTap: () {
              HapticFeedback.mediumImpact();
              showDialog(
                context: context,
                builder: (_) => _JoinChallengeDialog(
                  title: title,
                  color: color,
                ),
              );
            },
            child: Text(
              'JOIN',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _darken(Color color) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness - 0.12).clamp(0.0, 1.0)).toColor();
}

// ── Browse button ─────────────────────────────────────────────────────────────

class _BrowseChallengesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ExerciseBrowserScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
          ),
        );
      },
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: AppColors.outlineVariant.withAlpha(80), width: 2),
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000),
              offset: Offset(0, 3),
              blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search_rounded,
                color: AppColors.onSurfaceVariant, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Browse All Challenges',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  '140+ challenges available',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.outlineVariant),
        ],
      ),
    ),
    );
  }
}

// ── Squad Tab ─────────────────────────────────────────────────────────────────

class _SquadTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Your squad card
          _MySquadHeroCard()
              .animate()
              .fadeIn(duration: 350.ms)
              .slideY(begin: 0.04, end: 0),
          const SizedBox(height: 24),
          // Weekly standings
          _SectionHeader(title: 'Weekly Standings'),
          const SizedBox(height: 4),
          Text(
            'How your squad ranks against others this week',
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
            ),
          ).animate(delay: 80.ms).fadeIn(),
          const SizedBox(height: 14),
          ..._buildSquadList(),
          const SizedBox(height: 24),
          // Squad members
          _SectionHeader(title: 'Your Squad Members'),
          const SizedBox(height: 12),
          ..._buildMemberList(),
          const SizedBox(height: 16),
          // Invite button
          TactileButton(
            color: AppColors.surfaceContainerLow,
            shadowColor: AppColors.outlineVariant,
            border: Border.all(color: AppColors.outlineVariant, width: 2),
            padding: const EdgeInsets.symmetric(vertical: 14),
            onTap: () {
              HapticFeedback.lightImpact();
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => const _InviteSheet(),
              );
            },
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_add_rounded,
                      size: 18, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    'INVITE FRIENDS',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: 500.ms).fadeIn(),
        ],
      ),
    );
  }

  List<Widget> _buildSquadList() {
    const squads = [
      ('Iron Wolves', 48200, 1),
      ('Run Club NYC', 44100, 2),
      ('Beast Mode', 41800, 3),
      ('Iron Wolves', 38500, 4), // Your squad
      ('Morning Crew', 35200, 5),
    ];
    return squads.asMap().entries.map((e) {
      final isYours = e.key == 3;
      return _SquadStandingRow(
        rank: e.value.$3,
        name: e.value.$1,
        xp: e.value.$2,
        isYours: isYours,
        delay: e.key * 60,
      );
    }).toList();
  }

  List<Widget> _buildMemberList() {
    const members = [
      ('Sarah "Swift" Miller', 9800, 35, true, AppColors.errorContainer),
      ('Marcus "Iron" Wu', 11200, 40, false, AppColors.secondaryContainer),
      ('You', 8400, 28, true, AppColors.primaryContainer),
      ('Elena Rodriguez', 7400, 29, true, AppColors.tertiaryContainer),
      ('James "Bear" Kim', 6200, 25, false, AppColors.surfaceContainerHigh),
    ];
    return members.asMap().entries.map((e) {
      final isTop = e.key == 1; // Marcus is squad leader
      return _MemberRow(
        name: e.value.$1,
        xp: e.value.$2,
        level: e.value.$3,
        isOnline: e.value.$4,
        avatarColor: e.value.$5,
        isTop: isTop,
        isYou: e.value.$1 == 'You',
        delay: e.key * 60,
      );
    }).toList();
  }
}

// ── My Squad Hero Card ────────────────────────────────────────────────────────

class _MySquadHeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SquadDetailScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.secondaryDim, width: 2),
          boxShadow: const [
            BoxShadow(
                color: AppColors.secondaryDim,
                offset: Offset(0, 6),
                blurRadius: 0),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.white.withAlpha(30), width: 2),
                  ),
                  child: const Icon(Icons.shield_rounded,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Iron Wolves',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '5 members · 24-day streak 🔥',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                        color: Colors.white.withAlpha(50), width: 2),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '#4',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'this week',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withAlpha(180),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Active challenge progress
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: Colors.white.withAlpha(30), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '100k Pushup Challenge',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '68%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.68,
                      backgroundColor: Colors.white.withAlpha(30),
                      valueColor: const AlwaysStoppedAnimation(
                          AppColors.primaryContainer),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tap to see squad details',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withAlpha(160),
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Squad Standing Row ────────────────────────────────────────────────────────

class _SquadStandingRow extends StatelessWidget {
  final int rank;
  final String name;
  final int xp;
  final bool isYours;
  final int delay;

  const _SquadStandingRow({
    required this.rank,
    required this.name,
    required this.xp,
    required this.isYours,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    Color? medalColor;
    if (rank == 1) medalColor = AppColors.tertiaryContainer;
    if (rank == 2) medalColor = AppColors.outlineVariant;
    if (rank == 3) medalColor = const Color(0xFFcd7f32);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isYours
            ? AppColors.primaryContainer.withAlpha(30)
            : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isYours ? AppColors.primary : AppColors.surfaceContainerHigh,
          width: isYours ? 2 : 2,
        ),
        boxShadow: isYours
            ? const [
                BoxShadow(
                    color: AppColors.primaryDim,
                    offset: Offset(0, 3),
                    blurRadius: 0)
              ]
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: medalColor != null
                ? Icon(Icons.workspace_premium_rounded,
                    color: medalColor, size: 22)
                : Text(
                    '#$rank',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isYours ? '$name (your squad)' : name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: isYours ? FontWeight.w900 : FontWeight.w700,
                color: isYours ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ),
          Text(
            '${(xp / 1000).toStringAsFixed(1)}k XP',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn()
        .slideX(begin: 0.03, end: 0, duration: 300.ms);
  }
}

// ── Member Row ────────────────────────────────────────────────────────────────

class _MemberRow extends StatelessWidget {
  final String name;
  final int xp;
  final int level;
  final bool isOnline;
  final Color avatarColor;
  final bool isTop;
  final bool isYou;
  final int delay;

  const _MemberRow({
    required this.name,
    required this.xp,
    required this.level,
    required this.isOnline,
    required this.avatarColor,
    required this.isTop,
    required this.isYou,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isYou
            ? AppColors.primaryContainer.withAlpha(20)
            : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isYou ? AppColors.primary.withAlpha(60) : AppColors.surfaceContainerHigh,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: avatarColor,
                  border: Border.all(
                      color: AppColors.outlineVariant, width: 2),
                ),
                child: Center(
                  child: Text(
                    name[0],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ),
              if (isTop)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.star_rounded,
                        size: 10, color: AppColors.onTertiaryFixed),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isYou ? '$name (You)' : name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isOnline ? 'Active today' : 'Offline',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(xp / 1000).toStringAsFixed(1)}k XP',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'LVL $level',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 200 + delay))
        .fadeIn()
        .slideY(begin: 0.03, end: 0, duration: 300.ms);
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final EdgeInsets padding;

  const _SectionHeader({
    required this.title,
    this.action,
    this.onAction,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Challenge Detail Sheet ────────────────────────────────────────────────────

class _ChallengeDetailSheet extends StatelessWidget {
  final String title;
  final String opponent;
  final int yourProgress;
  final int theirProgress;
  final int daysLeft;
  final Color color;

  const _ChallengeDetailSheet({
    required this.title,
    required this.opponent,
    required this.yourProgress,
    required this.theirProgress,
    required this.daysLeft,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isWinning = yourProgress > theirProgress;
    final gap = (yourProgress - theirProgress).abs();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isWinning
                  ? AppColors.primaryContainer.withAlpha(60)
                  : AppColors.errorContainer.withAlpha(40),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isWinning ? AppColors.primary : AppColors.error,
                width: 2,
              ),
            ),
            child: Text(
              isWinning ? '🏆 YOU\'RE WINNING!' : '⚡ TIME TO CATCH UP!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: isWinning ? AppColors.primary : AppColors.error,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
            ),
          ),
          Text(
            'vs $opponent · $daysLeft days left',
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withAlpha(10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withAlpha(40), width: 2),
            ),
            child: Column(
              children: [
                _Bar(label: 'You', value: yourProgress, color: color),
                const SizedBox(height: 12),
                _Bar(label: opponent, value: theirProgress, color: AppColors.outlineVariant),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isWinning
                ? 'You\'re $gap% ahead — keep it up!'
                : 'You\'re $gap% behind — push harder!',
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          TactileButton(
            color: color,
            shadowColor: _darken(color),
            padding: const EdgeInsets.symmetric(vertical: 16),
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.pop(context);
            },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'LET\'S GO! 💪',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Join Challenge Dialog ─────────────────────────────────────────────────────

class _JoinChallengeDialog extends StatelessWidget {
  final String title;
  final Color color;

  const _JoinChallengeDialog({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withAlpha(60), width: 3),
          boxShadow: [
            BoxShadow(color: color.withAlpha(40), offset: const Offset(0, 8), blurRadius: 0),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                shape: BoxShape.circle,
                border: Border.all(color: color.withAlpha(60), width: 3),
              ),
              child: Icon(Icons.emoji_events_rounded, color: color, size: 34),
            ),
            const SizedBox(height: 16),
            Text(
              'Join Challenge?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TactileButton(
                    color: AppColors.surfaceContainerLow,
                    shadowColor: AppColors.outlineVariant,
                    border: Border.all(color: AppColors.outlineVariant, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'CANCEL',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TactileButton(
                    color: color,
                    shadowColor: _darken(color),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You joined $title! 🏆'),
                          duration: const Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Text(
                      'JOIN!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Invite Sheet ──────────────────────────────────────────────────────────────

class _InviteSheet extends StatelessWidget {
  const _InviteSheet();

  @override
  Widget build(BuildContext context) {
    const channels = [
      (Icons.message_rounded, 'Send a Text', 'Invite via Messages'),
      (Icons.link_rounded, 'Copy Squad Link', 'Share a link to join'),
      (Icons.alternate_email_rounded, 'Share on Social', 'Post to your story'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'INVITE TO IRON WOLVES',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ...channels.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TactileButton(
                  color: AppColors.surfaceContainerLowest,
                  shadowColor: AppColors.outlineVariant,
                  border: Border.all(color: AppColors.surfaceContainerHigh, width: 2),
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(16),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${c.$2}...'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withAlpha(40),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(c.$1, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.$2,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                          ),
                          Text(
                            c.$3,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.outlineVariant),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
