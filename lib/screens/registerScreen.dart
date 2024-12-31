// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/id_generator.dart';
import '../providers/auth_provider.dart';
import '../models/doctor.dart';
import '../models/patient.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isDoctor = true;
  bool _isLoading = false;
  String? _generatedId;

  // Common fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Doctor specific fields
  final _specializationController = TextEditingController();
  final _yearsExpController = TextEditingController();
  final _doctorDescriptionController = TextEditingController();

  // Patient specific fields
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _addressController = TextEditingController();
  final _patientDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateId();
  }

  Future<void> _generateId() async {
    setState(() => _isLoading = true);
    try {
      _generatedId = isDoctor
          ? await IDGenerator.instance.generateDoctorId()
          : await IDGenerator.instance.generatePatientId();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildCommonFields() {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email';
            }
            if (!value.contains('@')) {
              return 'Please enter valid email';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDoctorFields() {
    return Column(
      children: [
        TextFormField(
          controller: _specializationController,
          decoration: InputDecoration(
            labelText: 'Specialization',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.medical_services),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter specialization' : null,
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _yearsExpController,
          decoration: InputDecoration(
            labelText: 'Years of Experience',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.timeline),
          ),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true
              ? 'Please enter years of experience'
              : null,
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _doctorDescriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: 3,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter description' : null,
        ),
      ],
    );
  }

  Widget _buildPatientFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter full name' : null,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter age' : null,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter weight' : null,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter address' : null,
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _patientDescriptionController,
          decoration: InputDecoration(
            labelText: 'Medical History/Description',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: 3,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter medical history' : null,
        ),
      ],
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success = false;

      try {
        if (isDoctor && _generatedId != null) {
          final doctor = Doctor(
            email: _emailController.text,
            password: _passwordController.text,
            doctorId: _generatedId!,
            specialization: _specializationController.text,
            yearsOfExperience: int.parse(_yearsExpController.text),
            description: _doctorDescriptionController.text,
            status: 'Active',
          );
          success = await authProvider.register(doctor);
        } else if (!isDoctor && _generatedId != null) {
          final patient = Patient(
            email: _emailController.text,
            password: _passwordController.text,
            patientId: _generatedId!,
            name: _nameController.text,
            age: int.parse(_ageController.text),
            weight: double.parse(_weightController.text),
            address: _addressController.text,
            diseaseId: 0,
            description: _patientDescriptionController.text,
          );
          success = await authProvider.register(patient);
        }

        if (success) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Role Switch
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Register as:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Switch(
                        value: isDoctor,
                        onChanged: (value) {
                          setState(() {
                            isDoctor = value;
                          });
                          _generateId();
                        },
                      ),
                      Text(
                        isDoctor ? 'Doctor' : 'Patient',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Common Fields
              _buildCommonFields(),
              SizedBox(height: 24),

              // Role-specific Fields
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: isDoctor ? _buildDoctorFields() : _buildPatientFields(),
              ),

              SizedBox(height: 32),

              // Register Button
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _register,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

              SizedBox(height: 16),

              // Login Link
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _specializationController.dispose();
    _yearsExpController.dispose();
    _doctorDescriptionController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _addressController.dispose();
    _patientDescriptionController.dispose();
    super.dispose();
  }
}
