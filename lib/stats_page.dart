import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'data.dart';
import 'dart:async';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, Map<String, int>> gameData = {
    'Overall': {}, 'Easy': {}, 'Medium': {}, 'Hard': {}
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    loadGameData();
  }

  Future<void> loadGameData() async {
    List<String> difficulties = ['Easy', 'Medium', 'Hard'];
    int totalGames = 0, totalWins = 0, totalLosses = 0;
    int? minTime, maxTime;

    for (var difficulty in difficulties) {
      gameData[difficulty] = await GameData.loadGameData(difficulty);
      totalGames += gameData[difficulty]?['gamesPlayed'] ?? 0;
      totalWins += gameData[difficulty]?['wins'] ?? 0;
      totalLosses += gameData[difficulty]?['losses'] ?? 0;

      int? currentMin = gameData[difficulty]?['elapsedTime'];
      int? currentMax = gameData[difficulty]?['highestTime'];

      if (currentMin != null) {
        minTime = minTime == null ? currentMin : (currentMin < minTime ? currentMin : minTime);
      }
      if (currentMax != null) {
        maxTime = maxTime == null ? currentMax : (currentMax > maxTime ? currentMax : maxTime);
      }
    }

    gameData['Overall'] = {
      'gamesPlayed': totalGames,
      'wins': totalWins,
      'losses': totalLosses,
      'elapsedTime': minTime ?? 0,
      'highestTime': maxTime ?? 0,
    };

    setState(() {});
  }

  String formatTime(int? milliseconds) {
    if (milliseconds == null) return "0.0 sec";
    return "${(milliseconds / 1000).toStringAsFixed(1)} sec";
  }

  Widget buildStatCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(value, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  Widget buildStatsPage(String title, Map<String, int> stats) {
    int wins = stats['wins'] ?? 0;
    int losses = stats['losses'] ?? 0;
    int totalGames = wins + losses;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              buildStatCard('Minimum Time', formatTime(stats['elapsedTime'])),
              buildStatCard('Maximum Time', formatTime(stats['highestTime'])),
              buildStatCard('Games Played', stats['gamesPlayed']?.toString() ?? '0'),
            ],
          ),
          SizedBox(height: 20),
          if (totalGames > 0) ...[
            Text("Win/Loss Ratio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 200, child: buildPieChart(wins, losses)),
          ]
        ],
      ),
    );
  }

  Widget buildPieChart(int wins, int losses) {
    int total = wins + losses;
    if (total == 0) return Container(); // Hide chart if no data

    return PieChart(
      PieChartData(
        sections: [
          if (wins > 0)
            PieChartSectionData(
              value: (wins / total) * 100,
              color: Colors.green,
              title: wins > 0 ? 'Win ${(wins / total * 100).toStringAsFixed(1)}%' : '',
              radius: 60,
              titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          if (losses > 0)
            PieChartSectionData(
              value: (losses / total) * 100,
              color: Colors.red,
              title: losses > 0 ? 'Loss ${(losses / total * 100).toStringAsFixed(1)}%' : '',
              radius: 60,
              titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Game Statistics")),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(text: "Overall"),
              Tab(text: "Easy"),
              Tab(text: "Medium"),
              Tab(text: "Hard"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildStatsPage("Overall Stats", gameData['Overall'] ?? {}),
                buildStatsPage("Easy Stats", gameData['Easy'] ?? {}),
                buildStatsPage("Medium Stats", gameData['Medium'] ?? {}),
                buildStatsPage("Hard Stats", gameData['Hard'] ?? {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}