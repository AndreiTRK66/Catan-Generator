import 'package:flutter/material.dart';
import 'package:harta_catan/tile.dart';

import 'constants/resource.dart';

class HexTile extends StatelessWidget {
  final Tile tile;
  final double size;
  const HexTile({super.key, required this.tile, required this.size});

  String _getImagePath() {
    switch (tile.resource) {
      case Resource.piatra:
        return 'assets/piatra.png';
      case Resource.argila:
        return 'assets/argila.png';
      case Resource.grau:
        return 'assets/grau.png';
      case Resource.lemn:
        return 'assets/lemn.png';
      case Resource.oaie:
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
            padding: const EdgeInsets.all(8), //spatiu cifra-margne
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: Text(
              tile.number.toString(),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color:
                    (tile.number == 8 || tile.number == 6)
                        ? Colors.red
                        : Colors.black,
              ),
            ),
          ),
      ],
    );
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
