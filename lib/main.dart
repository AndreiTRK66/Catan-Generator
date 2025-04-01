import 'package:flutter/material.dart';
import 'package:harta_catan/tile.dart';
import 'package:harta_catan/hex_tile.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CatanHomePage(),
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
    'Grau', 'Grau', 'Grau', 'Grau',
    'Argila', 'Argila', 'Argila',
    'Piatra', 'Piatra', 'Piatra',
    'Lemn', 'Lemn', 'Lemn', 'Lemn',
    'Oaie', 'Oaie', 'Oaie', 'Oaie',
    'Desert'];
  final List<int> numbers = [2, 3, 3, 4, 4, 5, 5, 6, 6, 8, 8, 9, 9,
    10, 10, 11, 11, 12];
  List<Tile> generatedMap = [];

  @override
  void initState(){
    super.initState();
    _generateMap();
  }

  void _generateMap(){
    final resourceCopy = List<String>.from(resources);
    final numberCopy = List<int>.from(numbers);


    resourceCopy.shuffle();
    numberCopy.shuffle();
    List<Tile> tiles = [];
    int numberIndex = 0;
    for(var res in resourceCopy){
      if(res == 'Desert'){
        tiles.add(Tile(resource: 'Desert',number:null));
      } else {
        tiles.add(Tile(resource:res, number: numberCopy[numberIndex]));
        numberIndex++;
      }
    }
    setState((){
      generatedMap = tiles;
    });
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final tileSize = (screenWidth/6).clamp(89,140).toDouble();
    final horizontalSpacing = tileSize *0.92;
    final verticalSpacing = tileSize * 0.76;

    return Scaffold(
      appBar: AppBar(title: Text('Generator Catan',
      style: TextStyle(color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      ),
      ),
      body: generatedMap.isEmpty
      ?const Center(child:CircularProgressIndicator())
          :Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.white,
            child: Stack(
            children: [
              ...List.generate(generatedMap.length,(index){
                int row = 0;
                int col = 0;
                double offset = 0;
          
                if(index < 3){
                  row = 0;
                  col = index;
                  offset = horizontalSpacing * 1;
                }else if(index < 7){
                  row = 1;
                  col = index - 3;
                  offset = horizontalSpacing * 0.5;
                } else if(index < 12){
                  row = 2;
                  col = index - 7;
                  offset = 0;
                } else if(index <16){
                  row = 3;
                  col = index - 12;
                  offset = horizontalSpacing * 0.5;
                }else{
                  row = 4;
                  col = index - 16;
                  offset = horizontalSpacing * 1;
                }
                //calculam x si y (pozitii
                double dx = col * horizontalSpacing + offset;
                double dy = row * verticalSpacing;
          
                return Positioned(
                  left: dx,
                  top: dy,
                  child: HexTile(
                    tile: generatedMap[index],
                    size: tileSize,
                  ),
                );
              }),
              Positioned(
               bottom:30,
               left:0,
               right:0,
               child: Center(
                 child: ElevatedButton(
                     onPressed: _generateMap,
                     child: const Text('Genereaza Harta'),
                 )
               )
              )
            ],
          ),
        )
    );
  }
}

