import 'dart:developer';

import 'package:flutter/material.dart';
import '../game/game_controller.dart';

class GameScreen extends StatelessWidget {
  final GameController controller;
  
  const GameScreen({super.key, required this.controller});
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tileWidth = screenWidth / 4;
    const tileHeight = 100.0;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Game grid
            Column(
              children: [
                // Score display with gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.shade700,
                        Colors.blue.shade700,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 32,
                      ),
                      const SizedBox(width: 10),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Text(
                          '${controller.score}',
                          key: ValueKey<int>(controller.score),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Tile grid
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ClipRect(
                        child: Stack(
                          children: [
                            // Background grid lines
                            CustomPaint(
                              size: Size(screenWidth, constraints.maxHeight),
                              painter: GridPainter(),
                            ),
                            // Tiles
                            Positioned.fill(
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: ValueListenableBuilder<double>(
                                  valueListenable: controller.scrollNotifier,
                                  child: RowsList(
                                    controller: controller,
                                    tileWidth: tileWidth,
                                    tileHeight: tileHeight,
                                  ),
                                  builder: (context, scrollValue, child) {
                                    return Transform.translate(
                                      offset: Offset(0, -constraints.maxHeight + scrollValue),
                                      child: child,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget that builds the column of rows and only rebuilds when the controller
// notifies (i.e., when rows are added/removed or tapped). This prevents the
// heavy tile rebuild on every frame while the scroll notifier updates.
class RowsList extends StatelessWidget {
  final GameController controller;
  final double tileWidth;
  final double tileHeight;

  const RowsList({Key? key, required this.controller, required this.tileWidth, required this.tileHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Column(
          children: controller.rows.reversed.map((row) {
            return SizedBox(
              key: ValueKey<int>(row.rowIndex),
              height: tileHeight,
              child: Row(
                children: List.generate(4, (columnIndex) {
                  final isActiveTile = columnIndex == row.activeTileIndex;
                  final isTapped = row.tiles[columnIndex].isTapped;

                  return GestureDetector(
                    onTap: () {
                      controller.onTileTap(
                        row.rowIndex,
                        columnIndex,
                      );
                      log('Tapped');
                    },
                    child: AnimatedContainer(
                      key: ValueKey<String>('tile-${row.rowIndex}-$columnIndex'),
                      duration: const Duration(milliseconds: 150),
                      width: tileWidth,
                      height: tileHeight,
                      decoration: BoxDecoration(
                        gradient: isActiveTile
                            ? (isTapped
                                ? LinearGradient(
                                    colors: [
                                      Colors.grey.shade600,
                                      Colors.grey.shade800,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.black87,
                                      Colors.black,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ))
                            : null,
                        color: isActiveTile ? null : Colors.white,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 0.5,
                        ),
                        boxShadow: isActiveTile && !isTapped
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: isTapped && isActiveTile
                          ? TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 200),
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                );
                              },
                            )
                          : const SizedBox.shrink(),
                    ),
                  );
                }),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5;
    
    // Draw vertical lines
    for (int i = 1; i < 4; i++) {
      final x = size.width / 4 * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

