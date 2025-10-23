import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game/game_controller.dart';
import 'screens/menu_screen.dart';
import 'screens/game_screen.dart';
import 'screens/game_over_screen.dart';

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
    return MaterialApp(
      title: 'Magic Tile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GameHome(),
    );
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
