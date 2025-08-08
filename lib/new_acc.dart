import 'package:flutter/material.dart';
import 'package:login_app/database_helper.dart';
import 'package:login_app/login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
   

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _nameError;
   String? _mobileErrorMessage;
  String? _dobError;
  String? _emailError;
  bool _hasAttemptedSubmit = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileNumberController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your fullname';
    }
    if (RegExp(r'\d').hasMatch(value)) {
      return 'Name cannot contain digits';
    }
    if (RegExp(r'[!@#$%^&*(),?":{}|<>]').hasMatch(value)){
      return 'Name cannot contain special characters';
    }
    return null;
  }
  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number.';
    }
    if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mobile number must be 10 digits.';
    }
    return null;
  }

  String? _validateDob(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Date of Birth';
    }
    if (value.length != 10) {
      return 'Invalid date format';
    }
    if (!RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(value)) {
      return 'Invalid date format (DD-MM-YYYY)';
    }

    //parsing the date to ensure it's a valid
    try {
      //'try' block encloses code that might throw an exception
      List<String> parts = value.split('-'); // Splits "DD-MM-YYYY" into ["DD", "MM", "YYYY"]
      //If 'value' is "09-06-2006", 'parts' will be ["09", "06", "2006"].
      int day = int.parse(parts[0]); //'int.parse()' converts a string to an integer.
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      if (month < 1 || month > 12) {
        return 'Month must be between 1 and 12';
      }
      if (day < 1 || day > 31) {
        return 'Day must be between 1 and 31';
      }

      String yyyyMmDdString = '${year}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

      DateTime parsedDate = DateTime.parse(yyyyMmDdString,); //DateTime.parse() creates a `DateTime` object from the "YYYY-MM-DD" string.
      DateTime today = DateTime.now();
      DateTime normalizedToday = DateTime(// It normalizes the today DateTime to the beginning of the current calendar day ie midnight.
        today.year,
        today.month,
        today.day,  
      );
      DateTime normalizedParsedDate = DateTime(//It normalizes the user's entered date to the very beginning of its calendar day. It creates a new DateTime object from the year, month, and day of parsedDate, setting its time component to midnight (00:00:00.000).
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,  
      );
      if (normalizedParsedDate.isAfter(normalizedToday)) {
        // to check if normalized parsed date is after the current normalized date.
        return 'Date of Birth cannot be in the future';
      }
    } catch (e) {
      //executed if any exception occurs in the try block.
      //'e' is the exception object, (it catches all types).
      return 'Invalid date value';
    }
    return null; //incase of no error
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    if (!value.contains('@')) {
      return 'Email must contain "@" symbol';
    }
    if (!value.contains('.')) {
      return 'Email must contain a domain dot (e.g., .com)';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    //async fnc: it always returns a Future(e.g., the user selects a date)

    FocusScope.of(context).unfocus(); // to hide on-screen keyboard if it's open before showing the date picker
    //"Focus" typically means which widget is currently ready to receive keyboard input.
    //When a TextFormField loses focus, the on-screen keyboard automatically disappears.When we call unfocus() on a FocusScope, it tells the currently focused widget to release its focus.

    final DateTime? datepicked = await showDatePicker(
      //await keyword is used within an async func, to pause the execution of the async func until the showDatePicker func completes its operation and returns a Future result.
      context: context, // The context from the current widget tree.
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select DOB',
      cancelText: 'Cancel',
      confirmText: 'Select',
      fieldHintText: 'DD/MM/YYYY', // Hint text for manual entry within the picker
      fieldLabelText: 'Date',
      errorFormatText: 'Enter valid date', // Error msg for invalid date format in the manual entry.
      errorInvalidText: 'Enter date in valid range', // Error msg for date out of range in manual entry.

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            //ThemeData.light() creates a complete 'ThemeData' object based on Flutter's default Material Design "light" theme.
            primaryColor: Colors.blue,
            colorScheme: const ColorScheme.light(primary: Colors.blue),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (datepicked != null) {
      setState(() {
        //triggers a rebuild of the widget to update the UI.
        // date is formatted into YYYY-MM-DD format and is set to the Date of Birth text field controller.
        _dobController.text = "${datepicked.day.toString().padLeft(2, '0')}-${datepicked.month.toString().padLeft(2, '0')}-${datepicked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Icon(Icons.account_circle_sharp, size: 100, color: Colors.blue),
                const SizedBox(height: 50),
                const Text(
                  'Create Your Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                SizedBox(
                 width: 300,
                 child:TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'e.g., abc xyz',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.person),
                    errorText: _nameError,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _nameError = null;
                    });
                  },
                ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                width: 300,
                child:TextFormField(
                  controller: _mobileNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number (10 digits)',
                    hintText: 'e.g., 9876543210',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.phone),
                    errorText: _mobileErrorMessage, 
                  ),
                  validator: _validateMobileNumber,
                  onChanged: (value) {
                    setState(() {
                      _mobileErrorMessage = null; 
                    });
                  },
                ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                 width: 300,
                 child:TextFormField(
                  controller: _dobController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth (DD-MM-YYYY)',
                    hintText: 'e.g., 9-6-2006',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () =>
                          _selectDate(context), // Call date picker on tap
                    ),
                    errorText: _dobError,
                  ),
                  onChanged: (value) {
                    if (_hasAttemptedSubmit) {
                      setState(() {
                        _dobError = null; 
                      });
                    }
                  },
                ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                 width: 300,
                 child:TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'e.g., example@domain.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.email),
                    errorText: _emailError, // Display error
                  ),
                  onChanged: (value) {
                    setState(() {
                      _emailError = null;
                    });
                  },
                ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                    minimumSize: WidgetStateProperty.all(const Size(200, 50)),
                  ),
                  onPressed: ()async {
                    setState(() {
                      _nameError = _validateName(_nameController.text);
                     // _dobError = _validateDob(_dobController.text);
                      // _emailError = _validateEmail(_emailController.text);
                      _mobileErrorMessage= _validateMobileNumber(_mobileNumberController.text);
                    });
                    if (_formKey.currentState!.validate()) {
                      final dbHelper = DatabaseHelper();
                      final mobile = _mobileNumberController.text;
                      final name = _nameController.text;
                      final dob = _dobController.text;
                      final email =  _emailController.text;

                      // to check if mobile number already exists 
                      final existingUser = await dbHelper.getUser(mobile, name);
                      if (existingUser != null) {
                        setState(() {
                          _mobileErrorMessage = 'Account with this mobile number already exists.';
                          _nameError= 'User already exists.';
                        });
                        return; // Stop if mobile number exists
                      }
                      await dbHelper.insertUser(mobile, name, dob, email);
                       Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







