import 'dart:math';
import 'package:flutter/material.dart';
import '../models/tile.dart';
import 'package:flutter/scheduler.dart';

enum GameState { menu, playing, gameOver }

// --- Constants ---
const double _kTileHeight = 100.0;       // Assumed height of a tile row
const int _kInitialRowCount = 8;        // Rows to fill the screen at start
const int _kMaxRowBuffer = 40;          // Max rows to keep in memory
// Speeds are expressed in pixels per second for smooth, time-based movement
const double _kInitialGameSpeed = 240.0; // ~4 px/frame * 60fps
const double _kGameSpeedIncrement = 3.0; // px/sec increase per second (small acceleration)

class GameController extends ChangeNotifier {
  GameState _gameState = GameState.menu;
  final List<TileRow> _rows = [];
  final Map<int, TileRow> _rowMap = {}; // For O(1) lookups
  int _score = 0;
  double _scrollOffset = 0.0;
  // Use a Ticker to sync updates to the display refresh for smooth motion
  Ticker? _ticker;
  Duration? _lastTick;
  final Random _random = Random();
  double _gameSpeed = _kInitialGameSpeed; // pixels per second
  int _rowCounter = 0;

  GameState get gameState => _gameState;
  List<TileRow> get rows => _rows;
  int get score => _score;
  double get scrollOffset => _scrollOffset;

  void startGame() {
    _gameState = GameState.playing;
    _score = 0;
    _scrollOffset = 0.0;
    _gameSpeed = _kInitialGameSpeed;
    _rowCounter = 0;
    _rows.clear();
    _rowMap.clear(); // Clear the map

    // Initialize with rows to fill the screen
    for (int i = 0; i < _kInitialRowCount; i++) {
      _addNewRow();
    }

    _startGameLoop();
    notifyListeners();
  }

  void _startGameLoop() {
    // stop any existing ticker
    _ticker?.dispose();
    _lastTick = null;
    _ticker = Ticker((elapsed) {
      if (_gameState != GameState.playing) {
        _ticker?.stop();
        return;
      }
      _onTick(elapsed);
    });
    _ticker!.start();
  }

  void _onTick(Duration elapsed) {
    // Calculate delta since last tick in seconds
    final last = _lastTick ?? elapsed;
    final delta = (elapsed - last).inMicroseconds / 1e6;
    _lastTick = elapsed;

    if (delta <= 0) return;

    // Update scroll using delta-time for smoothness
    _scrollOffset += _gameSpeed * delta;
    // Small speed-up proportional to elapsed time
    _gameSpeed += _kGameSpeedIncrement * delta;

    // Add new rows when needed
    if (_scrollOffset >= _kTileHeight) {
      _scrollOffset -= _kTileHeight;
      _addNewRow();

      // Remove old rows that are off screen
      if (_rows.isNotEmpty && _rows.length > _kMaxRowBuffer) {
        final removedRow = _rows.removeAt(0);
        _rowMap.remove(removedRow.rowIndex); // Remove from map

        // Only check for miss after initial play
        if (_score > 0 && !removedRow.tiles[removedRow.activeTileIndex].isTapped) {
          _endGame();
          return;
        }
      }
    }

    notifyListeners();
  }

  // Legacy: _updateGame replaced by frame-synced _onTick

  void _addNewRow() {
    final activeTileIndex = _random.nextInt(4);
    final newRow = TileRow(
      rowIndex: _rowCounter++,
      activeTileIndex: activeTileIndex,
    );
    _rows.add(newRow);
    _rowMap[newRow.rowIndex] = newRow; // Add to map
  }

