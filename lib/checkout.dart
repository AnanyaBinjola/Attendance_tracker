
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:login_app/appState.dart';
import 'package:login_app/attendance.dart';
import 'package:login_app/database_helper.dart';
import 'package:login_app/login.dart';
import 'package:login_app/profile.dart';

class CheckoutSuccessScreen extends StatefulWidget {
  final String userMobile;
  final String userName;

  const CheckoutSuccessScreen({
    super.key,
    required this.userMobile,
    required this.userName,
  });

  @override
  State<CheckoutSuccessScreen> createState() => _CheckoutSuccessScreenState();
}

class _CheckoutSuccessScreenState extends State<CheckoutSuccessScreen> {
  Timer? _timer;
  String totalWorkHoursDisplay = 'Calculating...';
  String _profileName = 'Loading...';
  String _profileMobile = 'Loading...';
  String _profileEmail = 'N/A';

  @override
  void initState() {
    super.initState();
    AppState.recordCheckOut();
    _calculateAndDisplayWorkHours();
    _loadUserProfile();
  }

  // To reload profile data when returning from ProfileDisplayScreen
  void _onProfileScreenClosed() {
    _loadUserProfile();
    // Restart timer after returning
  }

  Future<void> _loadUserProfile() async {
    final dbHelper = DatabaseHelper();
    final user = await dbHelper.getUser(widget.userMobile, widget.userName);

    if (mounted) {
      setState(() {
        if (user != null) {
          _profileName = user['name'] ?? 'N/A';
          _profileMobile = user['mobile'] ?? 'N/A';
          _profileEmail = user['email'] ?? 'N/A';
        } else {
          _profileName = widget.userName;
          _profileMobile = widget.userMobile;
          _profileEmail = 'N/A (Not Registered)';
        }
      });
    }
  }

  void _calculateAndDisplayWorkHours() async {
    Duration totalHours = await AppState.calculateTotalWorkHours(widget.userMobile,widget.userName);

    String hours = totalHours.inHours.toString().padLeft(2, '0');
    String minutes = (totalHours.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (totalHours.inSeconds % 60).toString().padLeft(2, '0');

    if (mounted) {
      setState(() {
        totalWorkHoursDisplay = '$hours hours, $minutes minutes, $seconds seconds';
      });
      debugPrint('Displaying total work hours: $totalWorkHoursDisplay');
    }
  }
  
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Go back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); 
                AppState.clearAllAttendanceData();
                
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-out Status'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 16.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: Icon(Icons.person, size: 50, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _profileName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: Text(_profileMobile),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: Text(_profileEmail),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.black54),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileDisplayScreen(
                      userMobile: widget.userMobile, 
                      userName: widget.userName,
                    ),
                  ),
                ).then((_) => _onProfileScreenClosed());
              },
            ),
          
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black54),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _showLogoutDialog(); // Call the new method
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.exit_to_app, size: 150, color: Colors.blue),
            const SizedBox(height: 30),
            const Text(
              'Check-out Successful!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              totalWorkHoursDisplay,
              style: const TextStyle(fontSize: 20, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AttendanceHistoryScreen(
                      userMobile: widget.userMobile,
                      userName: widget.userName,
                    ),
                  ),
                );
              },
              child: const Text(
                'View Attendance History',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.grey),
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              ),
              onPressed: () {
                _timer?.cancel();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text(
                'Return to HomePage',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
