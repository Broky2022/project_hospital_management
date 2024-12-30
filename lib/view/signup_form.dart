import 'package:flutter/material.dart';
import '../database/databasehelper.dart';
import '../models/user.dart';
import '../models/doctor.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _typeController = TextEditingController(); // 'user' or 'doctor'
  final _bioDataController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final type = _typeController.text.toLowerCase();
      final bioData = _bioDataController.text;

      final db = DatabaseHelper.instance;

      if (type == 'doctor') {
        final doctor = Doctor(
          docId: email, // Assuming email as unique identifier
          category: 'General',
          patients: 0,
          experience: 0,
          bioData: bioData,
          status: 'active',
        );
        await db.createDoctor(doctor);
      }

      final user = User(
        name: name,
        type: type,
        email: email,
        password: password,
      );
      await db.createUser(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created successfully! Please login.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Type (user/doctor)'),
                validator: (value) {
                  if (value == null || (value != 'user' && value != 'doctor')) {
                    return 'Please enter either "user" or "doctor"';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bioDataController,
                decoration: InputDecoration(labelText: 'Bio Data (For Doctor only)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