  void onTileTap(int rowIndex, int columnIndex) {
    if (_gameState != GameState.playing) return;

    // *** OPTIMIZATION ***
    // O(1) lookup instead of O(N) search
    final rowInList = _rowMap[rowIndex];

    if (rowInList == null) return; // Row not found or already removed

    // Check if tapped the correct tile (black tile)
    if (columnIndex == rowInList.activeTileIndex) {
      if (!rowInList.tiles[columnIndex].isTapped) {
        rowInList.tiles[columnIndex].isTapped = true;
        _score++;
        notifyListeners();
      }
    } else {
      // Tapped wrong tile - game over
      _endGame();
    }
  }

  void _endGame() {
    _gameState = GameState.gameOver;
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;
    notifyListeners();
  }

  void returnToMenu() {
    _gameState = GameState.menu;
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;
    super.dispose();
  }
}

// enum GameState { menu, playing, gameOver }

// class GameController extends ChangeNotifier {
//   GameState _gameState = GameState.menu;
//   final List<TileRow> _rows = [];
//   int _score = 0;
//   double _scrollOffset = 0.0;
//   Timer? _gameTimer;
//   final Random _random = Random();
//   double _gameSpeed = 2.0; // pixels per frame
//   int _rowCounter = 0;

//   GameState get gameState => _gameState;
//   List<TileRow> get rows => _rows;
//   int get score => _score;
//   double get scrollOffset => _scrollOffset;

//   void startGame() {
//     _gameState = GameState.playing;
//     _score = 0;
//     _scrollOffset = 0.0;
//     _gameSpeed = 4.0;
//     _rowCounter = 0;
//     _rows.clear();

//     // Initialize with rows to fill the screen
//     for (int i = 0; i < 8; i++) {
//       _addNewRow();
//     }

//     _startGameLoop();
//     notifyListeners();
//   }

//   void _startGameLoop() {
//     _gameTimer?.cancel();
//     _gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
//       if (_gameState != GameState.playing) {
//         timer.cancel();
//         return;
//       }

//       _updateGame();
//     });
//   }

//   void _updateGame() {
//     // Move tiles down
//     _scrollOffset += _gameSpeed;

//     // Increase speed gradually
//     _gameSpeed += 0.001;

//     // Add new rows when needed
//     if (_scrollOffset >= 100) {
//       _scrollOffset -= 100;
//       _addNewRow();

//       // Remove old rows that are off screen (at the bottom)
//       // Rows scroll from top to bottom, so we remove from the beginning
//       // But we only remove rows that have passed the bottom of the screen
//       if (_rows.isNotEmpty && _rows.length > 40) {
//         final removedRow = _rows.removeAt(0);
//         // Only check for miss after initial setup
//         if (_score > 0 && !removedRow.isTapped) {
//           _endGame();
//           return;
//         }
//       }
//     }

//     notifyListeners();
//   }

//   void _addNewRow() {
//     final activeTileIndex = _random.nextInt(4);
//     _rows.add(
//       TileRow(rowIndex: _rowCounter++, activeTileIndex: activeTileIndex),
//     );
//   }

//   void onTileTap(int rowIndex, int columnIndex) {
//     if (_gameState != GameState.playing) return;

//     // Find the row in the current visible rows
//     final rowInList = _rows.firstWhere(
//       (row) => row.rowIndex == rowIndex,
//       orElse: () => TileRow(rowIndex: -1, activeTileIndex: -1),
//     );

//     if (rowInList.rowIndex == -1) return;

//     // Check if tapped the correct tile (black tile)
//     if (columnIndex == rowInList.activeTileIndex) {
//       if (!rowInList.tiles[columnIndex].isTapped) {
//         rowInList.tiles[columnIndex].isTapped = true;
//         _score++;
//         notifyListeners();
//       }
//     } else {
//       // Tapped wrong tile - game over
//       _endGame();
//     }
//   }

//   void _endGame() {
//     _gameState = GameState.gameOver;
//     _gameTimer?.cancel();
//     notifyListeners();
//   }

//   void returnToMenu() {
//     _gameState = GameState.menu;
//     _gameTimer?.cancel();
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _gameTimer?.cancel();
//     super.dispose();
//   }
// }
