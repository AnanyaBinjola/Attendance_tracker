import 'package:login_app/appState.dart';
import 'package:login_app/attendance.dart';
import 'package:login_app/breakstart.dart';
import 'package:login_app/checkout.dart';
import 'package:flutter/material.dart';
import 'package:login_app/login.dart';
import 'package:login_app/new_acc.dart';

class CheckInSuccessScreen extends StatefulWidget {
   final String userName; 
   final String userMobile; 
  const CheckInSuccessScreen({super.key, required this.userName, required this.userMobile});

  @override
  State<CheckInSuccessScreen> createState() => _CheckInSuccessScreenState();
}

class _CheckInSuccessScreenState extends State<CheckInSuccessScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in Status'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 150, color: Colors.green),
            const SizedBox(height: 30),
            const Text(
              'Check-in Successful!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Have a nice day!',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 50),
            // Start Break Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                AppState.startBreak(widget.userMobile, widget.userName); 
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  BreakStartedScreen()),
                );
              },
              child: const Text(
                'Start Break',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),

            // Check-out Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                AppState.endBreak(); 
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CheckoutSuccessScreen(
                   userMobile: AppState.currentLoggedInUserMobile!,
                   userName: AppState.currentLoggedInUserName!,)
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
































