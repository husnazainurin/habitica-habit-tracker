import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habitica_habit_tracker/data/daily_logs.dart';
import 'package:habitica_habit_tracker/models/daily_log.dart';

enum TimeRange { week, month, year }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TimeRange _selectedRange = TimeRange.week;

  /// Sorts sampleDailyLogs chronologically and builds spots + X-axis labels
  ({List<FlSpot> waterSpots, List<FlSpot> sleepSpots, List<String> labels})
      _buildChartData() {
    // Sort oldest -> newest so the graph progresses left-to-right
    final sortedLogs = List<DailyLog>.from(sampleDailyLogs)
      ..sort((a, b) => a.date.compareTo(b.date));

    if (sortedLogs.isEmpty) {
      return (waterSpots: [], sleepSpots: [], labels: []);
    }

    // Use the latest logged date as the reference point
    final latestDate = sortedLogs.last.date;

    if (_selectedRange == TimeRange.week) {
      const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final recent = sortedLogs.length >= 7
          ? sortedLogs.sublist(sortedLogs.length - 7)
          : sortedLogs;

      return (
        waterSpots: [
          for (int i = 0; i < recent.length; i++)
            FlSpot(i.toDouble(), recent[i].waterGlasses.toDouble()),
        ],
        sleepSpots: [
          for (int i = 0; i < recent.length; i++)
            FlSpot(i.toDouble(), recent[i].sleepHours),
        ],
        labels: [
          for (final log in recent) dayNames[log.date.weekday - 1],
        ],
      );
    }

    if (_selectedRange == TimeRange.month) {
      final recent = sortedLogs.length >= 30
          ? sortedLogs.sublist(sortedLogs.length - 30)
          : sortedLogs;

      return (
        waterSpots: [
          for (int i = 0; i < recent.length; i++)
            FlSpot(i.toDouble(), recent[i].waterGlasses.toDouble()),
        ],
        sleepSpots: [
          for (int i = 0; i < recent.length; i++)
            FlSpot(i.toDouble(), recent[i].sleepHours),
        ],
        labels: [
          for (final log in recent) '${log.date.day}/${log.date.month}',
        ],
      );
    }

    // TimeRange.year -> Group by calendar month (last 12 months)
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final waterSpots = <FlSpot>[];
    final sleepSpots = <FlSpot>[];
    final labels = <String>[];

    for (int m = 11; m >= 0; m--) {
      final target = DateTime(latestDate.year, latestDate.month - m, 1);
      final monthLogs = sortedLogs.where(
        (l) => l.date.year == target.year && l.date.month == target.month,
      );

      final avgWater = monthLogs.isEmpty
          ? 0.0
          : monthLogs.map((e) => e.waterGlasses).reduce((a, b) => a + b) /
              monthLogs.length;
      final avgSleep = monthLogs.isEmpty
          ? 0.0
          : monthLogs.map((e) => e.sleepHours).reduce((a, b) => a + b) /
              monthLogs.length;

      final index = (11 - m).toDouble();
      waterSpots.add(FlSpot(index, double.parse(avgWater.toStringAsFixed(1))));
      sleepSpots.add(FlSpot(index, double.parse(avgSleep.toStringAsFixed(1))));
      labels.add(monthNames[target.month - 1]);
    }

    return (waterSpots: waterSpots, sleepSpots: sleepSpots, labels: labels);
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _buildChartData();

    return Scaffold(
      appBar: AppBar(title: const Text('My Life in Progress')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Week / Month / Year Toggle
          SegmentedButton<TimeRange>(
            segments: const [
              ButtonSegment(value: TimeRange.week, label: Text('Week')),
              ButtonSegment(value: TimeRange.month, label: Text('Month')),
              ButtonSegment(value: TimeRange.year, label: Text('Year')),
            ],
            selected: {_selectedRange},
            onSelectionChanged: (newSelection) {
              setState(() => _selectedRange = newSelection.first);
            },
          ),
          const SizedBox(height: 20),

          // Water Intake Line Chart
          _MetricLineChartCard(
            title: 'Water Intake',
            unit: 'glasses',
            icon: Icons.water_drop,
            color: Colors.blue,
            maxY: 12,
            spots: chartData.waterSpots,
            labels: chartData.labels,
            range: _selectedRange,
          ),
          const SizedBox(height: 16),

          // Sleep Hours Line Chart
          _MetricLineChartCard(
            title: 'Sleep Hours',
            unit: 'hrs',
            icon: Icons.bedtime,
            color: Colors.indigo,
            maxY: 12,
            spots: chartData.sleepSpots,
            labels: chartData.labels,
            range: _selectedRange,
          ),
        ],
      ),
    );
  }
}

class _MetricLineChartCard extends StatelessWidget {
  final String title;
  final String unit;
  final IconData icon;
  final Color color;
  final double maxY;
  final List<FlSpot> spots;
  final List<String> labels;
  final TimeRange range;

  const _MetricLineChartCard({
    required this.title,
    required this.unit,
    required this.icon,
    required this.color,
    required this.maxY,
    required this.spots,
    required this.labels,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    final avg = spots.isEmpty
        ? 0.0
        : spots.map((s) => s.y).reduce((a, b) => a + b) / spots.length;

    // Prevent label crowding when viewing up to 30 points in Month view
    final double xInterval = (range == TimeRange.month && labels.length > 7)
        ? (labels.length / 5).ceilToDouble()
        : 1;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text(
                  'Avg: ${avg.toStringAsFixed(1)} $unit',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY,
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) => touchedSpots.map((s) {
                        final idx = s.x.toInt();
                        final label =
                            (idx >= 0 && idx < labels.length) ? labels[idx] : '';
                        return LineTooltipItem(
                          '$label: ${s.y} $unit',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 3,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: xInterval,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= labels.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              labels[idx],
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      preventCurveOverShooting: true,
                      color: color,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}