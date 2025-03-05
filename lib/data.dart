import 'package:shared_preferences/shared_preferences.dart';

class GameData {
  static Future<void> saveGameData(String difficulty, int highestTime, int minimumTime, int gamesPlayed, int elapsedTime, int wins, int losses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${difficulty}_highestTime', highestTime);
    await prefs.setInt('${difficulty}_minimumTime', minimumTime);
    await prefs.setInt('${difficulty}_gamesPlayed', gamesPlayed);
    await prefs.setInt('${difficulty}_elapsedTime', elapsedTime);
    await prefs.setInt('${difficulty}_wins', wins);
    await prefs.setInt('${difficulty}_losses', losses);
  }

  static Future<Map<String, int>> loadGameData(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'highestTime': prefs.getInt('${difficulty}_highestTime') ?? 0,
      'minimumTime': prefs.getInt('${difficulty}_minimumTime') ?? 0,
      'gamesPlayed': prefs.getInt('${difficulty}_gamesPlayed') ?? 0,
      'elapsedTime': prefs.getInt('${difficulty}_elapsedTime') ?? 0,
      'wins': prefs.getInt('${difficulty}_wins') ?? 0,   // Added wins
      'losses': prefs.getInt('${difficulty}_losses') ?? 0 // Added losses
    };
  }

  static Future<void> incrementGamesPlayed(String difficulty, bool isWin) async {
    final prefs = await SharedPreferences.getInstance();
    int gamesPlayed = prefs.getInt('${difficulty}_gamesPlayed') ?? 0;
    int wins = prefs.getInt('${difficulty}_wins') ?? 0;
    int losses = prefs.getInt('${difficulty}_losses') ?? 0;

    await prefs.setInt('${difficulty}_gamesPlayed', gamesPlayed + 1);
    if (isWin) {
      await prefs.setInt('${difficulty}_wins', wins + 1);
    } else {
      await prefs.setInt('${difficulty}_losses', losses + 1);
    }
  }
}