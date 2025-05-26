import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isLoading = false;
  bool _isEmailVerified = false;
  Timer? _verificationTimer;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _startVerificationChecks();
  }

  void _startVerificationChecks() {
    // Immediate check when screen loads
    _checkEmailVerification();
    // Periodic checks every 5 seconds
    _verificationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkEmailVerification();
    });
  }

  Future<void> _checkEmailVerification() async {
    if (_currentUser == null) return;

    await _currentUser!.reload();
    _currentUser = FirebaseAuth.instance.currentUser;

    final isVerified = _currentUser?.emailVerified ?? false;

    if (isVerified && mounted) {
      _verificationTimer?.cancel();
      Navigator.pushReplacementNamed(context, '/home');
    } else if (mounted) {
      setState(() => _isEmailVerified = isVerified);
    }
  }

  Future<void> _resendVerificationEmail() async {
    try {
      setState(() => _isLoading = true);
      await _currentUser?.sendEmailVerification();
      _showSuccessSnackBar('Verification email resent');
      // Trigger immediate check after resending
      _checkEmailVerification();
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(e.message ?? 'Failed to resend verification email');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    super.dispose();
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isEmailVerified ? Icons.verified : Icons.email_outlined,
              size: 80,
              color: _isEmailVerified ? Colors.green : Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              _isEmailVerified 
                  ? 'Email Verified Successfully!'
                  : 'Verification Email Sent',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _isEmailVerified ? Colors.green : Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                _isEmailVerified
                    ? 'You will be redirected shortly...'
                    : 'Check your inbox at ${_currentUser?.email} and verify your email address',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (!_isEmailVerified)
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _resendVerificationEmail,
                icon: const Icon(Icons.email),
                label: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Resend Verification Email'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Return to Login'),
            ),
          ],
        ),
      ),
    );
  }
}