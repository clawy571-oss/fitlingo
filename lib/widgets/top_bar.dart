import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class FitlingoTopBar extends StatelessWidget implements PreferredSizeWidget {
  const FitlingoTopBar({
    super.key,
    this.title,
    this.subtitle,
    this.showBrand = false,
    this.showProfile = false,
  });

  final String? title;
  final String? subtitle;
  final bool showBrand;
  final bool showProfile;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 72,
      titleSpacing: 20,
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  showBrand ? 'FitLingo' : (title ?? 'FitLingo'),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          if (showProfile)
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceSoft,
              child: Icon(
                Icons.person_rounded,
                size: 18,
                color: AppColors.text,
              ),
            ),
        ],
      ),
    );
  }
}
