import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/tactile_button.dart';
import '../widgets/top_bar.dart';
import 'leaderboard_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FitLingoTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        child: Column(
          children: [
            const SizedBox(height: 32),
            _ProfileHero().animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 28),
            _StatsBento()
                .animate(delay: 100.ms)
                .fadeIn()
                .slideY(begin: 0.05, end: 0),
            const SizedBox(height: 24),
            _AchievementsSection()
                .animate(delay: 200.ms)
                .fadeIn()
                .slideY(begin: 0.05, end: 0),
            const SizedBox(height: 24),
            _QuestCrewSection()
                .animate(delay: 300.ms)
                .fadeIn()
                .slideY(begin: 0.05, end: 0),
            const SizedBox(height: 24),
            _SettingsSection()
                .animate(delay: 400.ms)
                .fadeIn()
                .slideY(begin: 0.05, end: 0),
          ],
        ),
      ),
    );
  }
}

// ── Profile Hero ─────────────────────────────────────────────────────────────

class _ProfileHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Avatar ring
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer,
                border: Border.all(color: AppColors.primary, width: 4),
                boxShadow: const [
                  BoxShadow(
                      color: AppColors.primaryDim,
                      offset: Offset(0, 8),
                      blurRadius: 0),
                ],
              ),
              child: const Center(
                child: Icon(Icons.person_rounded,
                    size: 72, color: AppColors.primaryDim),
              ),
            ),
            // Level badge
            Positioned(
              bottom: -6,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryContainer,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                        color: AppColors.onTertiaryFixed, width: 3),
                    boxShadow: const [
                      BoxShadow(
                          color: AppColors.tertiaryDim,
                          offset: Offset(0, 4),
                          blurRadius: 0),
                    ],
                  ),
                  child: Text(
                    'LVL 28',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onTertiaryFixed,
                    ),
                  ),
                ),
              ),
            ),
            // Streak badge
            Positioned(
              top: 0,
              right: -8,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.errorContainer, width: 3),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColors.error,
                        offset: Offset(0, 4),
                        blurRadius: 0),
                  ],
                ),
                child: Icon(Icons.local_fire_department_rounded,
                    color: AppColors.errorContainer, size: 26),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Alex "The Flash" Chen',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Questing since July 2023',
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        // Edit profile button
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (_) => const _EditProfileSheet(),
            );
          },
          child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.outlineVariant, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_rounded,
                  size: 16, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                'Edit Profile',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        ),
      ],
    );
  }
}

// ── Stats Bento ───────────────────────────────────────────────────────────────

