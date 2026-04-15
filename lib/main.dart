import 'package:flutter/material.dart';

import 'data/backend_service.dart';
import 'screens/challenges_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/social_screen.dart';
import 'state/fitlingo_store.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_nav.dart';

void main() {
  runApp(const FitLingoApp());
}

class FitLingoApp extends StatelessWidget {
  const FitLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitLingo',
      theme: AppTheme.theme,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late final FitlingoStore _store;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _store = FitlingoStore(BackendService());
    _store.initialize();
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FitlingoScope(
      store: _store,
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            HomeScreen(onOpenChallenge: () => setState(() => _index = 1)),
            const ChallengesScreen(),
            const SocialScreen(),
            const ProfileScreen(),
          ],
        ),
        bottomNavigationBar: FitLingoBottomNav(
          currentIndex: _index,
          onTap: (value) => setState(() => _index = value),
        ),
      ),
    );
  }
}
