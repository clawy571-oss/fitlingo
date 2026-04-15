import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class FitLingoBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FitLingoBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(icon: Icons.fitness_center_rounded, label: 'Quest'),
      _NavItem(icon: Icons.explore_rounded, label: 'Explore'),
      _NavItem(icon: Icons.groups_rounded, label: 'Social'),
      _NavItem(icon: Icons.bolt_rounded, label: 'Challenges'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: const Border(
          top: BorderSide(color: Color(0xFFE5E5E5), width: 3),
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, -4),
            blurRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final active = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: active
                      ? BoxDecoration(
                          color: AppColors.primaryContainer.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryDim,
                              offset: const Offset(0, 4),
                              blurRadius: 0,
                            ),
                          ],
                        )
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedScale(
                        scale: active ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.elasticOut,
                        child: Icon(
                          items[i].icon,
                          size: 26,
                          color: active
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: active
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