class _StatsBento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'CURRENT STREAK',
                icon: Icons.calendar_month_rounded,
                iconColor: AppColors.error,
                borderColor: AppColors.errorContainer,
                shadowColor: AppColors.error,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('12',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: AppColors.error,
                        )),
                    const SizedBox(width: 4),
                    Text('DAYS',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurfaceVariant,
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LeaderboardScreen(),
                      transitionsBuilder: (_, anim, __, child) =>
                          FadeTransition(opacity: anim, child: child),
                    ),
                  );
                },
                child: _StatCard(
                label: 'CURRENT LEAGUE',
                icon: Icons.military_tech_rounded,
                iconColor: AppColors.secondary,
                borderColor: AppColors.secondary,
                shadowColor: AppColors.secondaryDim,
                child: Row(
                  children: [
                    Text('Diamond',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.secondary,
                        )),
                    const Spacer(),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.secondary, width: 2),
                      ),
                      child: Center(
                        child: Text('#3',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.secondary,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _StatCard(
          label: 'TOTAL XP',
          icon: Icons.bolt_rounded,
          iconColor: AppColors.primary,
          borderColor: AppColors.primary,
          shadowColor: AppColors.primaryDim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('12.4k',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      )),
                  const SizedBox(width: 6),
                  Text('XP',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurfaceVariant,
                      )),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                      color: AppColors.outlineVariant, width: 2),
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.75,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixedDim,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text('75% to next level',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final Color shadowColor;
  final Widget child;

  const _StatCard({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.shadowColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 3),
        boxShadow: [
          BoxShadow(
              color: shadowColor,
              offset: const Offset(0, 6),
              blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1,
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

// ── Achievements ──────────────────────────────────────────────────────────────

class _AchievementsSection extends StatelessWidget {
  static const _achievements = [
    _Achievement('First Mile', Icons.directions_run_rounded,
        AppColors.tertiaryContainer, AppColors.tertiaryFixedDim, true),
    _Achievement('Night Owl', Icons.nightlight_rounded,
        AppColors.surfaceContainerLowest, AppColors.secondaryDim, true),
    _Achievement('Socializer', Icons.group_rounded,
        AppColors.surfaceContainerLowest, AppColors.primaryDim, true),
    _Achievement('Marathoner', Icons.workspace_premium_rounded,
        AppColors.surfaceContainerHigh, AppColors.outline, false),
    _Achievement('Peak Climber', Icons.landscape_rounded,
        AppColors.surfaceContainerHigh, AppColors.outline, false),
    _Achievement('On Fire', Icons.local_fire_department_rounded,
        AppColors.surfaceContainerLowest, AppColors.error, true),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.emoji_events_rounded,
                      color: AppColors.tertiary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Achievements',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LeaderboardScreen(),
                      transitionsBuilder: (_, anim, __, child) =>
                          FadeTransition(opacity: anim, child: child),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
            children: _achievements.asMap().entries.map((e) {
              return _AchievementBadge(
                achievement: e.value,
                delay: e.key * 60,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _Achievement {
  final String name;
  final IconData icon;
  final Color bg;
  final Color color;
  final bool earned;
  const _Achievement(this.name, this.icon, this.bg, this.color, this.earned);
}

class _AchievementBadge extends StatelessWidget {
  final _Achievement achievement;
  final int delay;

  const _AchievementBadge({required this.achievement, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: achievement.earned ? 1.0 : 0.4,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: achievement.bg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: achievement.color, width: 3),
              boxShadow: [
                BoxShadow(
                    color: achievement.color,
                    offset: const Offset(0, 4),
                    blurRadius: 0),
              ],
            ),
            child: Icon(achievement.icon,
                color: achievement.color, size: 36),
          ),
          const SizedBox(height: 6),
          Text(
            achievement.name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn()
        .scale(
            begin: const Offset(0.8, 0.8),
            duration: 400.ms,
            curve: Curves.easeOut);
  }
}

// ── Quest Crew ─────────────────────────────────────────────────────────────

class _QuestCrewSection extends StatelessWidget {
  static const _friends = [
    ('Sarah "Swift" Miller', '9.8k XP', 'LVL 35', true,
        AppColors.secondaryContainer),
    ('Marcus "Iron" Wu', '11.2k XP', 'LVL 40', false,
        AppColors.surfaceContainerHigh),
    ('Elena Rodriguez', '7.4k XP', 'LVL 29', true, AppColors.primaryContainer),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant, width: 3),
        boxShadow: const [
          BoxShadow(
              color: AppColors.outlineVariant,
              offset: Offset(0, 6),
              blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quest Crew',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                ),
              ),
              TactileButton(
                color: AppColors.primary,
                shadowColor: AppColors.primaryDim,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.person_add_rounded,
                        color: AppColors.onPrimary, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'ADD',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._friends.map((f) => _FriendRow(
                name: f.$1,
                xp: f.$2,
                level: f.$3,
                isOnline: f.$4,
                avatarColor: f.$5,
              )),
        ],
      ),
    );
  }
}

class _FriendRow extends StatelessWidget {
  final String name;
  final String xp;
  final String level;
  final bool isOnline;
  final Color avatarColor;

  const _FriendRow({
    required this.name,
    required this.xp,
    required this.level,
    required this.isOnline,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: avatarColor,
              border: Border.all(color: AppColors.outlineVariant, width: 2),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline
                            ? AppColors.primary
                            : AppColors.surfaceContainerHigh,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isOnline ? 'Online' : 'Offline',
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
                xp,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              Text(
                level,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Settings Section ──────────────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  static const _items = [
    ('Notifications', Icons.notifications_rounded, AppColors.secondary),
    ('Privacy', Icons.lock_rounded, AppColors.primary),
    ('Linked Devices', Icons.devices_rounded, AppColors.tertiary),
    ('Help & Feedback', Icons.help_rounded, AppColors.errorContainer),
  ];

  void _onSettingsTap(BuildContext context, String label) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _SettingsSheet(title: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppColors.surfaceContainerHigh, width: 3),
      ),
      child: Column(
        children: _items.asMap().entries.map((e) {
          final (label, icon, color) = e.value;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onSettingsTap(context, label),
              borderRadius: BorderRadius.circular(22),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        label,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        color: AppColors.outlineVariant, size: 22),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Settings Sheet ────────────────────────────────────────────────────────────

class _SettingsSheet extends StatelessWidget {
  final String title;
  const _SettingsSheet({required this.title});

  Map<String, List<(String, bool)>> get _options => {
    'Notifications': [
      ('Workout reminders', true),
      ('Challenge alerts', true),
      ('Squad activity', false),
      ('Weekly summary', true),
    ],
    'Privacy': [
      ('Show profile publicly', true),
      ('Share workout stats', true),
      ('Allow challenge requests', true),
      ('Show online status', false),
    ],
    'Linked Devices': [
      ('Apple Health', true),
      ('Apple Watch', false),
      ('Fitbit', false),
      ('Garmin', false),
    ],
    'Help & Feedback': [],
  };

  @override
  Widget build(BuildContext context) {
    final items = _options[title] ?? [];

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
            title.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11, fontWeight: FontWeight.w900,
              color: AppColors.onSurfaceVariant, letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          if (items.isNotEmpty)
            _ToggleList(items: items)
          else
            Column(
              children: [
                const Icon(Icons.help_outline_rounded, size: 48, color: AppColors.primary),
                const SizedBox(height: 12),
                Text(
                  'Need help? We\'re here for you.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Visit our help center or send us feedback directly.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14, color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                TactileButton(
                  color: AppColors.primary,
                  shadowColor: AppColors.primaryDim,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening help center...'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text('OPEN HELP CENTER', textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ToggleList extends StatefulWidget {
  final List<(String, bool)> items;
  const _ToggleList({required this.items});

  @override
  State<_ToggleList> createState() => _ToggleListState();
}

class _ToggleListState extends State<_ToggleList> {
  late final List<bool> _values;

  @override
  void initState() {
    super.initState();
    _values = widget.items.map((e) => e.$2).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceContainerHigh, width: 2),
      ),
      child: Column(
        children: widget.items.asMap().entries.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    e.value.$1,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15, fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: _values[e.key],
                  onChanged: (v) {
                    HapticFeedback.selectionClick();
                    setState(() => _values[e.key] = v);
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Edit Profile Sheet ────────────────────────────────────────────────────────

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet();

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _nameCtrl = TextEditingController(text: 'Alex "The Flash" Chen');
  final _usernameCtrl = TextEditingController(text: '@alexflash');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
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
            Text('EDIT PROFILE', style: GoogleFonts.plusJakartaSans(
              fontSize: 11, fontWeight: FontWeight.w900,
              color: AppColors.onSurfaceVariant, letterSpacing: 1.5,
            )),
            const SizedBox(height: 20),
            _InputField(label: 'Display Name', controller: _nameCtrl),
            const SizedBox(height: 12),
            _InputField(label: 'Username', controller: _usernameCtrl),
            const SizedBox(height: 24),
            TactileButton(
              color: AppColors.primary,
              shadowColor: AppColors.primaryDim,
              padding: const EdgeInsets.symmetric(vertical: 14),
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated! ✅'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: SizedBox(
                width: double.infinity,
                child: Text('SAVE CHANGES', textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _InputField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(
          fontSize: 12, fontWeight: FontWeight.w700,
          color: AppColors.onSurfaceVariant, letterSpacing: 0.5,
        )),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant, width: 2),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.beVietnamPro(
              fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.onSurface,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
