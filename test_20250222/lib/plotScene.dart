import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Add this import for charts
import 'dart:math'; // Add this import for logarithmic function

class PlotScene extends StatelessWidget {
  final double plotSlope;

  const PlotScene({super.key, required this.plotSlope});

  @override
  Widget build(BuildContext context) {
    // Generate 10 data points that resemble a y = mx equation
    final List<FlSpot> spots = List.generate(10, (index) {
      double x = index * 10.0;
      double y = plotSlope * x; // y = mx equation
      return FlSpot(x, y);
    });

    // Find the maximum y-value to adjust the y-axis range
    double maxY = spots.map((spot) => spot.y).reduce(max);
    // Round maxY to the nearest integer that allows for 10 even increments
    maxY = (maxY / 10).ceil() * 10;

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: isDarkMode ? Colors.white : Colors.black, width: 1), // Change border color based on theme
            ),
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: isDarkMode ? Colors.white : Colors.black, // Change grid line color based on theme
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: isDarkMode ? Colors.white : Colors.black, // Change grid line color based on theme
                  strokeWidth: 1,
                );
              },
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                colors: [isDarkMode ? Colors.blue : Colors.black], // Change plot line color based on theme
                barWidth: 4,
                belowBarData: BarAreaData(show: false),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                showTitles: true,
                getTitles: (value) {
                  return value.toInt().toString(); // Return a string instead of a Text widget
                },
                reservedSize: 40,
                interval: maxY / 10, // Set interval to have 10 even increments
              ),
              bottomTitles: SideTitles(
                showTitles: true,
                getTitles: (value) {
                  return value.toInt().toString(); // Return a string instead of a Text widget
                },
                reservedSize: 22, // Increase reservedSize to ensure markers are visible
                interval: 10,
              ),
              topTitles: SideTitles(showTitles: false),
              rightTitles: SideTitles(showTitles: false),
            ),
            minY: 0,
            maxY: maxY, // Adjust the y-axis range to be slightly above the highest y-value
          ),
        ),
      ),
    );
  }
}