import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'data.dart'; // Import the data.dart file for saving/loading game data

class GamePage extends StatefulWidget {
  final String difficulty;
  GamePage({required this.difficulty});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late int totalTiles;
  late List<int> numbers;
  late List<int?> fixedPositions;
  int currentNumber = 1;
  int lives = 3;
  bool gameStarted = false;
  late Timer timer;
  int elapsedTime = 0;
  bool hideNumbers = false;
  int gamesPlayed = 0;
  int highestTime = 0;
  int minimumTime = 0;

  @override
  void initState() {
    super.initState();
    setGameDifficulty();
    generateTiles();
    loadGameData();
  }

  // Load the saved game data
  void loadGameData() async {
    try {
      Map<String, int> gameData = await GameData.loadGameData();
      setState(() {
        highestTime = gameData['highestTime']!;
        minimumTime = gameData['minimumTime']!;
        gamesPlayed = gameData['gamesPlayed']!;
      });
    } catch (e) {
      print("Error loading game data: $e");
    }
  }

  void setGameDifficulty() {
    switch (widget.difficulty) {
      case 'Easy':
        totalTiles = 5;
        break;
      case 'Medium':
        totalTiles = 8;
        break;
      case 'Hard':
        totalTiles = 12;
        break;
      default:
        totalTiles = 5;
    }
  }

  void generateTiles() {
    numbers = List.generate(totalTiles, (index) => index + 1);
    fixedPositions = List.filled(12, null);
    List<int> availableIndices = List.generate(12, (index) => index)..shuffle(Random());
    for (int i = 0; i < totalTiles; i++) {
      fixedPositions[availableIndices[i]] = numbers[i];
    }
  }

  void startGame() {
    setState(() {
      gameStarted = true;
      elapsedTime = 0;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime++;
      });
    });
  }

  void onTileTap(int number) {
    if (!gameStarted) return;
    if (!hideNumbers) {
      setState(() {
        hideNumbers = true;
      });
    }
    if (number == currentNumber) {
      setState(() {
        fixedPositions[fixedPositions.indexOf(number)] = null;
        currentNumber++;
      });
      if (currentNumber > totalTiles) {
        timer.cancel();
        saveGameData();
        showGameOverDialog("You Win! Time: $elapsedTime sec");
      }
    } else {
      setState(() {
        lives--;
      });
      if (lives == 0) {
        timer.cancel();
        saveGameData();
        showGameOverDialog("Game Over");
      }
    }
  }

  // Save the game data
  void saveGameData() async {
    if (elapsedTime > highestTime) highestTime = elapsedTime;
    if (minimumTime == 0 || elapsedTime < minimumTime) minimumTime = elapsedTime;

    gamesPlayed++;

    try {
      await GameData.saveGameData(highestTime, minimumTime, gamesPlayed, elapsedTime);
    } catch (e) {
      print("Error saving game data: $e");
    }
  }

  void showGameOverDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Highest Time: $highestTime sec"),
            Text("Minimum Time: $minimumTime sec"),
            Text("Games Played: $gamesPlayed"),
          ],
        ),
        actions: [
          // Restart button
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              restartGame();
            },
            child: Text("Restart"),
          ),
          // Back to menu button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to the previous screen (e.g., menu)
            },
            child: Text("Back to Menu"),
          ),
        ],
      ),
    );
  }

  // Restart the game
  void restartGame() {
    setState(() {
      gameStarted = false;
      currentNumber = 1;
      lives = 3;
      hideNumbers = false;
      generateTiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text("Memorix - ${widget.difficulty}")),
      body: GestureDetector(
        onTap: gameStarted ? null : startGame,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display lives
                  Row(
                    children: List.generate(lives, (index) => Icon(Icons.favorite, color: Colors.red)),
                  ),
                  SizedBox(width: 20), // Space between lives and timer
                  // Display elapsed time
                  if (gameStarted)
                    Text(
                      "Time: $elapsedTime sec",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            if (!gameStarted)
              Expanded(
                child: Center(
                  child: Text(
                    "Tap anywhere to start",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            else
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double tileSize = constraints.maxHeight / 4.5;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      padding: EdgeInsets.all(8),
                      itemCount: fixedPositions.length,
                      itemBuilder: (context, index) {
                        return fixedPositions[index] != null
                            ? GestureDetector(
                          onTap: () => onTileTap(fixedPositions[index]!),
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer, // Light color fill
                              border: Border.all(
                                color: colorScheme.onSurface, // 1dp outline
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                hideNumbers ? "?" : "${fixedPositions[index]}", // Black text color
                                style: TextStyle(
                                  fontSize: tileSize * 0.4,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurfaceVariant, // Text color
                                ),
                              ),
                            ),
                          ),
                        )
                            : SizedBox.shrink();
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}