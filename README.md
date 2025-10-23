# Magic Tile 🎮

A beautiful and addictive **Magic Tile** game built with Flutter! Also known as "Don't Tap the White Tile" or "Piano Tiles", this game challenges your reflexes and coordination.

## 🎯 Game Description

Magic Tile is a fast-paced arcade game where tiles continuously scroll down the screen. Your objective is simple but challenging:
- **Tap the BLACK tiles** as they appear
- **Don't tap the WHITE tiles**
- **Don't miss any BLACK tiles**
- The speed increases as you progress!

## ✨ Features

- 🎨 **Beautiful UI** with gradient backgrounds and smooth animations
- 📱 **Portrait-only mode** for optimal gaming experience
- 🎭 **Three game states**: Menu, Playing, and Game Over
- 💯 **Score tracking** with animated score display
- ⚡ **Progressive difficulty** - speed increases as you play
- 🎬 **Smooth animations** including:
  - Pulsing play button
  - Fade-in/scale transitions
  - Check mark animations on tapped tiles
  - Animated score updates
- 🎨 **Visual polish**:
  - Gradient backgrounds
  - Shadow effects
  - Icon indicators
  - Responsive touch feedback

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device

### Installation

1. **Clone the repository** (or navigate to the project directory)
   ```bash
   cd magic_tile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🎮 How to Play

1. **Start the game** by tapping the PLAY button on the menu screen
2. **Tap the black tiles** as they scroll down the screen
3. **Avoid tapping white tiles** - this ends the game immediately
4. **Don't miss any black tiles** - missing a black tile also ends the game
5. **Challenge yourself** to beat your high score!

## 🏗️ Project Structure

```
lib/
├── main.dart                   # App entry point and main navigation
├── models/
│   └── tile.dart              # Tile and TileRow data models
├── game/
│   └── game_controller.dart   # Game logic and state management
└── screens/
    ├── menu_screen.dart       # Main menu UI
    ├── game_screen.dart       # Gameplay screen with tile grid
    └── game_over_screen.dart  # Game over screen with score
```

## 🎨 Technical Highlights

### Game Architecture
- **State Management**: Uses ChangeNotifier for reactive state updates
- **Game Loop**: Timer-based game loop running at ~60 FPS (16ms intervals)
- **Progressive Difficulty**: Speed increases by 0.001 pixels per frame
- **Responsive Design**: Adapts to different screen sizes

### Key Components

1. **GameController**: Manages game state, tile generation, movement, and scoring
2. **TileRow**: Represents a row of 4 tiles with one active (black) tile
3. **Custom Painter**: GridPainter for visual grid lines
4. **Animations**: Pulse, fade, scale, and transition animations throughout

## 🛠️ Development

### Key Technologies
- **Flutter 3.8+**: Cross-platform UI framework
- **Material Design 3**: Modern UI components
- **Custom Animations**: AnimationController and Tween animations

### Game Mechanics
- 4 columns of tiles
- 100px tile height
- Initial speed: 2.0 pixels/frame
- Speed increment: 0.001 pixels/frame
- Tiles scroll continuously downward

## 📱 Platform Support

This game is built with Flutter and supports:
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🎯 Future Enhancements

Potential features to add:
- 🏆 High score persistence
- 🎵 Sound effects and background music
- 🎨 Multiple themes/color schemes
- 🏅 Achievement system
- 📊 Statistics tracking
- 👥 Multiplayer mode
- 🎼 Different game modes (classic, zen, rush)

## 📄 License

This project is created for educational and entertainment purposes.

## 🤝 Contributing

Feel free to fork this project and add your own enhancements!

---

**Enjoy the game and try to beat your high score!** 🎉
