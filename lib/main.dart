import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure this is in pubspec.yaml
import 'package:intl/intl.dart'; // Ensure this is in pubspec.yaml
import 'splash_screen.dart';

// =============================================================================
// 1. DATA MODELS & CONFIGURATION
// =============================================================================

// The "Atom" of our system: A single sensor event
class SensorLog {
  final String timestamp;
  final String category; // e.g., TOUCH, ACCEL, LIGHT, SYSTEM
  final String event;    // e.g., FLING, SHAKE, SCREEN_ON
  final String metadata; // e.g., "velocity=2500px/s"

  SensorLog(this.timestamp, this.category, this.event, this.metadata);
}

// The "Output" of our system: The AI's Verdict
class RiskReport {
  final String statusTitle;
  final String clinicalSummary;
  final Color statusColor;
  final List<String> detectedMarkers;
  final double riskScore; // 0 to 100

  RiskReport({
    required this.statusTitle,
    required this.clinicalSummary,
    required this.statusColor,
    required this.detectedMarkers,
    required this.riskScore,
  });
}

// Global Colors
const Color kMatrixGreen = Color(0xFF00FF41);
const Color kMatrixDark = Color(0xFF0D0D0D);
const Color kAlertRed = Color(0xFFFF3333);
const Color kWarningAmber = Color(0xFFFFD700);

// =============================================================================
// 2. THE ENGINE (SIMULATION + LOGIC)
// =============================================================================

class MindGuardEngine {
  
  // --- MODULE A: SIMULATOR (Generates "Fake" Real Data) ---
  static List<SensorLog> generateSessionLogs(double nightUsage, double scrollSpeed, double jitter) {
    List<SensorLog> logs = [];
    Random rng = Random();
    DateTime now = DateTime.now();

    // 1. NIGHT USAGE SIMULATION (Circadian Rhythm)
    // If high, generate logs between 1AM and 4AM
    int nightEvents = (nightUsage * 20).toInt();
    for (int i = 0; i < nightEvents; i++) {
      DateTime nightTime = now.subtract(Duration(hours: 12 + rng.nextInt(6)));
      logs.add(SensorLog(
        DateFormat('HH:mm:ss').format(nightTime),
        "SYSTEM_CLOCK",
        "SCREEN_ACTIVE",
        "brightness=${(rng.nextDouble() * 0.2).toStringAsFixed(2)} | app_id=com.social.feed",
      ));
    }

    // 2. SCROLL VELOCITY SIMULATION (Dopamine Seeking)
    // If high, generate "FLING" events with high pixels/sec
    int scrollEvents = 10 + (scrollSpeed * 50).toInt();
    for (int i = 0; i < scrollEvents; i++) {
      bool isDoomScroll = rng.nextDouble() < scrollSpeed; 
      int velocity = isDoomScroll ? 1800 + rng.nextInt(3000) : 100 + rng.nextInt(400);
      logs.add(SensorLog(
        DateFormat('HH:mm:ss').format(now.subtract(Duration(seconds: i * 2))),
        "TOUCH_SENSOR",
        "GESTURE_FLING",
        "velocity=${velocity}px/s | pressure=${(0.3 + rng.nextDouble()).toStringAsFixed(2)}",
      ));
    }

    // 3. JITTER/ANXIETY SIMULATION (Motor Control)
    // If high, generate accelerometer noise
    int shakeEvents = (jitter * 30).toInt();
    for (int i = 0; i < shakeEvents; i++) {
      logs.add(SensorLog(
        DateFormat('HH:mm:ss').format(now.subtract(Duration(seconds: i * 5))),
        "ACCELEROMETER",
        "MICRO_TREMOR",
        "x=${rng.nextDouble().toStringAsFixed(3)} y=${rng.nextDouble().toStringAsFixed(3)} z=${rng.nextDouble().toStringAsFixed(3)}",
      ));
    }

    // Sort by time just to be messy (simulating async streams)
    logs.shuffle();
    return logs;
  }

