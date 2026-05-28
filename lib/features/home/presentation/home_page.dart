import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/app_services.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_exception.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _status = 'Loading profile...';
  bool _loadingHealth = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = await AppServices.authRepository.currentUser();
      setState(() {
        _status = user != null
            ? 'Signed in as ${user.email}'
            : 'Could not load profile';
      });
    } on ApiException catch (e) {
      setState(() => _status = e.message);
    }
  }

  Future<void> _checkHealth() async {
    setState(() => _loadingHealth = true);
    try {
      final data = await AppServices.apiClient.health();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Health: ${data['status']}')),
      );
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingHealth = false);
      }
    }
  }

  Future<void> _logout() async {
    await AppServices.authRepository.logout();
    if (!mounted) {
      return;
    }
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartPantry'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_status, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadingHealth ? null : _checkHealth,
              child: Text(_loadingHealth ? 'Checking...' : 'Check API health'),
            ),
          ],
        ),
      ),
    );
  }
}
