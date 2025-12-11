import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber
          ? TextInputType.number
          : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Registrasi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildInputField('First Name', _firstNameController),
              const SizedBox(height: 16.0),

              _buildInputField('Last Name', _lastNameController),
              const SizedBox(height: 16.0),

              _buildInputField('Age', _ageController, isNumber: true),
              const SizedBox(height: 16.0),

              _buildInputField('Email', _emailController, isEmail: true),
              const SizedBox(height: 32.0),
              
            ],
          ),
        ),
      ),
    );
  }
}
