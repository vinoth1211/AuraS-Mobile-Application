import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skincare_app/user%20authentication/verify_email.dart'; // Check if this path is correct for your project structure
import 'user authentication/WelcomeScreen.dart';
import 'user authentication/firebase_options.dart'; // Assuming firebase_options.dart is in lib/
import 'user authentication/login.dart';
import 'user authentication/signup.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // It's good practice to handle potential errors during Firebase initialization
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Log the error or show a user-friendly message
    debugPrint("Firebase initialization failed: $e");
    // Optionally, you might want to stop the app or show an error screen
  }
  runApp(const AuraSApp());
}

class AuraSApp extends StatelessWidget {
  const AuraSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuraS',
      debugShowCheckedModeBanner: false,
      theme: _buildThemeData(context),
      // Pass context if needed by theme, though not in this case
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final user = snapshot.data;

          if (user != null) {
            if (user.emailVerified) {
              return const HomePage();
            } else {
              // Consider passing the user object if VerifyEmailScreen needs it
              return const VerifyEmailScreen();
            }
          }
          return const WelcomeScreen();
        },
      ),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/verify-email': (context) => const VerifyEmailScreen(),
      },
    );
  }

  ThemeData _buildThemeData(BuildContext context) {
    // context is not used here but often is for themes
    return ThemeData(
      primarySwatch: createMaterialColor(const Color(0xFFE94057)),
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        // Consider setting systemOverlayStyle for status bar consistency
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          // For headline5 or headline6 in Material 3
          color: Color(0xFFE94057),
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
        // For bodyText1
        labelLarge: TextStyle(
          // For button text style
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE94057),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          minimumSize: const Size(double.infinity, 50),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          // Good to define for consistency
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          // Good to define for consistency
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFE94057),
            width: 1.5,
          ), // Example focus border
        ),
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16, // Corrected
        ),
      ),
      // Consider adding other theme properties like cardTheme, textButtonTheme, etc.
    );
  }
}

// Helper function to create a MaterialColor from a single Color.
// Moved outside the class for better organization.
MaterialColor createMaterialColor(Color color) {
  final List<double> strengths = <double>[
    .05,
    .1,
    .2,
    .3,
    .4,
    .5,
    .6,
    .7,
    .8,
    .9,
  ];
  final Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (final strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  // Ensure the primary color (shade 500) is the input color itself
  swatch[500] = color;
  return MaterialColor(color.value, swatch);
}
