import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../screens/profile_screen.dart';

class FitLingoTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBrand;
  final bool showProfile;

  const FitLingoTopBar({
    super.key,
    this.title,
    this.showBrand = true,
    this.showProfile = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 + MediaQuery.of(context).padding.top,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 3),
        ),
      ),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Brand / title
            Row(
              children: [
                Icon(Icons.local_fire_department_rounded,
                    color: AppColors.errorContainer, size: 28),
                const SizedBox(width: 4),
                Text(
                  showBrand ? 'FitLingo' : (title ?? ''),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            // Right side: stats + avatar
            Row(
              children: [
                // Stats chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.outlineVariant, width: 2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_fire_department_rounded,
                          color: AppColors.errorContainer, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        '12',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.diamond_rounded,
                          color: AppColors.tertiaryContainer, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        '500',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showProfile) ...[
                  const SizedBox(width: 10),
                  _ProfileAvatar(
                    onTap: () => _openProfile(context),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => const ProfileScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 280),
      ),
    );
  }
}

class _ProfileAvatar extends StatefulWidget {
  final VoidCallback onTap;
  const _ProfileAvatar({required this.onTap});

  @override
  State<_ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<_ProfileAvatar> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _pressed ? AppColors.primaryDim : AppColors.primary,
            width: 2.5,
          ),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primaryDim,
                    offset: const Offset(0, 3),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primaryContainer.withOpacity(0.4),
          child: Text(
            'T',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
