import 'package:flutter/material.dart';
import 'tile.dart';

class HexTile extends StatelessWidget {
  final Tile tile;
  final double size;

  const HexTile({super.key, required this.tile, this.size = 60});

  Color _getColor(){
    switch(tile.resource){
      case 'Forest':
        return Colors.green;
      case 'Pasture':
        return Colors.lightGreen;
      case 'Field':
        return Colors.yellow;
      case 'Hill':
        return Colors.red;
      case 'Mountain':
        return Colors.grey;
      case 'Desert':
        return Colors.brown;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HexPainter( color: _getColor()),
      child: SizedBox(
        width: size,
        height: size,
        child: FittedBox(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(
                    tile.resource,
                    style: const TextStyle(fontSize:8),
                    textAlign: TextAlign.center,
                  ),
                  if(tile.number != null)
                    Text('${tile.number}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    )
                ]
            )
        )

      )
    );
  }
}
class HexPainter extends CustomPainter{
  final Color color;
  HexPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    double w = size.width;
    double h = size.height;

    path.moveTo(w * 0.5, 0);
    path.lineTo(w,h*0.25);
    path.lineTo(w, h*0.75);
    path.lineTo(w*0.5,h);
    path.lineTo(0,h*0.75);
    path.lineTo(0,h*0.25);
    path.close();

    canvas.drawPath(path,paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}