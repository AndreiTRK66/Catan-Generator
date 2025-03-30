import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'tile.dart';
import 'hex_tile.dart';

void main() {
  runApp(const CatanMapGeneratorApp());
}

class CatanMapGeneratorApp extends StatelessWidget {
  const CatanMapGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catan Map Generator',
      theme: ThemeData.dark(),
      
      home: const CatanHomePage(),
    );
  }
}
class CatanHomePage extends StatefulWidget {
  const CatanHomePage({super.key});

  @override
  State<CatanHomePage> createState() => _CatanHomePageState();
}

class _CatanHomePageState extends State<CatanHomePage> {
  final List<String> resources = [
    'Forest',
    'Pasture',
    'Field',
    'Hill',
    'Mountain',
    'Desert',
  ];
  late List<Tile> generatedMap;

  @override
  void initState() {
    super.initState();
    _generateMap();
  }
  void _generateMap() {
    final resources = [
      'Forest','Forest','Forest','Forest',
      'Pasture','Pasture','Pasture','Pasture',
      'Field','Field','Field','Field',
      'Hill','Hill','Hill',
      'Mountain','Mountain','Mountain',
      'Desert'
    ];
    final numbers = [ 2, 3,3,4,4,5,5,6,6,
      7,7,8,8,9,9,10,10,11,11,12
    ];
    resources.shuffle();
    numbers.shuffle();

    List<Tile> tiles = [];
    int numberIndex = 0;
    for(var res in resources) {
      if(res == 'Desert'){
        tiles.add(Tile(resource: res, number: null));
      } else {
        tiles.add(Tile(resource: res, number: numbers[numberIndex]));
        numberIndex++;
      }
    }
    setState((){
      generatedMap = tiles;
    });
  }


  @override
  Widget build(BuildContext context) {
  const double tileSize = 100;
  const double horizontalSpacing = 105;
  const double verticalSpacing = 90;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generator Catan'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: SizedBox(
                width: 5*horizontalSpacing,
                height: 5*verticalSpacing,
                child: Stack(
                  children: List.generate(generatedMap.length, (index){
                    int row = 0;
                    int col = 0;
                    double offset = 0;

                    if(index < 3){
                      row = 0;
                      col = index;
                      offset = horizontalSpacing *1;
                    } else if(index < 7){
                      row = 1;
                      col = index -3;
                      offset = horizontalSpacing *0.5;
                    } else if(index < 12) {
                      row = 2;
                      col = index - 7;

                    } else if(index < 16){
                      row = 3;
                      col = index - 12;
                      offset = horizontalSpacing *0.5;
                    } else{
                      row = 4;
                      col = index - 16;
                      offset = horizontalSpacing *1;
                    }
                    //offset pentru pozitionare hexagonala
                    double dx = col * horizontalSpacing +offset;
                    double dy = row * verticalSpacing;

                    return Positioned (
                      left: dx, // pozitia pe x
                      top: dy, // pozitia pe Y
                      child: HexTile(tile:generatedMap[index], size: tileSize),
                    );
                  })
                )
              ),
            ),
          ),
          //buton de refacere
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Center(
                child: ElevatedButton(
                  onPressed:_generateMap,
                  child: const Text('Genereaza Harta'),
                )
              )
            )

          )
        ],
      ),
    );
  }
}
