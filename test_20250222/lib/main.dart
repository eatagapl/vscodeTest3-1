import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'package:fl_chart/fl_chart.dart'; // Add this import for charts
import 'dart:math'; // Add this import for logarithmic function

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'PopNeuron',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.blue[700],
            scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20), // Fixed font size
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.blue,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.black,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF2C2F33), // Discord-like dark background
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF23272A), // Discord-like dark background
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Fixed font size
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.blue,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF23272A), // Discord-like dark background
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.white,
            ),
          ),
          themeMode: currentMode,
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(title: 'PopNeuron'),
        );
      },
    );
  }
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  double plotSlope = 1.0; // Default plotSlope to 1.0
  String selectedImage = 'A'; // Default selected image option

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleTheme() {
    if (themeNotifier.value == ThemeMode.dark) {
      themeNotifier.value = ThemeMode.light;
    } else {
      themeNotifier.value = ThemeMode.dark;
    }
  }

  void _onImageChanged(String newImage) {
    setState(() {
      selectedImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get today's date and time
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.title}: $formattedDate'), // Display title with date and time
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/Logo-small.png'), // Add image to the app bar
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          HomePage(
            onSlopeChanged: (slope) {
              setState(() {
                plotSlope = slope;
              });
            },
            initialSlope: plotSlope,
            selectedImage: selectedImage,
            onImageChanged: _onImageChanged,
          ),
          PlotPage(plotSlope: plotSlope),
          ImagePage(selectedImage: selectedImage),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Plot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Image',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Change selected item color to blue
        onTap: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleTheme,
        child: Icon(themeNotifier.value == ThemeMode.dark ? Icons.nightlight_round : Icons.wb_sunny),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final ValueChanged<double> onSlopeChanged;
  final double initialSlope;
  final String selectedImage;
  final ValueChanged<String> onImageChanged;

  const HomePage({
    required this.onSlopeChanged,
    required this.initialSlope,
    required this.selectedImage,
    required this.onImageChanged,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialSlope.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Slope: ',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      double slope = double.tryParse(value) ?? 1.0;
                      if (value.isEmpty) {
                        slope = 1.0;
                      }
                      widget.onSlopeChanged(slope);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Image: ',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  width: 100,
                  child: DropdownButton<String>(
                    value: widget.selectedImage,
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.onImageChanged(newValue!);
                      });
                    },
                    items: <String>['A', 'B', 'C']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlotPage extends StatelessWidget {
  final double plotSlope;

  const PlotPage({required this.plotSlope});

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

class ImagePage extends StatelessWidget {
  final String selectedImage;

  const ImagePage({required this.selectedImage});

  @override
  Widget build(BuildContext context) {
    String imagePath;
    switch (selectedImage) {
      case 'B':
        imagePath = 'assets/orange.jpg';
        break;
      case 'C':
        imagePath = 'assets/pear.png';
        break;
      case 'A':
      default:
        imagePath = 'assets/apple.jpg';
        break;
    }

    return Center(
      child: Image.asset(imagePath),
    );
  }
}
