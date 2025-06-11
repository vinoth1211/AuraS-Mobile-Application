// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// /// Authentication service handling Firebase auth operations
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Auth state changes stream
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
//
//   // Current user
//   User? get currentUser => _auth.currentUser;
//
//   /// Creates new user with email/password and saves user data to Firestore
//   Future<User?> signUpWithEmail({
//     required String email,
//     required String password,
//     required String username,
//   }) async {
//     try {
//       // Validate input
//       _validateEmail(email);
//       _validatePassword(password);
//       _validateUsername(username);
//
//       // Check username availability
//       if (!await isUsernameAvailable(username)) {
//         throw FirebaseAuthException(
//           code: 'username-taken',
//           message: 'Username already taken',
//         );
//       }
//
//       // Create user
//       final UserCredential credential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//
//       // Check user creation
//       final User? user = credential.user;
//       if (user == null) {
//         throw FirebaseAuthException(
//           code: 'user-creation-failed',
//           message: 'User account could not be created',
//         );
//       }
//
//       // Save user data
//       await _firestore.collection('users').doc(user.uid).set({
//         'uid': user.uid,
//         'email': email,
//         'username': username.toLowerCase(),
//         'createdAt': FieldValue.serverTimestamp(),
//         'emailVerified': false,
//         'lastLogin': FieldValue.serverTimestamp(),
//       });
//
//       // Send verification email
//       await user.sendEmailVerification();
//
//       return user;
//     } on FirebaseAuthException catch (e) {
//       throw _handleAuthException(e);
//     } on FirebaseException catch (e) {
//       throw _handleFirestoreException(e);
//     }
//   }
//
//   /// Signs in with email/password
//   Future<User?> signInWithEmail({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       _validateEmail(email);
//       _validatePassword(password);
//
//       final UserCredential credential = await _auth
//           .signInWithEmailAndPassword(email: email, password: password);
//
//       final User? user = credential.user;
//       if (user == null) return null;
//
//       // Check email verification
//       if (!user.emailVerified) {
//         throw FirebaseAuthException(
//           code: 'email-not-verified',
//           message: 'Please verify your email address',
//         );
//       }
//
//       // Update last login time
//       await _updateUserData(user.uid, {'lastLogin': FieldValue.serverTimestamp()});
//
//       return user;
//     } on FirebaseAuthException catch (e) {
//       throw _handleAuthException(e);
//     }
//   }
//
//   /// Signs out current user
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
//
//   /// Sends password reset email
//   Future<void> sendPasswordResetEmail(String email) async {
//     try {
//       _validateEmail(email);
//       await _auth.sendPasswordResetEmail(email: email);
//     } on FirebaseAuthException catch (e) {
//       throw _handleAuthException(e);
//     }
//   }
//
//   /// Checks if username is available
//   Future<bool> isUsernameAvailable(String username) async {
//     final snapshot = await _firestore
//         .collection('users')
//         .where('username', isEqualTo: username.toLowerCase())
//         .limit(1)
//         .get();
//     return snapshot.docs.isEmpty;
//   }
//
//   /// Updates user profile data
//   Future<void> updateProfile({
//     required String uid,
//     required Map<String, dynamic> data,
//   }) async {
//     try {
//       // Remove protected fields
//       data.removeWhere((key, _) =>
//           ['uid', 'email', 'emailVerified', 'createdAt'].contains(key));
//
//       await _updateUserData(uid, data);
//     } on FirebaseException catch (e) {
//       throw _handleFirestoreException(e);
//     }
//   }
//
//   // Helper Methods
//   Future<void> _updateUserData(String uid, Map<String, dynamic> data) async {
//     await _firestore.collection('users').doc(uid).update(data);
//   }
//
//   FirebaseAuthException _handleAuthException(FirebaseAuthException e) {
//     String message;
//     switch (e.code) {
//       case 'invalid-email':
//         message = 'Invalid email address format';
//       case 'email-already-in-use':
//         message = 'Email already registered';
//       case 'weak-password':
//         message = 'Password must be at least 6 characters';
//       case 'user-not-found':
//         message = 'No account found for this email';
//       case 'wrong-password':
//         message = 'Incorrect password';
//       case 'user-disabled':
//         message = 'This account has been disabled';
//       case 'operation-not-allowed':
//         message = 'Email/password accounts are not enabled';
//       case 'email-not-verified':
//         message = 'Please verify your email first';
//       case 'username-taken':
//         message = 'Username already taken';
//       default:
//         message = 'Authentication error: ${e.message}';
//     }
//     return FirebaseAuthException(code: e.code, message: message);
//   }
//
//   FirebaseException _handleFirestoreException(FirebaseException e) {
//     return FirebaseException(
//       code: e.code,
//       message: 'Database error: ${e.message}',
//       plugin: e.plugin,
//     );
//   }
//
//   // Validation Methods
//   void _validateEmail(String email) {
//     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
//       throw FirebaseAuthException(
//         code: 'invalid-email',
//         message: 'Invalid email format',
//       );
//     }
//   }
//
//   void _validatePassword(String password) {
//     if (password.length < 6) {
//       throw FirebaseAuthException(
//         code: 'weak-password',
//         message: 'Password must be at least 6 characters',
//       );
//     }
//   }
//
//   void _validateUsername(String username) {
//     if (username.length < 3) {
//       throw FirebaseAuthException(
//         code: 'invalid-username',
//         message: 'Username must be at least 3 characters',
//       );
//     }
//     if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
//       throw FirebaseAuthException(
//         code: 'invalid-username',
//         message: 'Username can only contain letters, numbers and underscores',
//       );
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Authentication service handling Firebase auth operations
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  /// Creates new user with email/password and saves user data to Firestore
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    required String phoneNumber, // Added phone number parameter
  }) async {
    try {
      // Validate input
      validateEmail(email);
      validatePassword(password);
      validateUsername(username);
      validatePhoneNumber(phoneNumber); // Validate phone number

      // Check username availability
      if (!await isUsernameAvailable(username)) {
        throw FirebaseAuthException(
          code: 'username-taken',
          message: 'Username already taken',
        );
      }

      // Create user
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Check user creation
      final User? user = credential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-creation-failed',
          message: 'User account could not be created',
        );
      }

      // Save user data with phone number
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'username': username.toLowerCase(),
        'phoneNumber': phoneNumber, // Store phone number
        'createdAt': FieldValue.serverTimestamp(),
        'emailVerified': false,
        'lastLogin': FieldValue.serverTimestamp(),
      });

      // Send verification email
      await user.sendEmailVerification();

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } on FirebaseException catch (e) {
      throw _handleFirestoreException(e);
    }
  }

  /// Signs in with email/password
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      validateEmail(email);
      validatePassword(password);

      final UserCredential credential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = credential.user;
      if (user == null) return null;

      // Check email verification
      if (!user.emailVerified) {
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Please verify your email address',
        );
      }

      // Update last login time
      await _updateUserData(user.uid, {'lastLogin': FieldValue.serverTimestamp()});

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Signs out current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Sends password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      validateEmail(email);
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Checks if username is available
  Future<bool> isUsernameAvailable(String username) async {
    final snapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .limit(1)
        .get();
    return snapshot.docs.isEmpty;
  }

  /// Updates user profile data (including phone number)
  Future<void> updateProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Validate phone number if present
      if (data.containsKey('phoneNumber')) {
        validatePhoneNumber(data['phoneNumber']);
      }

      // Remove protected fields
      data.removeWhere((key, _) =>
          ['uid', 'email', 'emailVerified', 'createdAt'].contains(key));

      await _updateUserData(uid, data);
    } on FirebaseException catch (e) {
      throw _handleFirestoreException(e);
    }
  }

  /// Gets user phone number from Firestore
  Future<String?> getUserPhoneNumber(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data()?['phoneNumber'] as String?;
    } catch (e) {
      return null;
    }
  }

  // Helper Methods
  Future<void> _updateUserData(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  FirebaseAuthException _handleAuthException(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'invalid-email':
        message = 'Invalid email address format';
      case 'email-already-in-use':
        message = 'Email already registered';
      case 'weak-password':
        message = 'Password must be at least 6 characters';
      case 'user-not-found':
        message = 'No account found for this email';
      case 'wrong-password':
        message = 'Incorrect password';
      case 'user-disabled':
        message = 'This account has been disabled';
      case 'operation-not-allowed':
        message = 'Email/password accounts are not enabled';
      case 'email-not-verified':
        message = 'Please verify your email first';
      case 'username-taken':
        message = 'Username already taken';
      case 'invalid-phone':
        message = 'Invalid phone number format';
      default:
        message = 'Authentication error: ${e.message}';
    }
    return FirebaseAuthException(code: e.code, message: message);
  }

  FirebaseException _handleFirestoreException(FirebaseException e) {
    return FirebaseException(
      code: e.code,
      message: 'Database error: ${e.message}',
      plugin: e.plugin,
    );
  }

  // Validation Methods
  void validateEmail(String email) {
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Invalid email format',
      );
    }
  }

  void validatePassword(String password) {
    if (password.length < 6) {
      throw FirebaseAuthException(
        code: 'weak-password',
        message: 'Password must be at least 6 characters',
      );
    }
  }

  void validateUsername(String username) {
    if (username.length < 3) {
      throw FirebaseAuthException(
        code: 'invalid-username',
        message: 'Username must be at least 3 characters',
      );
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      throw FirebaseAuthException(
        code: 'invalid-username',
        message: 'Username can only contain letters, numbers and underscores',
      );
    }
  }

  /// Validate phone number format (Sri Lankan format: 10 digits starting with 07)
  void validatePhoneNumber(String phoneNumber) {
    // Remove any non-digit characters
    final cleanedPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Validate Sri Lankan phone numbers (07X XXX XXXX)
    if (!RegExp(r'^07\d{8}$').hasMatch(cleanedPhone)) {
      throw FirebaseAuthException(
        code: 'invalid-phone',
        message: 'Invalid phone number. Use 07XXXXXXXX format',
      );
    }
  }
}