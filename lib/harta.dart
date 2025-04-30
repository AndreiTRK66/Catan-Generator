import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harta_catan/constants/resource.dart';
import 'package:harta_catan/constants/routes.dart';
import 'package:harta_catan/tile.dart';
import 'package:harta_catan/utilities/show_logout.dart';

import 'hex_tile.dart';

class CatanHomePage extends StatefulWidget {
  const CatanHomePage({super.key});

  @override
  State<CatanHomePage> createState() => _CatanHomePageState();
}

class _CatanHomePageState extends State<CatanHomePage> {
  bool _isLoading = true;
  bool _hasError = false;

  final List<Resource> resources = [
    ...List.filled(4, Resource.grau),
    ...List.filled(4, Resource.oaie),
    ...List.filled(4, Resource.lemn),
    ...List.filled(3, Resource.argila),
    ...List.filled(3, Resource.piatra),
    Resource.desert,
  ];
  final List<int> numbers = [
    2,
    3,
    3,
    4,
    4,
    5,
    5,
    6,
    6,
    8,
    8,
    9,
    9,
    10,
    10,
    11,
    11,
    12,
  ];
  List<Tile> generatedList = [];

  @override
  void initState() {
    super.initState();
    _generateList();
  }

  void _generateList() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final resourceCopy = List<Resource>.from(resources);
      final numberCopy = List<int>.from(numbers);

      resourceCopy.shuffle();
      numberCopy.shuffle();
      List<Tile> tiles = [];
      int numberIndex = 0;
      for (var res in resourceCopy) {
        if (res == Resource.desert) {
          tiles.add(Tile(resource: res, number: null));
        } else {
          tiles.add(Tile(resource: res, number: numberCopy[numberIndex]));
          numberIndex++;
        }
      }
      setState(() {
        generatedList = tiles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final tileSize = (screenWidth / 6).clamp(lowerLimit, upperLimit).toDouble();
    final horizontalSpacing = tileSize * offsetHorizontalSpacing;
    final verticalSpacing = tileSize * offsetVerticalSpacing;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Generator Catan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (_hasError) {
              return const Center(child: Text('Something went wrong'));
            } else {
              return Container(
                width: screenWidth,
                height: screenHeight,
                color: Colors.white,
                child: Stack(
                  children: [
                    ...List.generate(generatedList.length, (index) {
                      int row = 0;
                      int col = 0;
                      double offset = 0;

                      if (index < 3) {
                        row = 0;
                        col = index;
                        offset = horizontalSpacing * 1;
                      } else if (index < 7) {
                        row = 1;
                        col = index - 3;
                        offset = horizontalSpacing * 0.5;
                      } else if (index < 12) {
                        row = 2;
                        col = index - 7;
                        offset = 0;
                      } else if (index < 16) {
                        row = 3;
                        col = index - 12;
                        offset = horizontalSpacing * 0.5;
                      } else {
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
                          tile: generatedList[index],
                          size: tileSize,
                        ),
                      );
                    }),
                    Positioned(
                      bottom: 30,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: _generateList,
                          child: const Text('Genereaza Harta'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
