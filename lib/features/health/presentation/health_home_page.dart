import 'package:flutter/material.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';

class HealthHomePage extends StatefulWidget {
  const HealthHomePage({super.key});

  @override
  State<HealthHomePage> createState() => _HealthHomePageState();
}

class _HealthHomePageState extends State<HealthHomePage> {
  final ApiClient _api = ApiClient();
  String _output = 'Tap "Check Health" to call backend';
  bool _loading = false;

  Future<void> _checkHealth() async {
    setState(() {
      _loading = true;
    });
    try {
      final data = await _api.health();
      setState(() {
        _output = 'Health data: $data';
      });
    } on ApiException catch (e) {
      setState(() {
        _output = 'API error: ${e.code} - ${e.message}';
      });
    } catch (e) {
      setState(() {
        _output = 'Unexpected error: $e';
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
      appBar: AppBar(title: const Text('SmartPantry')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Environment: ${Env.appEnv}'),
            const SizedBox(height: 6),
            Text('API base: ${Env.apiBaseUrl}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _checkHealth,
              child: Text(_loading ? 'Loading...' : 'Check Health'),
            ),
            const SizedBox(height: 16),
            SelectableText(_output),
          ],
        ),
      ),
    );
  }
}
