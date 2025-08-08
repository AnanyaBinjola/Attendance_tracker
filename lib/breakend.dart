import 'package:login_app/appState.dart';
import 'package:login_app/checkout.dart';
import 'package:flutter/material.dart';
import 'package:login_app/login.dart'; 
 
class BreakEndedScreen extends StatefulWidget {
  final String userName;

  const BreakEndedScreen({super.key, required this.userName, required String userMobile});

  @override
  State<BreakEndedScreen> createState() => _BreakEndedScreenState();
}

class _BreakEndedScreenState extends State<BreakEndedScreen> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Break Status'),
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 150, color: Colors.blueGrey),
            const SizedBox(height: 30),
            const Text(
              'Your break has ended!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              widget.userName, // Display the user's name
              style: const TextStyle(fontSize: 24, color: Colors.black87),
            ),
            const SizedBox(height: 50),
            // Check-out Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                AppState.endBreak(); Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CheckoutSuccessScreen(
                    userMobile: AppState.currentLoggedInUserMobile!, 
                    userName: AppState.currentLoggedInUserName!,
                  )
                  ),
                );
              },
              child: const Text(
                'Check-out',
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
                AppState.endBreak(); // Ensure break is ended before returning to home
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


