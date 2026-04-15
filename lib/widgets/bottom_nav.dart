import 'package:flutter/material.dart';

class FitLingoBottomNav extends StatelessWidget {
  const FitLingoBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 72,
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.route_rounded), label: 'Path'),
        NavigationDestination(
          icon: Icon(Icons.sports_gymnastics_rounded),
          label: 'Challenge',
        ),
        NavigationDestination(
          icon: Icon(Icons.groups_rounded),
          label: 'Social',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
