import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'brainScreen.dart'; // Import the new brainScreen.dart file
import 'plotScene.dart'; // Import the new plotScene.dart file
import 'utils/protein_parser.dart';

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
  int _selectedIndex = 0; // Ensure this is set to 0 by default
  double plotSlope = 1.0; // Default plotSlope to 1.0
  int imgNum = 1; // Default imgNum to 1
  String? selectedUser; // Add a variable to store the selected user

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
          HomePage( // Ensure HomePage is the first widget in the IndexedStack
            onSlopeChanged: (slope) {
              setState(() {
                plotSlope = slope;
              });
            },
            initialSlope: plotSlope,
          ),
          PlotScene(plotSlope: plotSlope), // Use PlotScene instead of PlotPage
          BrainScreen(initialImgNum: imgNum), // Use BrainScreen instead of ImagePage
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
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleTheme,
        child: Icon(themeNotifier.value == ThemeMode.dark ? Icons.nightlight_round : Icons.wb_sunny),
      ),
      persistentFooterButtons: [
        DropdownButton<String>(
          value: selectedUser,
          hint: const Text('Select User'),
          items: <String>['User1', 'User2', 'User3'].map((String user) {
            return DropdownMenuItem<String>(
              value: user,
              child: Text(user),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedUser = newValue;
            });
          },
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  final ValueChanged<double> onSlopeChanged;
  final double initialSlope;

  const HomePage({
    required this.onSlopeChanged,
    required this.initialSlope,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;
  String? selectedUser; // Revert to using a static dropdown menu for user selection

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialSlope.toString());
  }

  //test comment lskdfjsdlfkjfasdlkj;

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
            const SizedBox(height: 16), // Add spacing between the slope field and dropdown
            DropdownButton<String>(
              value: selectedUser,
              hint: const Text('Select Protein Type'),
              items: <String>['User1', 'User2', 'User3'].map((String user) {
                return DropdownMenuItem<String>(
                  value: user,
                  child: Text(user),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedUser = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