  // --- MODULE B: ANALYZER (The "Algorithm") ---
  static RiskReport analyzeBehaviors(List<SensorLog> logs) {
    // 1. Extract Metrics
    int lateNightScreens = logs.where((l) => l.category == "SYSTEM_CLOCK").length;
    int highVelocitySwipes = logs.where((l) => l.event == "GESTURE_FLING" && l.metadata.contains("velocity=2") || l.metadata.contains("velocity=3") || l.metadata.contains("velocity=4")).length;
    int microTremors = logs.where((l) => l.event == "MICRO_TREMOR").length;

    // 2. Weighted Scoring (Heuristic)
    double score = 0.0;
    score += lateNightScreens * 3.5;    // Sleep is critical
    score += highVelocitySwipes * 1.5;  // Doomscrolling is bad
    score += microTremors * 2.0;        // Anxiety is moderate

    // Normalize (Cap at 100)
    if (score > 100) score = 100;

    // 3. Generate Verdict
    if (score > 65) {
      return RiskReport(
        statusTitle: "CRITICAL: BURNOUT RISK",
        clinicalSummary: "Behavioral patterns indicate severe sleep displacement and high-frequency anxious interactions.",
        statusColor: kAlertRed,
        riskScore: score,
        detectedMarkers: [
          "Circadian misalignment (>3h post-midnight usage)",
          "Compulsive high-velocity scrolling (Dopamine Loop)",
          "Motor instability detected (Tremors)",
        ],
      );
    } else if (score > 30) {
      return RiskReport(
        statusTitle: "WARNING: ELEVATED STRESS",
        clinicalSummary: "User is displaying early signs of digital fatigue and irregular usage cycles.",
        statusColor: kWarningAmber,
        riskScore: score,
        detectedMarkers: [
          "Fragmented attention spans detected",
          "Mild sleep delay observed",
          "Increased scroll velocity variance",
        ],
      );
    } else {
      return RiskReport(
        statusTitle: "STATUS: OPTIMAL",
        clinicalSummary: "All biometric markers are within healthy baselines. No significant deviations detected.",
        statusColor: kMatrixGreen,
        riskScore: score,
        detectedMarkers: [
          "Healthy Sleep/Wake Cycle",
          "Controlled Interaction Velocity",
          "Stable Motor Function",
        ],
      );
    }
  }
}

// =============================================================================
// 3. THE UI (VIEW LAYER)
// =============================================================================

void main() {
  runApp(const MindGuardApp());
}

