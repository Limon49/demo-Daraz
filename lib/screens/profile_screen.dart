import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().user;
    return user == null
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40), // Add top padding for status bar
                CircleAvatar(radius: 40, child: Text(user.firstName[0].toUpperCase(), style: const TextStyle(fontSize: 32))),
                const SizedBox(height: 16),
                Text('${user.firstName} ${user.lastName}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(user.email, style: const TextStyle(color: Colors.grey)),
                Text(user.phone),
                const Divider(height: 32),
                ListTile(leading: const Icon(Icons.person), title: Text('Username: ${user.username}')),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  onPressed: () {
                    context.read<AppProvider>().logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (_) => false,
                    );
                  },
                ),
              ],
            ),
          );
  }
}
