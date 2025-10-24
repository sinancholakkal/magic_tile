import 'package:flutter/material.dart';
import 'package:magic_tile/state/high_score_state.dart';
import 'package:provider/provider.dart';
import '../game/game_controller.dart';

class GameOverScreen extends StatefulWidget {
  final GameController controller;

  const GameOverScreen({super.key, required this.controller});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool isNewHighScore = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();

    // Update high score after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final highScoreState = context.read<HighScoreState>();
      await highScoreState.updateHighScore(widget.controller.score);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final highScoreState = context.watch<HighScoreState>();
    final isNewHighScore = highScoreState.isNewHighScore;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade800, Colors.orange.shade900],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Game Over Text
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: const Text(
                      'GAME OVER',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(3, 3),
                            blurRadius: 8,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Score Display
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isNewHighScore
                                    ? 'NEW HIGH SCORE!'
                                    : 'Your Score',
                                style: TextStyle(
                                  fontSize: isNewHighScore ? 20 : 24,
                                  color: isNewHighScore
                                      ? Colors.yellow
                                      : Colors.white70,
                                  fontWeight: isNewHighScore
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              if (isNewHighScore) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.emoji_events,
                                  color: Colors.yellow,
                                  size: 24,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isNewHighScore
                                    ? Icons.emoji_events
                                    : Icons.star,
                                color: Colors.yellow,
                                size: 48,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${widget.controller.score}',
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                  color: isNewHighScore
                                      ? Colors.yellow
                                      : Colors.white,
                                  shadows: isNewHighScore
                                      ? [
                                          const Shadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 4,
                                            color: Colors.black54,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Play Again Button
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: ElevatedButton(
                      onPressed: widget.controller.startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red.shade800,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.replay, size: 28),
                          SizedBox(width: 10),
                          Text(
                            'PLAY AGAIN',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Menu Button
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: TextButton(
                      onPressed: widget.controller.returnToMenu,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'MENU',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
