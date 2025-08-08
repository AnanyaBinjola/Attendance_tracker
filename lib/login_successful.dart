import 'package:login_app/appState.dart';
import 'package:login_app/checkin.dart';
import 'package:flutter/material.dart';

class LogInSuccessScreen extends StatelessWidget {
  final String userName;
  final String userMobile;

  const LogInSuccessScreen({
    super.key,
    required this.userName,
    required this.userMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log-in Status'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 150, color: Colors.green),
            const SizedBox(height: 30),
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              userName,
              style: const TextStyle(fontSize: 24, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              ),
              onPressed: () {
                // Pass userName and userMobile to CheckInSuccessScreen
                AppState.recordCheckIn(userMobile, userName);
                Navigator.of(context).push( 
                  MaterialPageRoute(
                    builder: (context) => CheckInSuccessScreen(
                      userName: userName,
                      userMobile: userMobile,
                      ),
                  ),
                );
              },
              child: const Text(
                'Check-in',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



