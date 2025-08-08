import 'package:flutter/material.dart';
import 'package:login_app/database_helper.dart';
import 'package:login_app/appState.dart';

class ProfileDisplayScreen extends StatefulWidget {
  final String userMobile;
  final String userName;

  const ProfileDisplayScreen({super.key, required this.userMobile, required this.userName});

  @override
  State<ProfileDisplayScreen> createState() => _ProfileDisplayScreenState();
}

class _ProfileDisplayScreenState extends State<ProfileDisplayScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? _nameError;
  String? _mobileError;
  String? _emailError;
  String? _dobError;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final dbHelper = DatabaseHelper();
      final user = await dbHelper.getUser(widget.userMobile, widget.userName);

      if (mounted) {
        setState(() {
          if (user != null) {
            _nameController.text = user['name'] ?? 'N/A';
            _mobileController.text = user['mobile'] ?? 'N/A';
            _emailController.text = user['email'] ?? 'N/A';
            _dobController.text = user['dob'] ?? 'N/A';
          } else {
            _nameController.text = 'User Not Found';
            _mobileController.text = widget.userMobile;
            _emailController.text = 'N/A';
            _dobController.text = 'N/A';
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load profile data.';
          _isLoading = false;
        });
      }
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      // Clear any validation errors when toggling modes
      _nameError = null;
      _mobileError = null;
      _emailError = null;
      _dobError = null;
    });
  }

  Future<void> _saveChanges() async {
    // Basic validation
    _nameError = _validateName(_nameController.text);
    _mobileError = _validateMobileNumber(_mobileController.text);
    _emailError = _validateEmail(_emailController.text);
    _dobError = _validateDob(_dobController.text);
    
    setState(() {}); // Rebuild to show errors

    if (_nameError == null && _mobileError == null && _emailError == null && _dobError == null) {
      final dbHelper = DatabaseHelper();
      final oldMobile = widget.userMobile;
      final newMobile = _mobileController.text;

      // Update the user's data in the database
      await dbHelper.updateUser(
        oldMobile,
        _nameController.text,
        newMobile,
        _dobController.text,
        _emailController.text,
      );

      // If the mobile number changed, update the AppState and notify the user
      if (oldMobile != newMobile) {
        AppState.currentLoggedInUserMobile = newMobile;
        // Optionally, you could also update the username in AppState if that was changed.
        // AppState.currentLoggedInUserName = _nameController.text;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Changes saved. Please use your new mobile number to log in next time.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Changes saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      _toggleEditMode(); // Exit edit mode
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your name';
    if (RegExp(r'\d').hasMatch(value) || RegExp(r'[!@#$%^&*(),?":{}|<>]').hasMatch(value)) {
      return 'Invalid name';
    }
    return null;
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty || value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mobile number must be 10 digits';
    }
    return null;
  }
  
  String? _validateEmail(String? value) {
    if (value == null || !value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateDob(String? value) {
    if (value == null || value.isEmpty || !RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(value)) {
      return 'Invalid date format (DD-MM-YYYY)';
    }
    try {
      List<String> parts = value.split('-');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      DateTime parsedDate = DateTime.parse('${year}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}');
      if (parsedDate.isAfter(DateTime.now())) return 'DOB cannot be in the future';
    } catch (e) {
      return 'Invalid date value';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (datePicked != null) {
      setState(() {
        _dobController.text = "${datePicked.day.toString().padLeft(2, '0')}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.cancel : Icons.edit),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, size: 80, color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      _buildInfoField(Icons.person, 'Name', _nameController, _nameError),
                      _buildInfoField(Icons.phone, 'Mobile Number', _mobileController, _mobileError),
                      _buildInfoField(Icons.email, 'Email', _emailController, _emailError),
                      _buildInfoField(Icons.calendar_today, 'Date of Birth', _dobController, _dobError),
                      const SizedBox(height: 20),
                      if (_isEditing)
                        ElevatedButton.icon(
                          onPressed: _saveChanges,
                          icon: const Icon(Icons.save),
                          label: const Text('Save Changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  // Helper widget to display each information field
  Widget _buildInfoField(IconData icon, String label, TextEditingController controller, String? errorText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16, 
              color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                icon, 
                color: Colors.blue, 
                size: 28),
              const SizedBox(width: 5),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  readOnly: !_isEditing,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black, 
                    fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    errorText: errorText,
                    border: _isEditing ? const OutlineInputBorder() : InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: label == 'Date of Birth' && _isEditing
                        ? IconButton(
                            icon: const Icon(Icons.calendar_today, size: 20),
                            onPressed: () => _selectDate(context),
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (label == 'Name') _nameError = null;
                      if (label == 'Mobile Number') _mobileError = null;
                      if (label == 'Email') _emailError = null;
                      if (label == 'Date of Birth') _dobError = null;
                    });
                  },
                ),
              ),
            ],
          ),
          if (!_isEditing) const Divider(),
        ],
      ),
    );
  }
}


























