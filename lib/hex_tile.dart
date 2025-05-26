import 'package:flutter/material.dart';
import 'package:harta_catan/tile.dart';

import 'constants/resource.dart';

class HexTile extends StatelessWidget {
  final Tile tile;
  final double size;
  const HexTile({super.key, required this.tile, required this.size});

  String _getImagePath() {
    switch (tile.resource) {
      case Resource.rock:
        return 'assets/piatra.png';
      case Resource.brick:
        return 'assets/argila.png';
      case Resource.wheat:
        return 'assets/grau.png';
      case Resource.wood:
        return 'assets/lemn.png';
      case Resource.sheep:
        return 'assets/oaie.png';
      case Resource.desert:
        return 'assets/desert.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: HexClipper(),
          child: Image.asset(
            _getImagePath(),
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
        if (tile.number != null)
          Container(
            height: size / numberSizeDiv,
            width: size / numberSizeDiv,
            padding: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFF9C4),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    tile.number.toString(),
                    style: TextStyle(
                      fontSize: size * numberFontSizeDiv,
                      fontWeight: FontWeight.w900,
                      height: numberHeight,
                      fontFamily: 'Roboto',
                      color:
                          (tile.number == 8 || tile.number == 6)
                              ? Colors.red
                              : Colors.black,
                    ),
                  ),
                ),

                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    '•' * _getDotCount(tile.number),
                    style: TextStyle(
                      fontSize: size * dotFontSizeDiv,
                      height: numberHeight,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color:
                          (tile.number == 8 || tile.number == 6)
                              ? Colors.red
                              : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  int _getDotCount(int? number) {
    switch (number) {
      case 6:
      case 8:
        return 5;
      case 5:
      case 9:
        return 4;
      case 4:
      case 10:
        return 3;
      case 3:
      case 11:
        return 2;
      case 2:
      case 12:
        return 1;
      default:
        return 0;
    }
  }
}

class HexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, 0.25 * size.height);
    path.lineTo(size.width, 0.75 * size.height);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, 0.75 * size.height);
    path.lineTo(0, 0.25 * size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
