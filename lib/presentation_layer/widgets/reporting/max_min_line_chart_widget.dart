import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';

class MaxMinLineChart extends StatelessWidget {
  final List<SessionData> sessions;

  MaxMinLineChart({required this.sessions});

  Map<DateTime, List<SessionData>> _groupSessionsByDate(List<SessionData> sessions) {
    final Map<DateTime, List<SessionData>> groupedSessions = {};
    for (var session in sessions) {
      final date = DateTime(session.timeStamp.year, session.timeStamp.month, session.timeStamp.day);
      if (groupedSessions[date] == null) {
        groupedSessions[date] = [];
      }
      groupedSessions[date]!.add(session);
    }
    return groupedSessions;
  }

  List<FlSpot> _generateSpots(Map<DateTime, List<SessionData>> groupedSessions, bool isMaxWeight) {
    final List<FlSpot> spots = [];
    groupedSessions.forEach((date, sessions) {
      final averageWeight = sessions.map((s) => isMaxWeight ? s.maxWeight : s.minWeight).reduce((a, b) => a + b) / sessions.length;
      spots.add(FlSpot(date.millisecondsSinceEpoch.toDouble(), averageWeight));
    });
    spots.sort((a, b) => a.x.compareTo(b.x)); // Sort spots by x value (date)
    return spots;
  }

  double _getMinX(Map<DateTime, List<SessionData>> groupedSessions) {
    return groupedSessions.keys.map((date) => date.millisecondsSinceEpoch.toDouble()).reduce((a, b) => a < b ? a : b) - Duration(days: 1).inMilliseconds;
  }

  double _getMaxX(Map<DateTime, List<SessionData>> groupedSessions) {
    return groupedSessions.keys.map((date) => date.millisecondsSinceEpoch.toDouble()).reduce((a, b) => a > b ? a : b) + Duration(days: 1).inMilliseconds;
  }

  double _getMinY(Map<DateTime, List<SessionData>> groupedSessions, bool isMaxWeight) {
    return groupedSessions.values
        .expand((sessions) => sessions)
        .map((s) => isMaxWeight ? s.maxWeight : s.minWeight)
        .reduce((a, b) => a < b ? a : b) - 1;
  }

  double _getMaxY(Map<DateTime, List<SessionData>> groupedSessions, bool isMaxWeight) {
    return groupedSessions.values
        .expand((sessions) => sessions)
        .map((s) => isMaxWeight ? s.maxWeight : s.minWeight)
        .reduce((a, b) => a > b ? a : b) + 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedSessions = _groupSessionsByDate(sessions);

    return Padding(
      padding: const EdgeInsets.only(right:16.0),
      child: LineChart(
        LineChartData(
          minX: _getMinX(groupedSessions),
          maxX: _getMaxX(groupedSessions),
          minY: _getMinY(groupedSessions, false),
          maxY: _getMaxY(groupedSessions, true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40, // Increase reserved size for left titles
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text('${date.month}/${date.day}'),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _generateSpots(groupedSessions, true),
              isCurved: true,
              color: theme.primaryColorDark,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
            ),
            LineChartBarData(
              spots: _generateSpots(groupedSessions, false),
              isCurved: true,
              color: theme.primaryColorLight,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
            ),
          ],
          gridData: FlGridData(show: false), // Hide grid lines
          borderData: FlBorderData(
            show: false,
          ),
        ),
      ),
    );
  }
}
