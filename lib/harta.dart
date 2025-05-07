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
  bool checkboxValue1 = false;
  bool checkboxValue2 = true;
  bool checkboxValue3 = true;
  bool checkboxValue4 = true;

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
  List<PlacedTile> generatedList = [];
  List<PlacedTile> finalPlacedTile = [];
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

      int count = 0;
      while (count < 1000000) {
        resourceCopy.shuffle();
        numberCopy.shuffle();
        List<PlacedTile> placedTile = [];
        int numberIndex = 0;
        int tileIndex = 0;

        for (var res in resourceCopy) {
          int row = 0;
          int col = 0;
          if (tileIndex < 3) {
            row = 0;
            col = tileIndex;
          } else if (tileIndex < 7) {
            row = 1;
            col = tileIndex - 3;
          } else if (tileIndex < 12) {
            row = 2;
            col = tileIndex - 7;
          } else if (tileIndex < 16) {
            row = 3;
            col = tileIndex - 12;
          } else {
            row = 4;
            col = tileIndex - 16;
          }
          if (res == Resource.desert) {
            placedTile.add(
              PlacedTile(
                tiles: Tile(resource: res, number: null),
                row: row,
                col: col,
              ),
            );
          } else {
            placedTile.add(
              PlacedTile(
                tiles: Tile(resource: res, number: numberCopy[numberIndex]),
                row: row,
                col: col,
              ),
            );

            numberIndex++;
          }
          tileIndex++;
        }
        if (isValidMap(placedTile)) {
          finalPlacedTile = placedTile;
          print('Count = $count');
          break;
        }
        count++;
      }
      setState(() {
        generatedList = finalPlacedTile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  bool isValidMap(List<PlacedTile> placedTile) {
    for (final tile in placedTile) {
      final currentNumber = tile.tiles.number;
      final currentResource = tile.tiles.resource;

      if (currentNumber == null) {
        continue;
      }
      final neighbors = getNeighbors(tile.row, tile.col, placedTile);
      for (final neighbor in neighbors) {
        final neighborNumber = neighbor.tiles.number;
        final neighborResource = neighbor.tiles.resource;

        if (neighborNumber == null) {
          continue;
        }
        if (currentNumber == 6 && neighborNumber == 6) {
          return false;
        }
        if (currentNumber == 8 && neighborNumber == 8) {
          return false;
        }
        if (!checkboxValue1) {
          if ((currentNumber == 8 && neighborNumber == 6) ||
              (currentNumber == 6 && neighborNumber == 8)) {
            return false;
          }
        }
        if (!checkboxValue2) {
          if ((currentNumber == 2 && neighborNumber == 12) ||
              (currentNumber == 12 && neighborNumber == 2)) {
            return false;
          }
        }
        if (!checkboxValue3) {
          if (currentNumber == neighborNumber) {
            return false;
          }
        }
        if (!checkboxValue4) {
          if (currentResource == neighborResource) {
            return false;
          }
        }
      }
    }

    return true;
  }

  List<PlacedTile> getNeighbors(int row, int col, List<PlacedTile> allTiles) {
    final List<PlacedTile> neighbors = [];
    final List<List<int>> offsets;

    if (row <= 1) {
      offsets = [
        [0, -1],
        [0, 1],
        [-1, -1],
        [-1, 0],
        [1, 0],
        [1, 1],
      ];
    } else if (row == 2) {
      offsets = [
        [0, -1],
        [0, 1],
        [-1, -1],
        [-1, 0],
        [1, -1],
        [1, 0],
      ];
    } else {
      offsets = [
        [0, -1],
        [0, 1],
        [-1, 0],
        [-1, 1],
        [1, -1],
        [1, 0],
      ];
    }
    for (final offset in offsets) {
      final neighborRow = row + offset[0];
      final neighborCol = col + offset[1];

      final match = allTiles.where(
        (tile) => tile.row == neighborRow && tile.col == neighborCol,
      );
      if (match.isNotEmpty) {
        neighbors.add(match.first);
      }
    }

    return neighbors;
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
                          tile: generatedList[index].tiles,
                          size: tileSize,
                        ),
                      );
                    }),
                    Positioned(
                      bottom: 30,
                      left: screenWidth / 6,
                      right: 0,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder:
                                        (context, setState) => AlertDialog(
                                          content: Column(
                                            children: [
                                              CheckboxListTile(
                                                title: const Text(
                                                  '6 & 8 Can Touch',
                                                ),
                                                value: checkboxValue1,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    checkboxValue1 = value!;
                                                  });
                                                },
                                              ),
                                              CheckboxListTile(
                                                title: const Text(
                                                  '2 & 12 Can Touch',
                                                ),
                                                value: checkboxValue2,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    checkboxValue2 = value!;
                                                  });
                                                },
                                              ),
                                              CheckboxListTile(
                                                title: const Text(
                                                  'Same Numbers Can Touch',
                                                ),
                                                value: checkboxValue3,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    checkboxValue3 = value!;
                                                  });
                                                },
                                              ),
                                              CheckboxListTile(
                                                title: const Text(
                                                  'Same Resources Can Touch',
                                                ),
                                                value: checkboxValue4,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    checkboxValue4 = value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                  );
                                },
                              );
                            },
                            child: const Text('      Options      '),
                          ),
                          ElevatedButton(
                            onPressed: _generateList,
                            child: const Text('Generate Map'),
                          ),
                        ],
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
