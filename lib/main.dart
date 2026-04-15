import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'theme/app_theme.dart';
import 'models/real_exercise.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/social_screen.dart';
import 'screens/challenges_screen.dart';
import 'screens/onboarding_screen.dart';
import 'widgets/bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
  ));
  Animate.defaultDuration = 350.ms;
  // Pre-load exercise database in background so browse is instant
  ExerciseDatabase.instance.load();
  runApp(const FitLingoApp());
}

class FitLingoApp extends StatelessWidget {
  const FitLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitLingo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const _RootRouter(),
    );
  }
}

/// Routes between onboarding and the main app shell
class _RootRouter extends StatefulWidget {
  const _RootRouter();

  @override
  State<_RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends State<_RootRouter> {
  bool _onboardingDone = false;

  @override
  Widget build(BuildContext context) {
    if (!_onboardingDone) {
      return OnboardingScreen(
        onComplete: () => setState(() => _onboardingDone = true),
      );
    }
    return const MainShell();
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _screens = [
    HomeScreen(),
    ExploreScreen(),
    SocialScreen(),
    ChallengesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: FitLingoBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
