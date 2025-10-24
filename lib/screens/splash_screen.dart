import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _tileController;
  late AnimationController _fadeController;
  
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _tileAnimation;
  late Animation<double> _fadeAnimation;
  
  final List<Widget> _tiles = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _createTiles();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Tile animations
    _tileController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    
    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
    
    _tileAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _tileController, curve: Curves.easeInOut),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
  }

  void _createTiles() {
    // Create animated tiles for the background
    for (int i = 0; i < 12; i++) {
      _tiles.add(_AnimatedTile(
        index: i,
        animation: _tileAnimation,
      ));
    }
  }

  void _startAnimations() {
    // Start logo animation
    _logoController.forward();
    
    // Start tile animation with delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _tileController.forward();
    });
    
    // Start fade animation
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _fadeController.forward();
    });
  }


  @override
  void dispose() {
    _logoController.dispose();
    _tileController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade900,
              Colors.blue.shade900,
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background tiles
            ..._tiles,
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with animations
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Transform.rotate(
                          angle: _logoRotationAnimation.value * 0.1,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.grey.shade100,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.music_note,
                              size: 60,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Game title with fade animation
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Column(
                          children: [
                            const Text(
                              'MAGIC TILE',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 4,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 8,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Don't Tap the White Tile!",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                                fontStyle: FontStyle.italic,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Loading indicator
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Loading...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedTile extends StatelessWidget {
  final int index;
  final Animation<double> animation;

  const _AnimatedTile({
    required this.index,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final screenSize = MediaQuery.of(context).size;
        final tileSize = 40.0;
        final spacing = 60.0;
        
        // Calculate position based on index
        final row = index ~/ 4;
        final col = index % 4;
        final x = col * spacing + (screenSize.width - 3 * spacing) / 2;
        final y = row * spacing + 100;
        
        // Animation values
        final scale = 0.5 + (animation.value * 0.5);
        final opacity = (1.0 - animation.value).clamp(0.0, 1.0);
        final rotation = animation.value * 2 * 3.14159;
        
        return Positioned(
          left: x,
          top: y,
          child: Transform.scale(
            scale: scale,
            child: Transform.rotate(
              angle: rotation,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: tileSize,
                  height: tileSize,
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}