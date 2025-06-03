// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:skincare_app/verify_email.dart';
// import 'firebase_options.dart';
// import 'login.dart';
// import 'signup.dart';
// import 'home_page.dart';
// import 'Welcomescreen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Firebase
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // Lock orientation to portrait only
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   // Set transparent status bar
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//     ),
//   );

//   runApp(const AuraSApp());
// }

// class AuraSApp extends StatelessWidget {
//   const AuraSApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AuraS',
//       debugShowCheckedModeBanner: false,
//       theme: _buildThemeData(),
//       home: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           // Show loading indicator while checking auth state
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           }

//           // User logged in and email verified
//           if (snapshot.hasData && snapshot.data!.emailVerified) {
//             return const HomePage();
//           }

//           // User not logged in or email not verified
//           return const WelcomeScreen();
//         },
//       ),
//       routes: {
//         // '/welcome': (context) => const WelcomeScreen(),
//         // '/login': (context) => const LoginScreen(),
//         // '/signup': (context) => const SignupPage(),
//         // '/home': (context) => const HomePage(),
//         '/startup': (context) => const WelcomeScreen(),
//         '/welcome': (context) => const WelcomeScreen(),
//         '/login': (context) => const LoginScreen(),
//         '/signup': (context) => const SignupPage(),
//         '/home': (context) => const HomePage(),
//         '/verify-email': (context) => const VerifyEmailScreen(),
//       },
//     );
//   }

//   ThemeData _buildThemeData() {
//     return ThemeData(
//       primarySwatch: createMaterialColor(const Color(0xFFE94057)),
//       fontFamily: 'Poppins',
//       scaffoldBackgroundColor: Colors.white,
//       appBarTheme: const AppBarTheme(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       textTheme: const TextTheme(
//         headlineMedium: TextStyle(
//           color: Color(0xFFE94057),
//           fontWeight: FontWeight.bold,
//           fontSize: 28,
//         ),
//         bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
//         labelLarge: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w600,
//           fontSize: 18,
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFFE94057),
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           minimumSize: const Size(double.infinity, 50),
//           textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//         ),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: Colors.grey[100],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide.none,
//         ),
//         hintStyle: TextStyle(color: Colors.grey[400]),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 16,
//         ),
//       ),
//     );
//   }

//   static MaterialColor createMaterialColor(Color color) {
//     final List<double> strengths = <double>[
//       .05,
//       .1,
//       .2,
//       .3,
//       .4,
//       .5,
//       .6,
//       .7,
//       .8,
//       .9,
//     ];
//     final Map<int, Color> swatch = {};
//     final int r = color.red, g = color.green, b = color.blue;

//     for (final strength in strengths) {
//       final double ds = 0.5 - strength;
//       swatch[(strength * 1000).round()] = Color.fromRGBO(
//         r + ((ds < 0 ? r : (255 - r)) * ds).round(),
//         g + ((ds < 0 ? g : (255 - g)) * ds).round(),
//         b + ((ds < 0 ? b : (255 - b)) * ds).round(),
//         1,
//       );
//     }

//     return MaterialColor(color.value, swatch);
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skincare_app/user%20authentication/verify_email.dart';
import 'user authentication/WelcomeScreen.dart';
import 'user authentication/firebase_options.dart';
import 'user authentication/login.dart';
import 'user authentication/signup.dart';
import 'home_page.dart';
// import 'welcomescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Lock orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const AuraSApp());
}

class AuraSApp extends StatelessWidget {
  const AuraSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuraS',
      debugShowCheckedModeBanner: false,
      theme: _buildThemeData(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading indicator while checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final user = snapshot.data;
          
          // User is logged in
          if (user != null) {
            // Check email verification status
            if (user.emailVerified) {
              return const HomePage();
            } else {
              return const VerifyEmailScreen();
            }
          }
          
          // No user logged in
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

  ThemeData _buildThemeData() {
    return ThemeData(
      primarySwatch: createMaterialColor(const Color(0xFFE94057)),
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Color(0xFFE94057),
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
        labelLarge: TextStyle(
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
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  static MaterialColor createMaterialColor(Color color) {
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

    return MaterialColor(color.value, swatch);
  }
}
