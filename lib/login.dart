import 'package:flutter/material.dart';
import 'signup.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                _buildLogo(),
                const SizedBox(height: 16),
                const Text(
                  'AuraS',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Your Skin Journey Start Here!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 40),
                // Email Field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                const SizedBox(height: 16),
                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 8),
                // Forgot Password
                TextButton(
                  onPressed: _handleForgotPassword,
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(height: 16),
                // Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'don\'t have an account?',
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign up here',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      height: 150,
      width: 150,
      child: Image.asset(
        'assets/images/logo.png', // Your logo image path
        fit: BoxFit.contain,
      ),
    );
  }

  void _handleSignIn() {
    // TODO: Implement sign in logic
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Navigate to home page after successful login
    // Navigator.pushReplacementNamed(context, '/home');
  }

  void _handleForgotPassword() {
    // TODO: Implement forgot password logic
    // Navigator.pushNamed(context, '/forgot-password');
  }

  void _handleSignUp() {
    // TODO: Implement sign up navigation
    // Navigator.pushNamed(context, '/signup');
  }
}

// Custom painter for creating the logo's triangular shapes
class TrianglePainter extends CustomPainter {
  final Color color;
  final bool isTopTriangle;

  TrianglePainter({required this.color, required this.isTopTriangle});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final Path path = Path();

    if (isTopTriangle) {
      // Top triangle (pointing down)
      path.moveTo(size.width / 2, 0);
      path.lineTo(0, size.height * 0.5);
      path.lineTo(size.width, size.height * 0.5);
    } else {
      // Bottom triangle (pointing up)
      path.moveTo(0, size.height * 0.5);
      path.lineTo(size.width, size.height * 0.5);
      path.lineTo(size.width / 2, size.height);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
