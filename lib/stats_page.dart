import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'data.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late int highestTime = 0;
  late int minimumTime = 0;
  late int gamesPlayed = 0;
  List<int> gameTimes = [];

  @override
  void initState() {
    super.initState();
    loadGameData();
  }

  // Load saved game data
  void loadGameData() async {
    Map<String, int> gameData = await GameData.loadGameData();
    List<int> times = await GameData.loadGameTimes();

    setState(() {
      highestTime = gameData['highestTime'] ?? 0;
      minimumTime = gameData['minimumTime'] ?? 0;
      gamesPlayed = gameData['gamesPlayed'] ?? 0;
      gameTimes = times;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Stats')),
      body: gameTimes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Stats Summary
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Highest Time: $highestTime sec', style: TextStyle(fontSize: 16)),
                Text('Minimum Time: $minimumTime sec', style: TextStyle(fontSize: 16)),
                Text('Games Played: $gamesPlayed', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),

          // Line Chart
          Expanded(
            child: Echarts(
              option: '''
                    {
                      tooltip: { trigger: 'axis' },
                      xAxis: {
                        type: 'category',
                        data: ${List.generate(gameTimes.length, (index) => '"Game ${index + 1}"')}
                      },
                      yAxis: { type: 'value' },
                      series: [{
                        data: ${gameTimes},
                        type: 'line',
                        smooth: true,
                        itemStyle: { color: 'blue' }
                      }]
                    }
                    ''',
            ),
          ),
        ],
      ),
    );
  }
}