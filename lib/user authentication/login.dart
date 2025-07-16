// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'signup.dart';
// import '../home_page.dart';
// import '../AdminDermatologistScreen.dart'; // New import
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// String? adminUid;
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _isLoading = false;
//   bool _isAdminLoading = false; // Separate loading state for admin login
//
//   // Admin credentials
//   static const String adminEmail = "admin@auras.com";
//   static const String adminPassword = "admin123";
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 80),
//                 _buildLogo(),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'AuraS',
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Your Skin Journey Starts Here!',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//                 const SizedBox(height: 40),
//                 TextField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: const InputDecoration(
//                     hintText: 'Email',
//                     prefixIcon: Icon(Icons.email),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: !_isPasswordVisible,
//                   decoration: InputDecoration(
//                     hintText: 'Password',
//                     prefixIcon: const Icon(Icons.lock),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordVisible
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () => setState(
//                             () => _isPasswordVisible = !_isPasswordVisible,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: (_isLoading || _isAdminLoading) ? null : _handleSignIn,
//                     child: _isLoading
//                         ? const CircularProgressIndicator()
//                         : const Text('Sign In'),
//                   ),
//                 ),
//
//                 // Admin Login Button
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton(
//                     onPressed: (_isLoading || _isAdminLoading) ? null : _handleAdminLogin,
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Colors.blue),
//                     ),
//                     child: _isAdminLoading
//                         ? const CircularProgressIndicator()
//                         : const Text(
//                       'Admin Login',
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 8),
//                 TextButton(
//                   onPressed: _handleForgotPassword,
//                   child: const Text(
//                     'Forgot Password?',
//                     style: TextStyle(color: Colors.black54),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Don\'t have an account?',
//                       style: TextStyle(color: Colors.black54),
//                     ),
//                     TextButton(
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const SignupPage(),
//                         ),
//                       ),
//                       child: const Text(
//                         'Sign up here',
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLogo() {
//     return SizedBox(
//       height: 150,
//       width: 150,
//       child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
//     );
//   }
//
//   Future<void> _handleSignIn() async {
//     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
//       _showErrorSnackBar('Please fill in all fields');
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//
//       // Check if user is trying to login as admin through regular sign in
//       if (_emailController.text.trim() == adminEmail) {
//         // If admin credentials are used in regular sign in, redirect to admin screen
//         adminUid = userCredential.user?.uid;
//         if (!mounted) return;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const AdminDermatologistScreen()),
//         );
//       } else {
//         // Regular user login - redirect to home page
//         if (!mounted) return;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage()),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       String message = 'An error occurred';
//       if (e.code == 'user-not-found') {
//         message = 'No user found with this email';
//       } else if (e.code == 'wrong-password') {
//         message = 'Incorrect password';
//       } else if (e.code == 'invalid-email') {
//         message = 'Invalid email format';
//       }
//       _showErrorSnackBar(message);
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _handleAdminLogin() async {
//     // Validate that admin credentials are entered
//     if (_emailController.text.trim() != adminEmail ||
//         _passwordController.text.trim() != adminPassword) {
//       _showErrorSnackBar('Please enter admin credentials in the email and password fields');
//       return;
//     }
//
//     setState(() => _isAdminLoading = true);
//
//     try {
//       final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: adminEmail,
//         password: adminPassword,
//       );
//
//       adminUid = userCredential.user?.uid;
//
//       if (!mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const AdminDermatologistScreen()),
//       );
//     } on FirebaseAuthException catch (e) {
//       String message = 'Admin login failed';
//       if (e.code == 'user-not-found') {
//         message = 'Admin account not found. Please contact support.';
//       } else if (e.code == 'wrong-password') {
//         message = 'Incorrect admin credentials';
//       } else if (e.code == 'invalid-email') {
//         message = 'Invalid admin email format';
//       } else {
//         message = 'Admin login failed: ${e.message}';
//       }
//       _showErrorSnackBar(message);
//     } finally {
//       if (mounted) setState(() => _isAdminLoading = false);
//     }
//   }
//
//   Future<void> _handleForgotPassword() async {
//     if (_emailController.text.isEmpty) {
//       _showErrorSnackBar('Please enter your email');
//       return;
//     }
//
//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(
//         email: _emailController.text.trim(),
//       );
//       _showSuccessSnackBar('Password reset email sent');
//     } on FirebaseAuthException catch (e) {
//       _showErrorSnackBar(e.message ?? 'Error sending reset email');
//     }
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }
//
//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.green),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import '../home_page.dart';
import '../AdminDermatologistScreen.dart'; // New import

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

String? adminUid;

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isAdminLoading = false; // Separate loading state for admin login

  // Admin credentials
  static const String adminEmail = "admin@auras.com";
  static const String adminPassword = "admin123";

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
                  'Your Skin Journey Starts Here!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_isLoading || _isAdminLoading) ? null : _handleSignIn,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Sign In'),
                  ),
                ),

                // Admin Login Button
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: (_isLoading || _isAdminLoading) ? null : _handleAdminLogin,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: _isAdminLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                      'Admin Login',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                TextButton(
                  onPressed: _handleForgotPassword,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      ),
                      child: const Text(
                        'Sign up here',
                        style: TextStyle(color: Colors.blue),
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
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }

  Future<void> _handleSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);

    // Prevent admin login through the regular sign-in button
    if (_emailController.text.trim() == adminEmail) {
      _showErrorSnackBar('Please use the Admin Login button');
      setState(() => _isLoading = false);
      return; // Prevent admin login here
    }

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Regular user login - redirect to home page
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format';
      }
      _showErrorSnackBar(message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAdminLogin() async {
    // Validate that admin credentials are entered
    if (_emailController.text.trim() != adminEmail ||
        _passwordController.text.trim() != adminPassword) {
      _showErrorSnackBar('Please enter admin credentials in the email and password fields');
      return;
    }

    setState(() => _isAdminLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: adminEmail,
        password: adminPassword,
      );

      adminUid = userCredential.user?.uid;

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDermatologistScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Admin login failed';
      if (e.code == 'user-not-found') {
        message = 'Admin account not found. Please contact support.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect admin credentials';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid admin email format';
      } else {
        message = 'Admin login failed: ${e.message}';
      }
      _showErrorSnackBar(message);
    } finally {
      if (mounted) setState(() => _isAdminLoading = false);
    }
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      _showSuccessSnackBar('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(e.message ?? 'Error sending reset email');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}
