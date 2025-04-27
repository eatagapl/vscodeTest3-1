import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Add this import for charts
import 'dart:math'; // Add this import for logarithmic function
import 'globalVariables.dart'; // Import the global variables

class PlotScene extends StatelessWidget {
  const PlotScene({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure fiberopticalfrom and fiberopticalto are valid
    final int startX = FiberOpticalPowerFrom.toInt();
    final int endX = FiberOpticalPowerTo.toInt();
    if (startX > endX || startX <= 0 || endX <= 0) {
      return Scaffold(
        body: Center(
          child: Text(
            'Invalid fiber optical power range. Please check the values.',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    double Ipnew = 65536 * (101.0 / ExposureTimes[loadedImageNum - 1]);
    double fiberSquared = (pi / 4) * DiamMM * DiamMM; 
    double scattCoef = 0.018157 + (1 / 300) * log(3082.0 / Ipnew);
    double proteinThreshold = doubleFromPercent;

    print (
      'DiamMM: $DiamMM, ScatteringCoefficient: $scattCoef, ProteinThreshold: $proteinThreshold, exposure: ${ExposureTimes[loadedImageNum - 1]}, grayscale: $grayscale, Ipnew: $Ipnew, fiberSquared: $fiberSquared'
    );

    // Generate data points from fiberopticalfrom to fiberopticalto
    final List<FlSpot> spots = List.generate(endX - startX + 1, (index) {
      int x = startX + index; // x values from fiberopticalfrom to fiberopticalto
      double y = DiamMM; // Replace with your calculation for y

      double laserInt = x / fiberSquared;
      //print('Laser Intensity at $x mW: $laserInt');
      double penetration = -log(proteinThreshold / laserInt) / scattCoef;
      y = penetration;
      

      return FlSpot(x.toDouble(), y);
    });

    // Find the maximum y-value to adjust the y-axis range
    double maxY = spots.map((spot) => spot.y).reduce(max);
    // Round maxY to the nearest integer that allows for 10 even increments
    maxY = (maxY / 10).ceil() * 10;

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: isDarkMode ? Colors.white : Colors.black,
                  width: 1,
                ), // Change border color based on theme
              ),
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: isDarkMode
                        ? const Color.fromARGB(255, 148, 145, 145)
                        : Colors.black, // Change grid line color based on theme
                    strokeWidth: 0.7,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: isDarkMode
                        ? const Color.fromARGB(255, 148, 145, 145)
                        : Colors.black, // Change grid line color based on theme
                    strokeWidth: 0.7,
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
                  reservedSize: 20, // Increase reservedSize to ensure markers are visible
                  interval: (endX - startX) / 12, // Set interval based on x range
                ),
                topTitles: SideTitles(showTitles: false),
                rightTitles: SideTitles(showTitles: false),
              ),
              axisTitleData: FlAxisTitleData(
                leftTitle: AxisTitle(
                  showTitle: true,
                  titleText: 'Penetration Depth (mm)', // Y-axis title
                  textStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  margin: 0,
                  reservedSize: 5,
                ),
                bottomTitle: AxisTitle(
                  showTitle: true,
                  titleText: 'Fiber Optical Power (mW)', // X-axis title
                  textStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  margin: 10,
                ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: isDarkMode ? Colors.black54 : Colors.white,
                  fitInsideHorizontally: true, // Ensure tooltip stays within horizontal bounds
                  fitInsideVertically: true, // Ensure tooltip stays within vertical bounds
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((touchedSpot) {
                      return LineTooltipItem(
                        'x: ${touchedSpot.x.toStringAsFixed(2)}, y: ${touchedSpot.y.toStringAsFixed(2)}',
                        TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
                // touchCallback: (LineTouchResponse? touchResponse) {
                //   // Optional: Handle touch interactions if needed
                //   // Perform any desired actions here
                //   return; // Explicitly return null to match the expected type
                // },
                handleBuiltInTouches: true, // Enable built-in touch handling
              ),
              minY: 0,
              maxY: maxY, // Adjust the y-axis range to be slightly above the highest y-value
            ),
          ),
        ),
      ),
    );
  }
}