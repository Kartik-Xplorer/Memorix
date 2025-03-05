import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'data.dart';

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
  Timer? timer;
  int elapsedTime = 0;
  bool hideNumbers = false;
  int gamesPlayed = 0;
  int highestTime = 0;
  int minimumTime = 0;
  int wins = 0;
  int losses = 0;

  @override
  void initState() {
    super.initState();
    setGameDifficulty();
    generateTiles();
    loadGameData();
  }

  void loadGameData() async {
    try {
      Map<String, int> gameData = await GameData.loadGameData(widget.difficulty);
      setState(() {
        highestTime = gameData['highestTime'] ?? 0;
        minimumTime = gameData['minimumTime'] ?? 0;
        gamesPlayed = gameData['gamesPlayed'] ?? 0;
        wins = gameData['wins'] ?? 0;
        losses = gameData['losses'] ?? 0;
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
      hideNumbers = false;
    });
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        elapsedTime += 100;
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
        wins++;
        endGame("You Win! Time: ${formatTime(elapsedTime)}");
      }
    } else {
      setState(() {
        lives--;
      });
      if (lives == 0) {
        losses++;
        endGame("Game Over");
      }
    }
  }

  void endGame(String message) {
    timer?.cancel();
    saveGameData();
    showGameOverDialog(message);
  }

  void saveGameData() async {
    if (elapsedTime > highestTime) highestTime = elapsedTime;
    if (minimumTime == 0 || elapsedTime < minimumTime) minimumTime = elapsedTime;
    gamesPlayed++;
    try {
      await GameData.saveGameData(widget.difficulty, highestTime, minimumTime, gamesPlayed, elapsedTime, wins, losses);
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
            Text("Highest Time: ${formatTime(highestTime)}"),
            Text("Minimum Time: ${formatTime(minimumTime)}"),
            Text("Games Played: $gamesPlayed"),
            Text("Wins: $wins"),
            Text("Losses: $losses"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              restartGame();
            },
            child: Text("Restart"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Back to Menu"),
          ),
        ],
      ),
    );
  }

  void restartGame() {
    setState(() {
      gameStarted = false;
      currentNumber = 1;
      lives = 3;
      hideNumbers = false;
      generateTiles();
    });
  }

  String formatTime(int time) {
    return time >= 1000 ? "${(time / 1000).toStringAsFixed(2)} sec" : "$time ms";
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
                  Row(
                    children: List.generate(lives, (index) => Icon(Icons.favorite, color: Colors.red)),
                  ),
                  SizedBox(width: 20),
                  if (gameStarted)
                    Text(
                      "Time: ${formatTime(elapsedTime)}",
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
                child: GridView.builder(
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
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            hideNumbers ? "?" : "${fixedPositions[index]}",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                        : SizedBox.shrink();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}