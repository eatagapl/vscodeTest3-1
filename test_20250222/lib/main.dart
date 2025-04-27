import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'brainScreen.dart'; // Import the new brainScreen.dart file
import 'plotScene.dart'; // Import the new plotScene.dart file
import 'xmlparser.dart'; // Import the XMLParser
import 'about.dart'; // Import the About screen
import 'manual.dart'; // Import the Manual screen
import 'globalVariables.dart'; // Import the global variables

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await populateProteinData(); // Populate and print the protein data
  runApp(const MyApp());
}

// Global variables for protein name and activation percentage



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
              backgroundColor: Colors.blue, // Set app bar color to blue
              iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Set title text color to white
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.blue, // Set FAB background color to blue
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
              backgroundColor: Colors.blue, // Set app bar color to blue in dark mode
              iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Set title text color to white
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.blue, // Set FAB background color to blue in dark mode
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
                
              });
            },
            
          ),
          PlotScene(), // Use PlotScene instead of PlotPage
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
      floatingActionButton: _selectedIndex == 0 // Show FAB only on the main page
          ? FloatingActionButton(
              onPressed: _toggleTheme,
              child: Icon(
                themeNotifier.value == ThemeMode.dark ? Icons.nightlight_round : Icons.wb_sunny,
                color: Colors.white, // Set the icon color to white
              ),
            )
          : null, // Hide FAB on other pages
    );
  }
}

class HomePage extends StatefulWidget {
  final ValueChanged<double> onSlopeChanged;


  const HomePage({super.key, 
    required this.onSlopeChanged,
  
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
                      FiberOpticalPowerFrom = double.tryParse(value) ?? 1.0; // Default to 1.0 if parsing fails
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
                      FiberOpticalPowerTo = double.tryParse(value) ?? 100.0; // Default to 1.0 if parsing fails
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
                      FiberCoreDiameter = double.tryParse(value) ?? 100.0;
                      DiamMM = FiberCoreDiameter / 1000.0; // Convert to mm
                      
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
                  doubleFromPercent = double.tryParse(proteinData[proteinName]![activationPercentage] ?? '0') ?? 0.0; // Update global doubleFromPercent
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
                  doubleFromPercent = double.tryParse(proteinData[proteinName]![activationPercentage] ?? '0') ?? 0.0; // Update global doubleFromPercent
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

