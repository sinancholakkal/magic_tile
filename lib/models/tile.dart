class Tile {
  final int row;
  final int column;
  bool isTapped;
  
  Tile({
    required this.row,
    required this.column,
    this.isTapped = false,
  });
}

class TileRow {
  final int rowIndex;
  final List<Tile> tiles;
  final int activeTileIndex; // Which tile should be tapped (black tile)
  
  TileRow({
    required this.rowIndex,
    required this.activeTileIndex,
  }) : tiles = List.generate(
          4,
          (index) => Tile(row: rowIndex, column: index),
        );
  
  bool get isTapped => tiles[activeTileIndex].isTapped;
}

