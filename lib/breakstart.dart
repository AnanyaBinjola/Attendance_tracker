import 'package:login_app/appState.dart';
import 'package:login_app/breakend.dart';
import 'package:login_app/login.dart';
import 'package:flutter/material.dart';

class BreakStartedScreen extends StatefulWidget {
  const BreakStartedScreen({super.key});

  @override
  State<BreakStartedScreen> createState() => _BreakStartedScreenState();
}

class _BreakStartedScreenState extends State<BreakStartedScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Break Status'),
        backgroundColor: Colors.orange, 
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.free_breakfast, size: 150, color: Colors.orange),
            const SizedBox(height: 30),
            const Text(
              'Your break has started!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            // End Break Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, 
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BreakEndedScreen(
                      userName: AppState.currentBreakingUserName! , 
                      userMobile: AppState.currentBreakingUserMobile!,
                    ),
                  ),
                );
                },
              child: const Text(
                'End Break',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            // Return to HomePage Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
               Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text(
                'Return to Login Page',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}











