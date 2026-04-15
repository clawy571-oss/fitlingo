import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/top_bar.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
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
      appBar: const FitLingoTopBar(),
      body: Column(
        children: [
          // Tab bar
          Container(
            color: AppColors.surfaceContainerLowest,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                    color: AppColors.outlineVariant, width: 2),
              ),
              child: TabBar(
                controller: _tab,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColors.primaryDim,
                        offset: Offset(0, 4),
                        blurRadius: 0),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 13, fontWeight: FontWeight.w900),
                unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 13, fontWeight: FontWeight.w700),
                labelColor: AppColors.onPrimary,
                unselectedLabelColor: AppColors.onSurfaceVariant,
                tabs: const [
                  Tab(text: 'GLOBAL'),
                  Tab(text: 'MY SQUAD'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _GlobalLeaderboard(),
                _SquadLeaderboard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Global Leaderboard ────────────────────────────────────────────────────────

class _GlobalLeaderboard extends StatelessWidget {
  static const _leaders = [
    _Leader('Maya "Thunder" Park', 24800, 58, AppColors.errorContainer),
    _Leader('Jake "Steel" Torres', 22400, 51, AppColors.secondaryContainer),
    _Leader('Alex "Flash" Chen', 21900, 49, AppColors.primaryContainer),
    _Leader('Sam "Rocket" Lee', 19200, 44, AppColors.tertiaryContainer),
    _Leader('Priya "Blaze" Singh', 18700, 42, AppColors.errorContainer),
    _Leader('Marcus "Iron" Wu', 17900, 40, AppColors.secondaryContainer),
    _Leader('Lola "Swift" Rivera', 16400, 37, AppColors.primaryContainer),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
      child: Column(
        children: [
          // Top 3 Podium
          _Podium(leaders: _leaders.take(3).toList())
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.05, end: 0),
          const SizedBox(height: 24),
          // Rest of the list
          ..._leaders.skip(3).toList().asMap().entries.map((e) {
            final i = e.key + 4;
            return _LeaderRow(
              rank: i,
              leader: e.value,
              isYou: i == 6,
              delay: (i - 3) * 60,
            );
          }),
          const SizedBox(height: 16),
          // Your rank card (if not visible)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary, width: 3),
              boxShadow: const [
                BoxShadow(
                    color: AppColors.primaryDim,
                    offset: Offset(0, 4),
                    blurRadius: 0),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '#12',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You • 12,400 XP',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                Text(
                  'LVL 28',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ).animate(delay: 500.ms).fadeIn(),
        ],
      ),
    );
  }
}

// ── Podium ────────────────────────────────────────────────────────────────────

