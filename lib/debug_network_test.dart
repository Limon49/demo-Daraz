import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkTestScreen extends StatefulWidget {
  const NetworkTestScreen({super.key});

  @override
  State<NetworkTestScreen> createState() => _NetworkTestScreenState();
}

class _NetworkTestScreenState extends State<NetworkTestScreen> {
  String _result = 'Tap button to test network';
  bool _loading = false;

  Future<void> _testNetwork() async {
    setState(() {
      _loading = true;
      _result = 'Testing...';
    });

    try {
      // Test 1: Simple GET request
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products/1'),
      ).timeout(const Duration(seconds: 10));
      
      setState(() {
        _result = 'GET Test:\nStatus: ${response.statusCode}\nBody: ${response.body.substring(0, 200)}...';
      });

      // Test 2: Login request
      final loginResponse = await http.post(
        Uri.parse('https://fakestoreapi.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': 'mor_2314', 'password': '83r5^_'}),
      ).timeout(const Duration(seconds: 10));

      setState(() {
        _result += '\n\nLogin Test:\nStatus: ${loginResponse.statusCode}\nBody: ${loginResponse.body}';
      });

    } catch (e) {
      setState(() {
        _result = 'Network Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _testNetwork,
                child: _loading 
                  ? const CircularProgressIndicator() 
                  : const Text('Test Network'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_result),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
