import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FbiPage extends StatefulWidget {
  const FbiPage({super.key});

  @override
  _FbiPageState createState() => _FbiPageState();
}

class _FbiPageState extends State<FbiPage> {
  final Map<String, TextEditingController> _controllers = {
    'firstName': TextEditingController(),
    'secondName': TextEditingController(),
    'thirdName': TextEditingController(),
    'forthName': TextEditingController(),
    'birthday': TextEditingController(),
    'weight': TextEditingController(),
    'height': TextEditingController(),
    'phoneNumber': TextEditingController(),
  };

  String? _selectedGender;
  String? _selectedBloodGroup;
  DateTime? _selectedBirthday;

  InputDecoration _simpleTextFieldDecoration(String label,
      {bool isDateField = false}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.blue, width: 1),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      suffixIcon: isDateField
          ? IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            )
          : null,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isDateField = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration:
              _simpleTextFieldDecoration(label, isDateField: isDateField),
          keyboardType: keyboardType,
          onTap: isDateField ? () => _selectDate(context) : null,
          readOnly: isDateField,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field cannot be empty';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.gender,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
          decoration:
              _simpleTextFieldDecoration(AppLocalizations.of(context)!.gender),
          items: [
            DropdownMenuItem(
                value: 'Male',
                child: Text(AppLocalizations.of(context)!.genderMale)),
            DropdownMenuItem(
                value: 'Female',
                child: Text(AppLocalizations.of(context)!.genderFemale)),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBloodGroupDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.bloodGroup,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedBloodGroup,
          onChanged: (value) {
            setState(() {
              _selectedBloodGroup = value;
            });
          },
          decoration: _simpleTextFieldDecoration(
              AppLocalizations.of(context)!.bloodGroup),
          items: const [
            DropdownMenuItem(value: 'A+', child: Text('A+')),
            DropdownMenuItem(value: 'A-', child: Text('A-')),
            DropdownMenuItem(value: 'B+', child: Text('B+')),
            DropdownMenuItem(value: 'B-', child: Text('B-')),
            DropdownMenuItem(value: 'AB+', child: Text('AB+')),
            DropdownMenuItem(value: 'AB-', child: Text('AB-')),
            DropdownMenuItem(value: 'O+', child: Text('O+')),
            DropdownMenuItem(value: 'O-', child: Text('O-')),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
        _controllers['birthday']!.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  bool _isInputValid(String input) {
    final trimmedInput = input.trim();
    return trimmedInput.isNotEmpty &&
        !RegExp(r'^[ _-]+$').hasMatch(trimmedInput);
  }

  bool _isNumeric(String input) {
    return double.tryParse(input) != null;
  }

  bool _isPhoneNumberValid(String phoneNumber) {
    // Check if the phone number is exactly 11 digits and is numeric
    return RegExp(r'^\d{11}$').hasMatch(phoneNumber);
  }

  void _submitForm() {
    // Validate fields
    if (!_isInputValid(_controllers['firstName']!.text) ||
        !_isInputValid(_controllers['secondName']!.text) ||
        !_isInputValid(_controllers['thirdName']!.text) ||
        !_isInputValid(_controllers['forthName']!.text) ||
        !_isInputValid(_controllers['birthday']!.text) ||
        _selectedGender == null ||
        !_isNumeric(_controllers['weight']!.text) ||
        !_isNumeric(_controllers['height']!.text) ||
        !_isPhoneNumberValid(_controllers['phoneNumber']!.text) ||
        _selectedBloodGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly!')),
      );
      return;
    }

    // Prepare data for submission
    final data = {
      'firstName': _controllers['firstName']!.text,
      'secondName': _controllers['secondName']!.text,
      'thirdName': _controllers['thirdName']!.text,
      'forthName': _controllers['forthName']!.text,
      'birthday': _controllers['birthday']!.text,
      'gender': _selectedGender,
      'weight': _controllers['weight']!.text,
      'height': _controllers['height']!.text,
      'phoneNumber': _controllers['phoneNumber']!.text,
      'bloodGroup': _selectedBloodGroup,
    };

    // Show success message and print the data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form submitted successfully!')),
    );
    print(data); // Handle the form submission here
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600 && size.width < 1200;
    final isDesktop = size.width >= 1200;

    EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: isDesktop ? 50 : 16,
      vertical: isDesktop || isTablet ? 40 : 16,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle,
                  size: 40, color: Colors.white)),
        ],
        backgroundColor: Colors.black,
        title: Text(
          AppLocalizations.of(context)!.theIntelligenceAgency,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          bool isPortrait = orientation == Orientation.portrait;
          return Padding(
            padding: padding,
            child: Form(
              child: ListView(
                children: [
                  isPortrait ? _buildPortraitLayout() : _buildLandscapeLayout(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: const ContinuousRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: Text(
                      AppLocalizations.of(context)!.submit,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(AppLocalizations.of(context)!.firstName,
            _controllers['firstName']!),
        _buildTextField(AppLocalizations.of(context)!.secondName,
            _controllers['secondName']!),
        _buildTextField(AppLocalizations.of(context)!.thirdName,
            _controllers['thirdName']!),
        _buildTextField(AppLocalizations.of(context)!.forthName,
            _controllers['forthName']!),
        _buildGenderDropdown(),
        _buildTextField(
            AppLocalizations.of(context)!.weight, _controllers['weight']!,
            keyboardType: TextInputType.number),
        _buildTextField(
            AppLocalizations.of(context)!.height, _controllers['height']!,
            keyboardType: TextInputType.number),
        _buildTextField(
            AppLocalizations.of(context)!.birthday, _controllers['birthday']!,
            isDateField: true),
        _buildTextField(AppLocalizations.of(context)!.phoneNumber,
            _controllers['phoneNumber']!,
            keyboardType: TextInputType.number),
        _buildBloodGroupDropdown(),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          width: 300,
          child: _buildTextField(AppLocalizations.of(context)!.firstName,
              _controllers['firstName']!),
        ),
        SizedBox(
          width: 300,
          child: _buildTextField(AppLocalizations.of(context)!.secondName,
              _controllers['secondName']!),
        ),
        SizedBox(
          width: 300,
          child: _buildTextField(AppLocalizations.of(context)!.thirdName,
              _controllers['thirdName']!),
        ),
        SizedBox(
          width: 300,
          child: _buildTextField(AppLocalizations.of(context)!.forthName,
              _controllers['forthName']!),
        ),
        SizedBox(width: 300, child: _buildGenderDropdown()),
        SizedBox(
          width: 300,
          child: _buildTextField(
              AppLocalizations.of(context)!.weight, _controllers['weight']!,
              keyboardType: TextInputType.number),
        ),
        SizedBox(
          width: 300,
          child: _buildTextField(
              AppLocalizations.of(context)!.height, _controllers['height']!,
              keyboardType: TextInputType.number),
        ),
        SizedBox(
          width: 300,
          child: _buildTextField(
              AppLocalizations.of(context)!.birthday, _controllers['birthday']!,
              isDateField: true),
        ),
        SizedBox(
          width: 300,
          child: _buildTextField(AppLocalizations.of(context)!.phoneNumber,
              _controllers['phoneNumber']!,
              keyboardType: TextInputType.number),
        ),
        SizedBox(width: 300, child: _buildBloodGroupDropdown()),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers to free up resources
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }
}
