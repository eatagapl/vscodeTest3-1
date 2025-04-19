import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'brainScreen.dart'; // Import the new brainScreen.dart file
import 'plotScene.dart'; // Import the new plotScene.dart file
import 'xmlparser.dart'; // Import the XMLParser
import 'about.dart'; // Import the About screen
import 'manual.dart'; // Import the Manual screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await populateProteinData(); // Populate and print the protein data
  runApp(const MyApp());
}

// Global variables for protein name and activation percentage
String proteinName = "ChR2";
String activationPercentage = "90%";

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
          AboutScreen(), // Add the About screen
          ManualScreen(), // Add the Manual screen
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
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Manual',
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
      persistentFooterButtons: [],
    );
  }
}

class HomePage extends StatefulWidget {
  final ValueChanged<double> onSlopeChanged;
  final double initialSlope;

  const HomePage({super.key, 
    required this.onSlopeChanged,
    required this.initialSlope,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

void printProteinThreshold() {
  if (proteinData.containsKey(proteinName)) {
    print('Protein name: $proteinName');
    print('Activation percentage: $activationPercentage');
    print(proteinData[proteinName]![activationPercentage]);
    //print('Value: $proteinData[$proteinName]![$activationPercentage]');
  }
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;
  String? selectedUser; // Selected protein type
  String? selectedActivation; // Selected activation percentage
  List<String> proteinOptions = []; // List of protein options

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialSlope.toString());
    _loadProteinOptions(); // Load protein options from XML
  }

  Future<void> _loadProteinOptions() async {
    final proteins = await XMLParser.parseProteinsThresholds();
    if (proteins != null && proteins is List<Map<String, String>>) {
      setState(() {
        proteinOptions = proteins.map((entry) => entry['Protein'] ?? '').toList();
      });
    } else {
      setState(() {
        proteinOptions = []; // Handle the case where proteins is null or not the expected type
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter Fiber Optical Power (mW):',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16), // Consistent spacing between rows
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 175,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '1', // Filler text
                    ),
                    onChanged: (value) {
                      // Handle first optical power input
                    },
                  ),
                ),
                const SizedBox(width: 16), // Spacing between the two text fields
                SizedBox(
                  width: 175,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '100', // Filler text
                    ),
                    onChanged: (value) {
                      // Handle second optical power input
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60), // Consistent spacing between rows
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Enter Fiber Core Diameter (um):',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8), // Add spacing between the label and the text field
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 350,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '100', // Filler text
                    ),
                    onChanged: (value) {
                      // Handle Fiber Core Diameter input
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60), // Consistent spacing between rows
            DropdownButton<String>(
              value: selectedUser,
              hint: const Text('Select Protein Type'),
              items: proteinOptions.map((String protein) {
                return DropdownMenuItem<String>(
                  value: protein,
                  child: SizedBox(
                    width: 350, // Match the width of the dropdown menu
                    child: Text(protein),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedUser = newValue;
                  proteinName = newValue ?? "ChR2"; // Update global proteinName
                  printProteinThreshold(); // Print the threshold value
                });
              },
            ),
            const SizedBox(height: 60), // Consistent spacing between rows
            DropdownButton<String>(
              value: selectedActivation,
              hint: const Text('Select Activation Percentage'),
              items: <String>['90%', '50%', '10%'].map((String percentage) {
                return DropdownMenuItem<String>(
                  value: percentage,
                  child: SizedBox(
                    width: 350, // Match the width of the protein dropdown
                    child: Text(percentage),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedActivation = newValue;
                  activationPercentage = newValue ?? "90%"; // Update global activationPercentage
                  printProteinThreshold(); // Print the threshold value
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

