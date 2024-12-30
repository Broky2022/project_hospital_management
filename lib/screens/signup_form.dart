import 'package:flutter/material.dart';
import 'package:project_hospital_management/models/user.dart';
import 'package:provider/provider.dart';
import '../database/databasehelper.dart';
import '../providers/auth_provider.dart'; // Import lớp DataHelper và các model cần thiết

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
    'name': TextEditingController(),
    'age': TextEditingController(),
    'weight': TextEditingController(),
    'address': TextEditingController(),
    'specialty': TextEditingController(),
    'experience': TextEditingController(),
    'description': TextEditingController(),
  };
  String _selectedRole = 'patient';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: ['patient', 'doctor'].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedRole = value!),
              ),
              TextFormField(
                controller: controllers['email'],
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required field' : null,
              ),
              TextFormField(
                controller: controllers['password'],
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required field' : null,
              ),
              if (_selectedRole == 'patient') ...[
                TextFormField(
                  controller: controllers['name'],
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required field' : null,
                ),
                TextFormField(
                  controller: controllers['age'],
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required field' : null,
                ),
                TextFormField(
                  controller: controllers['weight'],
                  decoration: InputDecoration(labelText: 'Weight'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required field' : null,
                ),
                TextFormField(
                  controller: controllers['address'],
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required field' : null,
                ),
              ] else ...[
                TextFormField(
                  controller: controllers['specialty'],
                  decoration: InputDecoration(labelText: 'Specialty'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required field' : null,
                ),
                TextFormField(
                  controller: controllers['experience'],
                  decoration: InputDecoration(labelText: 'Years of Experience'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required field' : null,
                ),
              ],
              TextFormField(
                controller: controllers['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final userData = controllers.map(
                      (key, controller) => MapEntry(key, controller.text),
                    );
                    final success = await context
                        .read<AuthProvider>()
                        .signup(userData, _selectedRole);
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Account created successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create account')),
                      );
                    }
                  }
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
