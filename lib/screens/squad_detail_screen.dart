import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../widgets/tactile_button.dart';

class SquadDetailScreen extends StatefulWidget {
  const SquadDetailScreen({super.key});

  @override
  State<SquadDetailScreen> createState() => _SquadDetailScreenState();
}

class _SquadDetailScreenState extends State<SquadDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;

  static const _members = [
    _Member('Alex K.', 2840, 'assets/av1.png', true, 'Captain', Colors.amber),
    _Member('Sam R.', 2610, 'assets/av2.png', true, 'Co-Captain', Colors.blue),
    _Member('Jordan M.', 2200, 'assets/av3.png', false, 'Member', Colors.green),
    _Member('Taylor L.', 1950, 'assets/av4.png', true, 'Member', Colors.purple),
    _Member('Morgan P.', 1740, 'assets/av5.png', false, 'Member', Colors.orange),
    _Member('You', 1580, null, true, 'Member', AppColors.primary),
  ];

  static const _challenges = [
    _SquadChallenge('100K Pushup March', 67430, 100000, AppColors.primary, Icons.fitness_center_rounded),
    _SquadChallenge('30-Day Streak War', 18, 30, Color(0xFFb02500), Icons.local_fire_department_rounded),
    _SquadChallenge('Squat Squad 50K', 31200, 50000, Color(0xFF00628c), Icons.accessibility_new_rounded),
  ];

  static const _activityFeed = [
    _Activity('Alex K.', 'crushed a 5-set pushup session', '2 min ago', Icons.fitness_center_rounded),
    _Activity('Sam R.', 'extended their streak to 18 days!', '1 hr ago', Icons.local_fire_department_rounded),
    _Activity('Squad', 'hit 60% of the pushup challenge!', '3 hr ago', Icons.emoji_events_rounded),
    _Activity('Jordan M.', 'completed Leg Day Basics', '5 hr ago', Icons.directions_run_rounded),
    _Activity('Taylor L.', 'joined the Squat Squad challenge', '1 day ago', Icons.group_add_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _progressController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeroHeader(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildRankCard(),
                const SizedBox(height: 20),
                _buildActiveChallenges(),
                const SizedBox(height: 20),
                _buildMembersSection(),
                const SizedBox(height: 20),
                _buildActivityFeed(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildActionBar(context),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2a6900), Color(0xFF1a4a00)],
            ),
          ),
          child: Stack(
            children: [
              // Decorative dots
              ...List.generate(12, (i) {
                final x = (i * 73.0) % 400;
                final y = (i * 47.0) % 220;
                return Positioned(
                  left: x,
                  top: y,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primaryContainer.withOpacity(0.4),
                                width: 2,
                              ),
                            ),
                            child: const Text('⚡', style: TextStyle(fontSize: 28)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Iron Wolves',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '6 members · Platinum League',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.75),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _StatPill(
                            icon: Icons.emoji_events_rounded,
                            label: '#4 Global',
                            color: const Color(0xFFfec700),
                          ),
                          const SizedBox(width: 10),
                          _StatPill(
                            icon: Icons.local_fire_department_rounded,
                            label: '2,840 XP this week',
                            color: AppColors.errorContainer,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFfec700),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFe6b200), width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFe6b200),
            offset: Offset(0, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) => Transform.scale(
              scale: 1.0 + _pulseController.value * 0.05,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Center(
                  child: Text(
                    '#4',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF725800),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Global Ranking',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF725800),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You\'re 340 XP away from #3!',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    color: const Color(0xFF725800),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.66,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.4),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF725800)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, curve: Curves.easeOutCubic);
  }

  Widget _buildActiveChallenges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Challenges',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const _NewChallengeSheet(),
                );
              },
              child: Text(
                '+ New',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_challenges.length, (i) {
          final c = _challenges[i];
          final pct = c.current / c.goal;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFE5E5E5),
                    offset: Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: c.color.withOpacity(0.3), width: 2),
                    ),
                    child: Icon(c.icon, color: c.color, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 8,
                            backgroundColor: const Color(0xFFF0F0F0),
                            valueColor: AlwaysStoppedAnimation(c.color),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatNum(c.current)} / ${_formatNum(c.goal)}  ·  ${(pct * 100).round()}% done',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            color: AppColors.outlineVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate(delay: (80 * i).ms).fadeIn().slideX(begin: 0.1),
          );
        }),
      ],
    );
  }

  Widget _buildMembersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Squad Members',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFE5E5E5),
                offset: Offset(0, 5),
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: List.generate(_members.length, (i) {
              final m = _members[i];
              final isYou = m.name == 'You';
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isYou ? AppColors.primaryContainer.withOpacity(0.15) : null,
                  borderRadius: i == 0
                      ? const BorderRadius.vertical(top: Radius.circular(18))
                      : i == _members.length - 1
                          ? const BorderRadius.vertical(bottom: Radius.circular(18))
                          : BorderRadius.zero,
                  border: i < _members.length - 1
                      ? const Border(
                          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    // Rank number
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${i + 1}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: i < 3
                              ? [
                                  const Color(0xFFDAA520),
                                  const Color(0xFF9E9E9E),
                                  const Color(0xFFCD7F32),
                                ][i]
                              : AppColors.outlineVariant,
                        ),
                      ),
                    ),
                    // Avatar
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: m.color.withOpacity(0.15),
                          child: Text(
                            m.name[0],
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: m.color,
                            ),
                          ),
                        ),
                        if (m.isOnline)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: const Color(0xFF22c55e),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Name + role
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                m.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isYou ? AppColors.primary : AppColors.onSurface,
                                ),
                              ),
                              if (isYou) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'YOU',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            m.role,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 11,
                              color: AppColors.outlineVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // XP
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${_formatNum(m.xp)} XP',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 16,
                          color: const Color(0xFF22c55e),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate(delay: (60 * i).ms).fadeIn().slideX(begin: 0.08);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityFeed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ..._activityFeed.asMap().entries.map((e) {
          final i = e.key;
          final a = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
                  ),
                  child: Icon(a.icon, size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${a.who} ',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                              ),
                            ),
                            TextSpan(
                              text: a.action,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        a.time,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          color: AppColors.outlineVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).animate(delay: (50 * i).ms).fadeIn(),
          );
        }),
      ],
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: const Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TactileButton(
              onTap: () {
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Challenge sent to squad! 💪',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              color: AppColors.primary,
              shadowColor: AppColors.primaryDim,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Challenge Squad',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          TactileIconButton(
            onTap: () => _showInviteSheet(context),
            color: AppColors.surfaceContainerLowest,
            shadowColor: const Color(0xFFE5E5E5),
            border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
            child: const Icon(Icons.person_add_rounded, color: AppColors.primary, size: 22),
          ),
        ],
      ),
    );
  }

  void _showInviteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Invite to Squad',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: AppColors.outlineVariant),
                  const SizedBox(width: 10),
                  Text(
                    'Search friends…',
                    style: GoogleFonts.beVietnamPro(
                      color: AppColors.outlineVariant,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TactileButton(
              onTap: () => Navigator.pop(context),
              color: AppColors.primary,
              shadowColor: AppColors.primaryDim,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: Text(
                    'Send Invite Link',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  String _formatNum(num value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toString();
  }
}

// ── Data models ──────────────────────────────────────────────────────────────

class _Member {
  final String name;
  final int xp;
  final String? avatar;
  final bool isOnline;
  final String role;
  final Color color;
  const _Member(this.name, this.xp, this.avatar, this.isOnline, this.role, this.color);
}

class _SquadChallenge {
  final String name;
  final num current;
  final num goal;
  final Color color;
  final IconData icon;
  const _SquadChallenge(this.name, this.current, this.goal, this.color, this.icon);
}

class _Activity {
  final String who;
  final String action;
  final String time;
  final IconData icon;
  const _Activity(this.who, this.action, this.time, this.icon);
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatPill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ── New Challenge Sheet ───────────────────────────────────────────────────────

class _NewChallengeSheet extends StatefulWidget {
  const _NewChallengeSheet();

  @override
  State<_NewChallengeSheet> createState() => _NewChallengeSheetState();
}

class _NewChallengeSheetState extends State<_NewChallengeSheet> {
  int _selectedType = 0;
  int _selectedDuration = 1;

  static const _types = [
    (Icons.fitness_center_rounded, 'Pushup Battle', AppColors.primary),
    (Icons.directions_run_rounded, 'Step Race', AppColors.secondary),
    (Icons.self_improvement_rounded, 'Plank Off', AppColors.tertiary),
    (Icons.sports_gymnastics_rounded, 'Squat War', AppColors.errorContainer),
  ];
  static const _durations = ['3 days', '7 days', '14 days', '30 days'];

  @override
  Widget build(BuildContext context) {
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
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'NEW SQUAD CHALLENGE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11, fontWeight: FontWeight.w900,
              color: AppColors.onSurfaceVariant, letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text('Challenge Type', style: GoogleFonts.plusJakartaSans(
            fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface,
          )),
          const SizedBox(height: 10),
          Row(
            children: _types.asMap().entries.map((e) {
              final sel = _selectedType == e.key;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: e.key < _types.length - 1 ? 8 : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: sel ? e.value.$3.withAlpha(20) : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: sel ? e.value.$3 : AppColors.outlineVariant.withAlpha(60),
                          width: sel ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(e.value.$1, color: sel ? e.value.$3 : AppColors.onSurfaceVariant, size: 22),
                          const SizedBox(height: 4),
                          Text(
                            e.value.$2.split(' ').first,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9, fontWeight: FontWeight.w800,
                              color: sel ? e.value.$3 : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text('Duration', style: GoogleFonts.plusJakartaSans(
            fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface,
          )),
          const SizedBox(height: 10),
          Row(
            children: _durations.asMap().entries.map((e) {
              final sel = _selectedDuration == e.key;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: e.key < _durations.length - 1 ? 8 : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDuration = e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primaryContainer.withAlpha(40) : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: sel ? AppColors.primary : AppColors.outlineVariant.withAlpha(60),
                          width: sel ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        e.value,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, fontWeight: FontWeight.w800,
                          color: sel ? AppColors.primary : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          TactileButton(
            color: AppColors.primary,
            shadowColor: AppColors.primaryDim,
            padding: const EdgeInsets.symmetric(vertical: 16),
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${_types[_selectedType].$2} challenge sent to Iron Wolves! 🏆',
                  ),
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'SEND CHALLENGE TO SQUAD',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
