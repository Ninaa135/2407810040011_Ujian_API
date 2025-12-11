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

  bool _isLoading = false;

  final Uri _registerUrl = Uri.parse('https://dummyjson.com/users/add');

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final int ageValue = int.parse(_ageController.text);

      final response = await http.post(
        _registerUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          "firstName": _firstNameController.text,
          "lastName": _lastNameController.text,
          "age": ageValue,
          "email": _emailController.text,
        }),
      );

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);
        final String fullName = '${responseData['firstName']} ${responData['lastName']}';

        ScaffoldMassenger.of(context).showSnackBar(
          SnackBar(content: text('Berhasil Mendaftar $fullName]'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          ),
        );
      }
  }

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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        if (isEmail && !value.contains('@')) {
          return 'Masukkan format Email yang valid';
        }
        if (isNumber) {
          if (int.tryParse(value) == null) {
            return '$label harus berupa angka';
          }
        }
        return null;
      },
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

              ElevatedButton(
                onPressed: isLoading ? null : _registerUser,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
