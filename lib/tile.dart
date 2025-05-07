import 'package:harta_catan/constants/resource.dart';

class Tile {
  final Resource resource;
  final int? number;

  Tile({required this.resource, required this.number});
}

class PlacedTile {
  final Tile tiles;
  final int row;
  final int col;

  PlacedTile({required this.tiles, required this.row, required this.col});
}
