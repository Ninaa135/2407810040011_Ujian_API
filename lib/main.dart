import 'package:flutter/material.dart';
import 'package:nina_2407810040011_ujian_api/pages/list.dart';
import 'package:nina_2407810040011_ujian_api/pages/registrasi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ujian API Dummy JSON',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Register(),
    );
  }
}