import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magic_tile/screens/splash_screen.dart';
import 'package:magic_tile/screens/onboarding_screen.dart';
import 'package:magic_tile/state/high_score_state.dart';
import 'game/game_controller.dart';
import 'screens/menu_screen.dart';
import 'screens/game_screen.dart';
import 'screens/game_over_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set portrait orientation only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MagicTileApp());
}

class MagicTileApp extends StatelessWidget {
  const MagicTileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HighScoreState()),
      ],
      child: MaterialApp(
        title: 'Magic Tile',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AppInitializer(),
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isLoading = true;
  bool _hasSeenOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  void _checkOnboardingStatus() async {
    // Wait for splash screen to complete (1500ms)
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    
    setState(() {
      _hasSeenOnboarding = hasSeenOnboarding;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }
    
    if (!_hasSeenOnboarding) {
      return const OnboardingScreen();
    }
    
    return const GameHome();
  }
}

class GameHome extends StatefulWidget {
  const GameHome({super.key});

  @override
  State<GameHome> createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> {
  late GameController _controller;

  @override
  void initState() {
    super.initState();
  //  HighScoreService.resetHighScore();
    _controller = GameController();
    _controller.addListener(_onGameStateChanged);
  }

  void _onGameStateChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onGameStateChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_controller.gameState) {
      case GameState.menu:
        return MenuScreen(controller: _controller);
      case GameState.playing:
        return GameScreen(controller: _controller);
      case GameState.gameOver:
        return GameOverScreen(controller: _controller);
    }
  }
}
