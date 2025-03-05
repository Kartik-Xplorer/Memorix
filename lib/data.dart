import 'package:shared_preferences/shared_preferences.dart';

class GameData {
  static const String _highestTimeKey = 'highestTime';
  static const String _minimumTimeKey = 'minimumTime';
  static const String _gamesPlayedKey = 'gamesPlayed';
  static const String _gameTimesKey = 'gameTimes';

  // Save game data (highest time, minimum time, games played, and elapsed time)
  static Future<void> saveGameData(
      int highestTime, int minimumTime, int gamesPlayed, int elapsedTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get existing game times list or create a new one
    List<int> gameTimes = prefs.getStringList(_gameTimesKey)?.map((e) => int.parse(e)).toList() ?? [];

    // Add the current game time to the list
    gameTimes.add(elapsedTime);

    // Save the new game times list as a list of strings
    await prefs.setStringList(_gameTimesKey, gameTimes.map((e) => e.toString()).toList());

    // Save the highest time, minimum time, and number of games played
    await prefs.setInt(_highestTimeKey, highestTime);
    await prefs.setInt(_minimumTimeKey, minimumTime);
    await prefs.setInt(_gamesPlayedKey, gamesPlayed);
  }

  // Load game data (highest time, minimum time, games played, and all game times)
  static Future<Map<String, int>> loadGameData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int highestTime = prefs.getInt(_highestTimeKey) ?? 0;
    int minimumTime = prefs.getInt(_minimumTimeKey) ?? 0;
    int gamesPlayed = prefs.getInt(_gamesPlayedKey) ?? 0;

    // Return a Map with the appropriate types (int)
    return {
      'highestTime': highestTime,
      'minimumTime': minimumTime,
      'gamesPlayed': gamesPlayed,
    };
  }

  // Load game times (list of integers)
  static Future<List<int>> loadGameTimes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load and parse game times from SharedPreferences
    List<String> gameTimesString = prefs.getStringList(_gameTimesKey) ?? [];
    return gameTimesString.map((e) => int.parse(e)).toList();
  }
}
