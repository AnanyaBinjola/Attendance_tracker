import 'package:login_app/breakstart.dart';
import 'package:login_app/Checkin.dart';
import 'package:login_app/new_Acc.dart';
import 'package:login_app/login_successful.dart';
import 'package:flutter/material.dart';
import 'package:login_app/appState.dart';
import 'package:login_app/database_helper.dart';

class ProjectApp extends StatelessWidget {
  const ProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Project App',
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String? _nameErrorMessage;
  String? _mobileNumberErrorMessage;

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool isValidateName(String value) {
    if (value.isEmpty) {
      setState(() {
        _nameErrorMessage = "Please enter your name";
      });
      return false;
    } else if (RegExp(r'\d').hasMatch(value)) {
      setState(() {
        _nameErrorMessage = "Invalid Response";
      });
      return false;
    } else if (RegExp(r'[!@#$%^&*(),?":{}|<>]').hasMatch(value)) {
      setState(() {
        _nameErrorMessage = "Name cannot contain special characters";
      });
      return false;
    }
    setState(() {
      _nameErrorMessage = null; 
    });
    return true;
  }

  bool isValidateMobileNumber(String value) {
    if (value.isEmpty) {
      setState(() {
        _mobileNumberErrorMessage = "Please enter a mobile number";
      });
      return false;
    } else if (value.length != 10) {
      setState(() {
        _mobileNumberErrorMessage = "Invalid Mobile Number";
      });
      return false;
    } else if (RegExp(r'[!@#$%^&*(),?":{}|<>]').hasMatch(value)) {
      setState(() {
        _mobileNumberErrorMessage = "Cannot contain special characters";
      });
      return false;
    }
    setState(() {
      _mobileNumberErrorMessage = null; 
    });
    return true;
  }

  void _showUserNotFoundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Not Found'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'An account with the entered mobile number and username does not exist.',
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); 
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: const Text(
                  'Sign up here!',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
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
        title: const Text('Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Icon(Icons.phone, size: 100, color: Colors.blue),
              const SizedBox(height: 100),
              const Text(
                'Enter your details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'e.g., ABC XYZ',
                    errorText: _nameErrorMessage,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _nameErrorMessage = null;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _mobileNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: 'e.g., 9876543210',
                    errorText: _mobileNumberErrorMessage,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _mobileNumberErrorMessage = null;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign up!",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
                ),
                  onPressed:() async {
                    if (_formKey.currentState!.validate()) {
                      final enteredMobile = _mobileNumberController.text;
                      final enteredName = _nameController.text;

                      final dbHelper = DatabaseHelper();
                      final user = await dbHelper.getUser(enteredMobile, enteredName);

                      if (user == null || user['name'] != enteredName) {
                        _showUserNotFoundDialog(context);
                        return; // Stop login process
                      }

                      // --- User found and name matches ---

                      // to Check if the *same user* is currently on break
                      if (AppState.isUserOnBreak &&
                          AppState.currentBreakingUserMobile == enteredMobile &&
                          AppState.currentBreakingUserName == enteredName) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const BreakStartedScreen(),
                          ),
                        );
                      }
                      // to check if the *same user* is already checked in (but NOT on break)
                      else if (AppState.isUserCheckedIn &&
                          AppState.currentLoggedInUserMobile == enteredMobile &&
                          AppState.currentLoggedInUserName == enteredName) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CheckInSuccessScreen(
                              userName: enteredName,
                              userMobile: enteredMobile,
                            ),
                          ),
                        );
                      }
                    }

                    bool isNameValid = isValidateName(_nameController.text);
                    bool isMobileValid = isValidateMobileNumber(_mobileNumberController.text);

                    if (isNameValid && isMobileValid) {
                      final enteredMobile = _mobileNumberController.text;
                      final enteredName = _nameController.text;

                      // Check if the user is the one currently on break
                      if (AppState.isUserOnBreak &&
                          AppState.currentBreakingUserMobile == enteredMobile &&
                          AppState.currentBreakingUserName == enteredName) {
                        debugPrint('Login: User $enteredName on break. Redirecting to BreakStartedScreen.');
                        // Redirect to break started screen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const BreakStartedScreen(),
                          ),
                        );
                      } else if (AppState.isUserCheckedIn &&
                          AppState.currentLoggedInUserMobile == enteredMobile &&
                          AppState.currentLoggedInUserName == enteredName) {
                        debugPrint(
                          'Login: User $enteredName already checked in. Redirecting to CheckInSuccessScreen.',
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CheckInSuccessScreen(
                              userName: enteredName,
                              userMobile: enteredMobile,
                            ),
                          ),
                        );
                      } else {
                        debugPrint(
                          'Login: New login for $enteredName. Redirecting to LogInSuccessScreen.',
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LogInSuccessScreen(
                              userName: enteredName,
                              userMobile: enteredMobile,
                            ),
                          ),
                        );
                      }
                    }
                  },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
