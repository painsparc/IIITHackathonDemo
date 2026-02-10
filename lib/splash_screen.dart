import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Imports your Dashboard

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // The "Boot Log" text
  final List<String> _bootLines = [];
  
  // The script needed to "sell" the complexity
  final List<String> _script = [
    "INITIALIZING MINDGUARD KERNEL v1.0...",
    "MOUNTING SENSORS: [ACCEL, GYRO, TOUCH]...",
    "CHECKING PERMISSIONS... ROOT ACCESS: DENIED (SANDBOX MODE)",
    "LOADING BIOMETRIC MODELS...",
    "CONNECTING TO NEURAL PROCESSING UNIT...",
    "CALIBRATING TOUCH ENTROPY BASELINE...",
    "SYSTEM READY."
  ];

  @override
  void initState() {
    super.initState();
    _runBootSequence();
  }

  void _runBootSequence() async {
    for (String line in _script) {
      if (!mounted) return;
      await Future.delayed(Duration(milliseconds: 300 + (line.length * 5))); // Variable typing speed
      setState(() {
        _bootLines.add(line);
      });
    }
    // Wait a moment after "SYSTEM READY" then launch Dashboard
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const DashboardScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end, // Text fills from bottom like a terminal
          children: [
            // The Logo / Spinner
            const Center(
              child: SizedBox(
                width: 50, 
                height: 50, 
                child: CircularProgressIndicator(color: Color(0xFF00FF41), strokeWidth: 2)
              )
            ),
            const SizedBox(height: 40),
            
            // The Terminal Text
            Expanded(
              child: ListView.builder(
                itemCount: _bootLines.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "> ${_bootLines[index]}",
                      style: GoogleFonts.firaCode(
                        color: const Color(0xFF00FF41), // Matrix Green
                        fontSize: 12,
                        fontWeight: index == _bootLines.length - 1 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}