class _Podium extends StatelessWidget {
  final List<_Leader> leaders;
  const _Podium({required this.leaders});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.tertiaryContainer.withOpacity(0.2),
            AppColors.background,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
            color: AppColors.tertiaryContainer, width: 3),
        boxShadow: const [
          BoxShadow(
              color: AppColors.tertiaryDim,
              offset: Offset(0, 6),
              blurRadius: 0),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events_rounded,
                  color: AppColors.tertiaryContainer, size: 24),
              const SizedBox(width: 6),
              Text(
                'TOP CHAMPIONS',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 2nd place
              Expanded(
                child: _PodiumBlock(
                  leader: leaders[1],
                  rank: 2,
                  height: 100,
                  medalColor: AppColors.outlineVariant,
                  delay: 100,
                ),
              ),
              // 1st place
              Expanded(
                child: _PodiumBlock(
                  leader: leaders[0],
                  rank: 1,
                  height: 130,
                  medalColor: AppColors.tertiaryContainer,
                  delay: 0,
                  isFirst: true,
                ),
              ),
              // 3rd place
              Expanded(
                child: _PodiumBlock(
                  leader: leaders[2],
                  rank: 3,
                  height: 80,
                  medalColor: const Color(0xFFcd7f32),
                  delay: 200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PodiumBlock extends StatelessWidget {
  final _Leader leader;
  final int rank;
  final double height;
  final Color medalColor;
  final int delay;
  final bool isFirst;

  const _PodiumBlock({
    required this.leader,
    required this.rank,
    required this.height,
    required this.medalColor,
    required this.delay,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Crown for 1st
        if (isFirst)
          Icon(Icons.workspace_premium_rounded,
              color: AppColors.tertiaryContainer, size: 28)
              .animate(onPlay: (c) => c.repeat())
              .moveY(begin: 0, end: -4, duration: 1200.ms)
              .then()
              .moveY(begin: -4, end: 0, duration: 1200.ms),
        const SizedBox(height: 4),
        // Avatar
        Container(
          width: isFirst ? 64 : 52,
          height: isFirst ? 64 : 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: leader.avatarColor,
            border: Border.all(color: medalColor, width: 3),
            boxShadow: [
              BoxShadow(
                  color: medalColor,
                  offset: const Offset(0, 4),
                  blurRadius: 0),
            ],
          ),
          child: Center(
            child: Text(
              leader.name[0],
              style: GoogleFonts.plusJakartaSans(
                fontSize: isFirst ? 26 : 20,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          leader.name.split(' ').first,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${(leader.xp / 1000).toStringAsFixed(1)}k',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 6),
        // Podium block
        Container(
          height: height,
          decoration: BoxDecoration(
            color: medalColor.withOpacity(0.25),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: medalColor, width: 2),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: medalColor,
              ),
            ),
          ),
        ),
      ],
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }
}

// ── Leader Row ─────────────────────────────────────────────────────────────

class _LeaderRow extends StatelessWidget {
  final int rank;
  final _Leader leader;
  final bool isYou;
  final int delay;

  const _LeaderRow({
    required this.rank,
    required this.leader,
    required this.isYou,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isYou
            ? AppColors.primaryContainer.withOpacity(0.25)
            : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isYou ? AppColors.primary : AppColors.surfaceContainerHigh,
          width: isYou ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isYou
                ? AppColors.primaryDim.withOpacity(0.4)
                : const Color(0x08000000),
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '#$rank',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: isYou
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: leader.avatarColor,
              border: Border.all(
                  color: AppColors.outlineVariant, width: 2),
            ),
            child: Center(
              child: Text(
                leader.name[0],
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isYou ? '${leader.name} (You)' : leader.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${(leader.xp / 1000).toStringAsFixed(1)}k XP',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'LVL ${leader.level}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn()
        .slideX(begin: 0.03, end: 0, duration: 350.ms);
  }
}

// ── Squad Leaderboard ─────────────────────────────────────────────────────────

class _SquadLeaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
      child: Column(
        children: [
          // Squad header card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.secondaryDim, width: 3),
              boxShadow: const [
                BoxShadow(
                    color: AppColors.secondaryDim,
                    offset: Offset(0, 6),
                    blurRadius: 0),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.3), width: 2),
                  ),
                  child: const Icon(Icons.shield_rounded,
                      color: Colors.white, size: 34),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Iron Wolves',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          )),
                      Text('12 members • Rank #4 globally',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.8),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn()
              .slideY(begin: 0.05, end: 0),
          const SizedBox(height: 24),
          ...[
            _Leader('Sarah "Swift" Miller', 9800, 35, AppColors.errorContainer),
            _Leader('Marcus "Iron" Wu', 11200, 40, AppColors.secondaryContainer),
            _Leader('You', 8400, 28, AppColors.primaryContainer),
            _Leader('Elena Rodriguez', 7400, 29, AppColors.tertiaryContainer),
            _Leader('James "Bear" Kim', 6200, 25, AppColors.surfaceContainerHigh),
          ]
              .asMap()
              .entries
              .map((e) => _LeaderRow(
                    rank: e.key + 1,
                    leader: e.value,
                    isYou: e.value.name == 'You',
                    delay: e.key * 60,
                  )),
        ],
      ),
    );
  }
}

// ── Model ─────────────────────────────────────────────────────────────────────

class _Leader {
  final String name;
  final int xp;
  final int level;
  final Color avatarColor;
  const _Leader(this.name, this.xp, this.level, this.avatarColor);
}
