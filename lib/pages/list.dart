import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'registrasi.dart';

class Todo {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  Todo({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }
}

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  List<Todo> _todos = [];
  bool _isLoading = true;
  String? _errorMessage;

  final Uri _todoUrl = Uri.parse('https://dummyjson.com/todos');

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    try {
      final response = await http.get(_todoUrl);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List todoListJson = responseData['todos'];
        setState(() {
          _todos = todoListJson.map((item) => Todo.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data. Status: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error Jaringan: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 16)),
        ),
      );
    }

    if (_todos.isEmpty) {
      return const Center(child: Text('Tidak ada daftar Todo.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        final todo = _todos[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(
              todo.todo,
              style: TextStyle(
                decoration: todo.completed ? TextDecoration.lineThrough : null,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text('User ID: ${todo.userId}'),
            trailing: Icon(
              todo.completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: todo.completed ? Colors.green : Colors.grey,
            ),
          ),
        );
      },
    );
  }
}