class MindGuardApp extends StatelessWidget {
  const MindGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindGuard Console',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: kMatrixGreen,
        // Using Google Fonts for that "Terminal" look
        textTheme: GoogleFonts.courierPrimeTextTheme(
          ThemeData.dark().textTheme.apply(bodyColor: kMatrixGreen, displayColor: kMatrixGreen),
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: kMatrixGreen,
          thumbColor: kMatrixGreen,
          inactiveTrackColor: Colors.white24,
          trackHeight: 2.0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Inputs
  double _inputNight = 0.2;
  double _inputScroll = 0.3;
  double _inputJitter = 0.1;

  // State
  final List<SensorLog> _liveLogs = [];
  RiskReport? _result;
  bool _isProcessing = false;
  String _loadingText = "";
  final ScrollController _logScrollCtrl = ScrollController();

  // THE MAGIC FUNCTION (Runs the demo)
  void _executeDiagnostics() async {
    setState(() {
      _isProcessing = true;
      _liveLogs.clear();
      _result = null;
      _loadingText = "INITIALIZING SENSORS...";
    });

    // 1. Simulate "Reading" Data (Logs appear rapidly)
    List<SensorLog> data = MindGuardEngine.generateSessionLogs(_inputNight, _inputScroll, _inputJitter);
    
    for (int i = 0; i < data.length; i++) {
      if (!mounted) return;
      
      // Variable speed for realism
      await Future.delayed(Duration(milliseconds: i < 5 ? 200 : 30)); 
      
      setState(() {
        _liveLogs.add(data[i]);
        // Update loading text periodically
        if (i % 10 == 0) _loadingText = "PARSING BATCH #00$i...";
      });
      
      // Auto-scroll to bottom
      if (_logScrollCtrl.hasClients) {
        _logScrollCtrl.jumpTo(_logScrollCtrl.position.maxScrollExtent);
      }
    }

    // 2. Simulate "Thinking" (AI Processing)
    setState(() => _loadingText = "ANALYZING BEHAVIORAL VECTORS...");
    await Future.delayed(const Duration(milliseconds: 1500));

    // 3. Show Result
    setState(() {
      _result = MindGuardEngine.analyzeBehaviors(data);
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("MINDGUARD // ADMIN_CONSOLE", 
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: kMatrixGreen, height: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- TOP: INPUT SIMULATOR ---
            _buildSectionHeader("1. SENSOR SIMULATION (OS-LEVEL)"),
            _buildSliderRow("Circadian Rhythm (Night Usage)", _inputNight, (v) => _inputNight = v),
            _buildSliderRow("Scroll Velocity (Dopamine)", _inputScroll, (v) => _inputScroll = v),
            _buildSliderRow("Touch Jitter (Anxiety/Tremor)", _inputJitter, (v) => _inputJitter = v),
            
            const SizedBox(height: 10),
            
            // --- ACTION BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isProcessing ? Colors.grey : kMatrixGreen,
                  foregroundColor: Colors.black,
                  shape: const BeveledRectangleBorder(), // Techy corners
                ),
                onPressed: _isProcessing ? null : _executeDiagnostics,
                icon: _isProcessing 
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) 
                    : const Icon(Icons.play_arrow),
                label: Text(_isProcessing ? _loadingText : "INITIATE DIAGNOSTICS SEQUENCE", 
                  style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),

            const SizedBox(height: 20),

            // --- MIDDLE: LOG CONSOLE ---
            _buildSectionHeader("2. LIVE DATA STREAM"),
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kMatrixDark,
                  border: Border.all(color: Colors.white24),
                ),
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  controller: _logScrollCtrl,
                  itemCount: _liveLogs.length,
                  itemBuilder: (ctx, idx) {
                    final log = _liveLogs[idx];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.firaCode(fontSize: 10, color: Colors.white70), // Monospace font
                          children: [
                            TextSpan(text: "[${log.timestamp}] ", style: const TextStyle(color: Colors.grey)),
                            TextSpan(text: "${log.category} ", style: const TextStyle(color: kMatrixGreen)),
                            TextSpan(text: ">> ${log.event} ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            TextSpan(text: "// ${log.metadata}", style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white38)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- BOTTOM: REPORT CARD ---
            // --- BOTTOM: REPORT CARD ---
            _buildSectionHeader("3. AI ASSESSMENT"),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                // Remove padding here and move it inside the scroll view 
                // to ensure scroll bars appear at the edge if needed, 
                // or keep it here for aesthetics. keeping it here is fine.
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _result == null ? Colors.white10 : _result!.statusColor.withOpacity(0.1),
                  border: Border.all(color: _result?.statusColor ?? Colors.white12, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _result == null 
                  ? const Center(child: Text("WAITING FOR ANALYSIS...", style: TextStyle(color: Colors.white30, letterSpacing: 2)))
                  : SingleChildScrollView( // <--- FIX: Added ScrollView here
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_result!.statusTitle, style: TextStyle(color: _result!.statusColor, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("${_result!.riskScore.toStringAsFixed(1)}%", style: TextStyle(color: _result!.statusColor, fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(color: Colors.white24),
                          Text(_result!.clinicalSummary, style: const TextStyle(color: Colors.white, height: 1.4)),
                          const SizedBox(height: 10),
                          ..._result!.detectedMarkers.map((m) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, color: _result!.statusColor, size: 14),
                                const SizedBox(width: 8),
                                Expanded(child: Text(m, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(width: 4, height: 14, color: kMatrixGreen),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSliderRow(String label, double val, Function(double) onChange) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70))),
        Expanded(
          flex: 5,
          child: Slider(
            value: val,
            onChanged: (v) => setState(() => onChange(v)),
          ),
        ),
      ],
    );
  }
}