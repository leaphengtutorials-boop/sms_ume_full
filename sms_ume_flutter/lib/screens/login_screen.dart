import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primary, Color(0xFF8B5CF6)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('📚', style: TextStyle(fontSize: 60)),
                    const SizedBox(height: 12),
                    const Text(
                      'ប្រព័ន្ធគ្រប់គ្រងសិស្ស',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Student Management System',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 32),

                    TextField(
                      controller: _usernameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'ឈ្មោះអ្នកប្រើ',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _passwordCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'លេខសម្ងាត់',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Consumer<AuthProvider>(
                      builder: (context, auth, _) {
                        if (auth.error != null) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              auth.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          return ElevatedButton(
                            onPressed: auth.loading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: auth.loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'ចូលប្រើ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Default: admin / password',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final ok = await auth.login(_usernameCtrl.text, _passwordCtrl.text);
    if (ok && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }
}