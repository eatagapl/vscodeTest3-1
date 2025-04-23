import 'dart:ffi';
import 'dart:math'; // Import for mathematical functions like log

Map<String, Map<String, String>> proteinData = {};
String proteinName = "ChR2";
String activationPercentage = "90%";
int a = 0;
int b = 0;
double FiberOpticalPowerFrom = 1.0;
double FiberOpticalPowerTo = 100.0;    
double FiberCoreDiameter = 100.0;
double DiamMM = FiberCoreDiameter / 1000.0;

double grayscale = -1.0;
double ScatteringCoefficient = 0.018157 + log(3082.0 /grayscale/ 300.0); // Ensure grayscale is handled elsewhere
double doubleFromPercent = 5.5;

int NeuralTargetIndex = 0;

List<int> ExposureTimes = [
  91, 91, 91, 81, 81, 81, 81, 91, 91, 81, 81, 91, 91, 91, 91, 81, 81, 91, 91, 
  91, 91, 81, 101, 91, 91, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 
  91, 91, 81, 81, 81, 81, 91, 91
];

int percentageIndex = 0;

String placeholderString = '';
bool isInitialized = false;
List<String> sampleList = [];
double placeholderDouble = 0.0;
Map<String, dynamic> placeholderMap = {};
Set<int> placeholderSet = {};

// 2D vector for dot position
List<double> dotPosition = [300.00, 400.00];
