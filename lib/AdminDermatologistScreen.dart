// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:skincare_app/dermatologist_model.dart';
//
// class AdminDermatologistScreen extends StatefulWidget {
//   const AdminDermatologistScreen({super.key});
//
//   @override
//   State<AdminDermatologistScreen> createState() => _AdminDermatologistScreenState();
// }
//
// class _AdminDermatologistScreenState extends State<AdminDermatologistScreen>
//     with TickerProviderStateMixin {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<Dermatologist> _allDermatologists = [];
//   List<Dermatologist> _filteredDermatologists = [];
//   final TextEditingController _searchController = TextEditingController();
//   bool _isLoading = true;
//
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _fetchDermatologists();
//     _searchController.addListener(_filterDermatologists);
//   }
//
//   void _initializeAnimations() {
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeInOut,
//     ));
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _slideController,
//       curve: Curves.elasticOut,
//     ));
//
//     _fadeController.forward();
//     _slideController.forward();
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.red.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
//
//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle_outline, color: Colors.white),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.green.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
//
//   Future<void> _fetchDermatologists() async {
//     try {
//       setState(() => _isLoading = true);
//
//       final snapshot = await _firestore
//           .collection('dermatologists')
//           .where('isActive', isEqualTo: true)
//           .get();
//
//       final docs = snapshot.docs.map((doc) =>
//           Dermatologist.fromMap(doc.id, doc.data())
//       ).toList();
//
//       setState(() {
//         _allDermatologists = docs;
//         _filteredDermatologists = docs;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showErrorSnackBar('Error fetching dermatologists: $e');
//     }
//   }
//
//   void _filterDermatologists() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       if (query.isEmpty) {
//         _filteredDermatologists = _allDermatologists;
//       } else {
//         _filteredDermatologists = _allDermatologists.where(
//               (derm) => derm.name.toLowerCase().contains(query) ||
//               derm.location.toLowerCase().contains(query) ||
//               derm.specialty.toLowerCase().contains(query),
//         ).toList();
//       }
//     });
//   }
//
//   void _addNewDermatologist() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => DermatologistForm(
//         onSave: (derm) => _saveDermatologist(derm),
//       ),
//     );
//   }
//
//   void _editDermatologist(Dermatologist dermatologist) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => DermatologistForm(
//         dermatologist: dermatologist,
//         onSave: (derm) => _updateDermatologist(derm),
//       ),
//     );
//   }
//
//   Future<void> _saveDermatologist(Dermatologist derm) async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _showErrorSnackBar('Admin not authenticated. Please log in again.');
//       return;
//     }
//
//     try {
//       await _firestore.collection('dermatologists').add({
//         ...derm.toMap(),
//         'isActive': true,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//
//       await _fetchDermatologists();
//       _showSuccessSnackBar('Dermatologist added successfully');
//     } catch (e) {
//       _showErrorSnackBar('Error adding dermatologist: $e');
//     }
//   }
//
//   Future<void> _updateDermatologist(Dermatologist derm) async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _showErrorSnackBar('Admin not authenticated. Please log in again.');
//       return;
//     }
//
//     try {
//       await _firestore.collection('dermatologists').doc(derm.id).update({
//         ...derm.toMap(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//
//       await _fetchDermatologists();
//       _showSuccessSnackBar('Dermatologist updated successfully');
//     } catch (e) {
//       _showErrorSnackBar('Error updating dermatologist: $e');
//     }
//   }
//
//   Future<void> _deleteDermatologist(String id, String name) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Confirm Deletion'),
//         content: Text('Are you sure you want to delete Dr. $name?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//
//     if (confirmed != true) return;
//
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _showErrorSnackBar('Admin not authenticated. Please log in again.');
//       return;
//     }
//
//     try {
//       await _firestore.collection('dermatologists').doc(id).update({
//         'isActive': false,
//         'deletedAt': FieldValue.serverTimestamp(),
//       });
//
//       await _fetchDermatologists();
//       _showSuccessSnackBar('Dermatologist deleted successfully');
//     } catch (e) {
//       _showErrorSnackBar('Error deleting dermatologist: $e');
//     }
//   }
//
//   void _signOut() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       if (mounted) {
//         Navigator.of(context).pushReplacementNamed('/login');
//       }
//     } catch (e) {
//       _showErrorSnackBar('Error signing out: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text(
//           'Manage Dermatologists',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: _signOut,
//           tooltip: 'Back to Login',
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 8),
//             child: IconButton(
//               icon: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade600,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(Icons.add, color: Colors.white),
//               ),
//               onPressed: _addNewDermatologist,
//               tooltip: 'Add Dermatologist',
//             ),
//           ),
//         ],
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: Column(
//             children: [
//               // Header Stats Card
//               Container(
//                 margin: const EdgeInsets.all(16),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.blue.shade600, Colors.blue.shade400],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.blue.shade200,
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.local_hospital, color: Colors.white, size: 32),
//                     const SizedBox(width: 16),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Total Dermatologists',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.9),
//                             fontSize: 14,
//                           ),
//                         ),
//                         Text(
//                           '${_allDermatologists.length}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Search Bar
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     labelText: 'Search dermatologists...',
//                     prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
//                     suffixIcon: _searchController.text.isNotEmpty
//                         ? IconButton(
//                       icon: const Icon(Icons.clear),
//                       onPressed: () {
//                         _searchController.clear();
//                         _filterDermatologists();
//                       },
//                     )
//                         : null,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Dermatologists List
//               Expanded(
//                 child: _isLoading
//                     ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           Colors.blue.shade600,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Loading dermatologists...',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                     : _filteredDermatologists.isEmpty
//                     ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.search_off,
//                         size: 64,
//                         color: Colors.grey.shade400,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         _searchController.text.isEmpty
//                             ? 'No dermatologists found'
//                             : 'No results for "${_searchController.text}"',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                     : ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: _filteredDermatologists.length,
//                   itemBuilder: (context, index) {
//                     final derm = _filteredDermatologists[index];
//                     return TweenAnimationBuilder<double>(
//                       duration: Duration(milliseconds: 300 + (index * 100)),
//                       tween: Tween(begin: 0.0, end: 1.0),
//                       builder: (context, value, child) {
//                         return Transform.translate(
//                           offset: Offset(0, 50 * (1 - value)),
//                           child: Opacity(
//                             opacity: value,
//                             child: Container(
//                               margin: const EdgeInsets.only(bottom: 12),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(16),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.shade200,
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: ListTile(
//                                 contentPadding: const EdgeInsets.all(16),
//                                 leading: Hero(
//                                   tag: 'doctor_${derm.id}',
//                                   child: Container(
//                                     width: 60,
//                                     height: 60,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.grey.shade300,
//                                           blurRadius: 8,
//                                           offset: const Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: CircleAvatar(
//                                       radius: 30,
//                                       backgroundColor: Colors.grey.shade200,
//                                       backgroundImage: derm.imageAsset.isNotEmpty
//                                           ? AssetImage(derm.imageAsset)
//                                           : null,
//                                       child: derm.imageAsset.isEmpty
//                                           ? Icon(
//                                         Icons.person,
//                                         size: 30,
//                                         color: Colors.grey.shade600,
//                                       )
//                                           : null,
//                                     ),
//                                   ),
//                                 ),
//                                 title: Text(
//                                   derm.name,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       derm.specialty,
//                                       style: TextStyle(
//                                         color: Colors.blue.shade600,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 2),
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.location_on,
//                                           size: 14,
//                                           color: Colors.grey.shade600,
//                                         ),
//                                         const SizedBox(width: 2),
//                                         Expanded(
//                                           child: Text(
//                                             derm.location,
//                                             style: TextStyle(
//                                               color: Colors.grey.shade600,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.blue.shade50,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.edit,
//                                           color: Colors.blue.shade600,
//                                           size: 20,
//                                         ),
//                                         onPressed: () => _editDermatologist(derm),
//                                         tooltip: 'Edit',
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.red.shade50,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.delete,
//                                           color: Colors.red.shade600,
//                                           size: 20,
//                                         ),
//                                         onPressed: () => _deleteDermatologist(derm.id, derm.name),
//                                         tooltip: 'Delete',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 onTap: () => _editDermatologist(derm),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class DermatologistForm extends StatefulWidget {
//   final Dermatologist? dermatologist;
//   final Function(Dermatologist) onSave;
//
//   const DermatologistForm({
//     super.key,
//     this.dermatologist,
//     required this.onSave,
//   });
//
//   @override
//   State<DermatologistForm> createState() => _DermatologistFormState();
// }
//
// class _DermatologistFormState extends State<DermatologistForm>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _specialtyController;
//   late TextEditingController _locationController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _imageAssetController;
//   late TextEditingController _ratingController;
//   late TextEditingController _emailController;
//   late List<String> _workingDays;
//   late TimeOfDay _startTime;
//   late TimeOfDay _endTime;
//   bool _isSaving = false;
//
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _initializeFormData();
//   }
//
//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );
//
//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.elasticOut,
//     ));
//
//     _animationController.forward();
//   }
//
//   void _initializeFormData() {
//     final derm = widget.dermatologist;
//     _nameController = TextEditingController(text: derm?.name ?? '');
//     _specialtyController = TextEditingController(text: derm?.specialty ?? '');
//     _locationController = TextEditingController(text: derm?.location ?? '');
//     _descriptionController = TextEditingController(text: derm?.description ?? '');
//     _imageAssetController = TextEditingController(text: derm?.imageAsset ?? '');
//     _ratingController = TextEditingController(text: derm?.rating.toString() ?? '4.5');
//     _emailController = TextEditingController(text: derm?.email ?? '');
//     _workingDays = List.from(derm?.workingDays ?? ['Monday', 'Wednesday', 'Friday']);
//     _startTime = derm?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
//     _endTime = derm?.endTime ?? const TimeOfDay(hour: 17, minute: 0);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _nameController.dispose();
//     _specialtyController.dispose();
//     _locationController.dispose();
//     _descriptionController.dispose();
//     _imageAssetController.dispose();
//     _ratingController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _selectTime(BuildContext context, bool isStartTime) async {
//     final selectedTime = await showTimePicker(
//       context: context,
//       initialTime: isStartTime ? _startTime : _endTime,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Colors.blue.shade600,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (selectedTime != null) {
//       setState(() {
//         if (isStartTime) {
//           _startTime = selectedTime;
//         } else {
//           _endTime = selectedTime;
//         }
//       });
//     }
//   }
//
//   void _saveForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isSaving = true);
//
//       try {
//         final dermatologist = Dermatologist(
//           id: widget.dermatologist?.id ?? '',
//           name: _nameController.text.trim(),
//           // specialty: _specialtyController.text.trim(),
//           location: _locationController.text.trim(),
//           description: _descriptionController.text.trim(),
//           imageAsset: _imageAssetController.text.trim(),
//           rating: double.parse(_ratingController.text),
//           email: _emailController.text.trim(),
//           workingDays: _workingDays,
//           startTime: _startTime,
//           endTime: _endTime,
//         );
//
//         widget.onSave(dermatologist);
//         Navigator.pop(context);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } finally {
//         if (mounted) {
//           setState(() => _isSaving = false);
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: ScaleTransition(
//         scale: _scaleAnimation,
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.9,
//           height: MediaQuery.of(context).size.height * 0.85,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 20,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               // Header
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.blue.shade600, Colors.blue.shade400],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       widget.dermatologist == null ? Icons.person_add : Icons.edit,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         widget.dermatologist == null
//                             ? 'Add New Dermatologist'
//                             : 'Edit Dermatologist',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Form Content
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildTextField(
//                           controller: _nameController,
//                           label: 'Full Name',
//                           icon: Icons.person,
//                           validator: (value) => value?.isEmpty == true ? 'Please enter a name' : null,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _specialtyController,
//                           label: 'Specialty',
//                           icon: Icons.medical_services,
//                           validator: (value) => value?.isEmpty == true ? 'Please enter specialty' : null,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _locationController,
//                           label: 'Location',
//                           icon: Icons.location_on,
//                           validator: (value) => value?.isEmpty == true ? 'Please enter location' : null,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _descriptionController,
//                           label: 'Description',
//                           icon: Icons.description,
//                           maxLines: 3,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _imageAssetController,
//                           label: 'Image Asset Path',
//                           icon: Icons.image,
//                         ),
//                         const SizedBox(height: 16),
//
//                         Row(
//                           children: [
//                             Expanded(
//                               child: _buildTextField(
//                                 controller: _ratingController,
//                                 label: 'Rating',
//                                 icon: Icons.star,
//                                 keyboardType: TextInputType.number,
//                                 validator: (value) {
//                                   if (value?.isEmpty == true) return 'Please enter rating';
//                                   final rating = double.tryParse(value!);
//                                   if (rating == null || rating < 0 || rating > 5) {
//                                     return 'Rating must be 0-5';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               flex: 2,
//                               child: _buildTextField(
//                                 controller: _emailController,
//                                 label: 'Email',
//                                 icon: Icons.email,
//                                 keyboardType: TextInputType.emailAddress,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Working Days
//                         const Text(
//                           'Working Days',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: [
//                             'Monday', 'Tuesday', 'Wednesday',
//                             'Thursday', 'Friday', 'Saturday', 'Sunday'
//                           ].map((day) {
//                             final isSelected = _workingDays.contains(day);
//                             return FilterChip(
//                               label: Text(day),
//                               selected: isSelected,
//                               onSelected: (selected) {
//                                 setState(() {
//                                   if (selected) {
//                                     _workingDays.add(day);
//                                   } else {
//                                     _workingDays.remove(day);
//                                   }
//                                 });
//                               },
//                               selectedColor: Colors.blue.shade600,
//                               checkmarkColor: Colors.white,
//                               backgroundColor: Colors.grey.shade100,
//                               labelStyle: TextStyle(
//                                 color: isSelected ? Colors.white : Colors.grey.shade700,
//                                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Working Hours
//                         const Text(
//                           'Working Hours',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade50,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.grey.shade300),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Start Time',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     InkWell(
//                                       onTap: () => _selectTime(context, true),
//                                       child: Row(
//                                         children: [
//                                           Icon(Icons.access_time,
//                                               color: Colors.blue.shade600, size: 20),
//                                           const SizedBox(width: 8),
//                                           Text(
//                                             _startTime.format(context),
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade50,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.grey.shade300),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'End Time',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     InkWell(
//                                       onTap: () => _selectTime(context, false),
//                                       child: Row(
//                                         children: [
//                                           Icon(Icons.access_time,
//                                               color: Colors.blue.shade600, size: 20),
//                                           const SizedBox(width: 8),
//                                           Text(
//                                             _endTime.format(context),
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Action Buttons
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(20),
//                     bottomRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: _isSaving ? null : () => Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           side: BorderSide(color: Colors.grey.shade400),
//                         ),
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: _isSaving ? null : _saveForm,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue.shade600,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: _isSaving
//                             ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                             : Text(
//                           widget.dermatologist == null ? 'Add Doctor' : 'Update Doctor',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     String? Function(String?)? validator,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//   }) {
//     return TextFormField(
//       controller: controller,
//       validator: validator,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.blue.shade600),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//         filled: true,
//         fillColor: Colors.grey.shade50,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       ),
//     );
//   }
// }


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:skincare_app/dermatologist_model.dart';
//
// class AdminDermatologistScreen extends StatefulWidget {
//   const AdminDermatologistScreen({super.key});
//
//   @override
//   State<AdminDermatologistScreen> createState() => _AdminDermatologistScreenState();
// }
//
// class _AdminDermatologistScreenState extends State<AdminDermatologistScreen>
//     with TickerProviderStateMixin {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<Dermatologist> _allDermatologists = [];
//   List<Dermatologist> _filteredDermatologists = [];
//   final TextEditingController _searchController = TextEditingController();
//   bool _isLoading = true;
//
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _fetchDermatologists();
//     _searchController.addListener(_filterDermatologists);
//   }
//
//   void _initializeAnimations() {
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeInOut,
//     ));
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _slideController,
//       curve: Curves.elasticOut,
//     ));
//
//     _fadeController.forward();
//     _slideController.forward();
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.red.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
//
//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle_outline, color: Colors.white),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.green.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
//
//   Future<void> _fetchDermatologists() async {
//     try {
//       setState(() => _isLoading = true);
//
//       final snapshot = await _firestore
//           .collection('dermatologists')
//           .where('isActive', isEqualTo: true)
//           .get();
//
//       final docs = snapshot.docs.map((doc) =>
//           Dermatologist.fromMap(doc.id, doc.data())
//       ).toList();
//
//       setState(() {
//         _allDermatologists = docs;
//         _filteredDermatologists = docs;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showErrorSnackBar('Error fetching dermatologists: $e');
//     }
//   }
//
//   void _filterDermatologists() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       if (query.isEmpty) {
//         _filteredDermatologists = _allDermatologists;
//       } else {
//         _filteredDermatologists = _allDermatologists.where(
//               (derm) => derm.name.toLowerCase().contains(query) ||
//               derm.location.toLowerCase().contains(query) ||
//               derm.specialty.toLowerCase().contains(query),
//         ).toList();
//       }
//     });
//   }
//
//   void _addNewDermatologist() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => DermatologistForm(
//         onSave: (derm) => _saveDermatologist(derm),
//       ),
//     );
//   }
//
//   void _editDermatologist(Dermatologist dermatologist) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => DermatologistForm(
//         dermatologist: dermatologist,
//         onSave: (derm) => _updateDermatologist(derm),
//       ),
//     );
//   }
//
//   Future<void> _saveDermatologist(Dermatologist derm) async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _showErrorSnackBar('Admin not authenticated. Please log in again.');
//       return;
//     }
//
//     try {
//       await _firestore.collection('dermatologists').add({
//         ...derm.toMap(),
//         'isActive': true,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//
//       await _fetchDermatologists();
//       _showSuccessSnackBar('Dermatologist added successfully');
//     } catch (e) {
//       _showErrorSnackBar('Error adding dermatologist: $e');
//     }
//   }
//
//   Future<void> _updateDermatologist(Dermatologist derm) async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _showErrorSnackBar('Admin not authenticated. Please log in again.');
//       return;
//     }
//
//     try {
//       await _firestore.collection('dermatologists').doc(derm.id).update({
//         ...derm.toMap(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//
//       await _fetchDermatologists();
//       _showSuccessSnackBar('Dermatologist updated successfully');
//     } catch (e) {
//       _showErrorSnackBar('Error updating dermatologist: $e');
//     }
//   }
//
//   Future<void> _deleteDermatologist(String id, String name) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Confirm Deletion'),
//         content: Text('Are you sure you want to delete Dr. $name?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//
//     if (confirmed != true) return;
//
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _showErrorSnackBar('Admin not authenticated. Please log in again.');
//       return;
//     }
//
//     try {
//       await _firestore.collection('dermatologists').doc(id).update({
//         'isActive': false,
//         'deletedAt': FieldValue.serverTimestamp(),
//       });
//
//       await _fetchDermatologists();
//       _showSuccessSnackBar('Dermatologist deleted successfully');
//     } catch (e) {
//       _showErrorSnackBar('Error deleting dermatologist: $e');
//     }
//   }
//
//   void _signOut() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       if (mounted) {
//         Navigator.of(context).pushReplacementNamed('/login');
//       }
//     } catch (e) {
//       _showErrorSnackBar('Error signing out: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text(
//           'Manage Dermatologists',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: _signOut,
//           tooltip: 'Back to Login',
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 8),
//             child: IconButton(
//               icon: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade600,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(Icons.add, color: Colors.white),
//               ),
//               onPressed: _addNewDermatologist,
//               tooltip: 'Add Dermatologist',
//             ),
//           ),
//         ],
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: Column(
//             children: [
//               // Header Stats Card
//               Container(
//                 margin: const EdgeInsets.all(16),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.blue.shade600, Colors.blue.shade400],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.blue.shade200,
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.local_hospital, color: Colors.white, size: 32),
//                     const SizedBox(width: 16),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Total Dermatologists',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.9),
//                             fontSize: 14,
//                           ),
//                         ),
//                         Text(
//                           '${_allDermatologists.length}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Search Bar
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     labelText: 'Search dermatologists...',
//                     prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
//                     suffixIcon: _searchController.text.isNotEmpty
//                         ? IconButton(
//                       icon: const Icon(Icons.clear),
//                       onPressed: () {
//                         _searchController.clear();
//                         _filterDermatologists();
//                       },
//                     )
//                         : null,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Dermatologists List
//               Expanded(
//                 child: _isLoading
//                     ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Loading dermatologists...',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                     : _filteredDermatologists.isEmpty
//                     ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.search_off,
//                         size: 64,
//                         color: Colors.grey.shade400,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         _searchController.text.isEmpty
//                             ? 'No dermatologists found'
//                             : 'No results for "${_searchController.text}"',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                     : ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: _filteredDermatologists.length,
//                   itemBuilder: (context, index) {
//                     final derm = _filteredDermatologists[index];
//                     return TweenAnimationBuilder<double>(
//                       duration: Duration(milliseconds: 300 + (index * 100)),
//                       tween: Tween(begin: 0.0, end: 1.0),
//                       builder: (context, value, child) {
//                         return Transform.translate(
//                           offset: Offset(0, 50 * (1 - value)),
//                           child: Opacity(
//                             opacity: value,
//                             child: Container(
//                               margin: const EdgeInsets.only(bottom: 12),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(16),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.shade200,
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: ListTile(
//                                 contentPadding: const EdgeInsets.all(16),
//                                 leading: Hero(
//                                   tag: 'doctor_${derm.id}',
//                                   child: Container(
//                                     width: 60,
//                                     height: 60,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.grey.shade300,
//                                           blurRadius: 8,
//                                           offset: const Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: CircleAvatar(
//                                       radius: 30,
//                                       backgroundColor: Colors.grey.shade200,
//                                       backgroundImage: derm.imageAsset.isNotEmpty
//                                           ? AssetImage(derm.imageAsset)
//                                           : null,
//                                       child: derm.imageAsset.isEmpty
//                                           ? Icon(
//                                         Icons.person,
//                                         size: 30,
//                                         color: Colors.grey.shade600,
//                                       )
//                                           : null,
//                                     ),
//                                   ),
//                                 ),
//                                 title: Text(
//                                   derm.name,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       derm.specialty,
//                                       style: TextStyle(
//                                         color: Colors.blue.shade600,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 2),
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.location_on,
//                                           size: 14,
//                                           color: Colors.grey.shade600,
//                                         ),
//                                         const SizedBox(width: 2),
//                                         Expanded(
//                                           child: Text(
//                                             derm.location,
//                                             style: TextStyle(
//                                               color: Colors.grey.shade600,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.blue.shade50,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.edit,
//                                           color: Colors.blue.shade600,
//                                           size: 20,
//                                         ),
//                                         onPressed: () => _editDermatologist(derm),
//                                         tooltip: 'Edit',
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.red.shade50,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.delete,
//                                           color: Colors.red.shade600,
//                                           size: 20,
//                                         ),
//                                         onPressed: () => _deleteDermatologist(derm.id, derm.name),
//                                         tooltip: 'Delete',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 onTap: () => _editDermatologist(derm),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class DermatologistForm extends StatefulWidget {
//   final Dermatologist? dermatologist;
//   final Function(Dermatologist) onSave;
//
//   const DermatologistForm({
//     super.key,
//     this.dermatologist,
//     required this.onSave,
//   });
//
//   @override
//   State<DermatologistForm> createState() => _DermatologistFormState();
// }
//
// class _DermatologistFormState extends State<DermatologistForm>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _specialtyController;
//   late TextEditingController _locationController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _imageAssetController;
//   late TextEditingController _ratingController;
//   late TextEditingController _emailController;
//   late List<String> _workingDays;
//   late TimeOfDay _startTime;
//   late TimeOfDay _endTime;
//   late TextEditingController _qualificationsController;
//   late TextEditingController _experienceYearsController;
//   late TextEditingController _consultationFeeController;
//   bool _isSaving = false;
//
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _initializeFormData();
//   }
//
//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );
//
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.elasticOut,
//     ));
//
//     _animationController.forward();
//   }
//
//   void _initializeFormData() {
//     final derm = widget.dermatologist;
//     _nameController = TextEditingController(text: derm?.name ?? '');
//     _specialtyController = TextEditingController(text: derm?.specialty ?? '');
//     _locationController = TextEditingController(text: derm?.location ?? '');
//     _descriptionController = TextEditingController(text: derm?.description ?? '');
//     _imageAssetController = TextEditingController(text: derm?.imageAsset ?? '');
//     _ratingController = TextEditingController(text: derm?.rating.toString() ?? '4.5');
//     _emailController = TextEditingController(text: derm?.email ?? '');
//     _workingDays = List.from(derm?.workingDays ?? ['Monday', 'Wednesday', 'Friday']);
//     _startTime = derm?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
//     _endTime = derm?.endTime ?? const TimeOfDay(hour: 17, minute: 0);
//     _qualificationsController = TextEditingController(text: derm?.qualifications?.join(", ") ?? '');
//     _experienceYearsController = TextEditingController(text: derm?.experienceYears?.toString() ?? '0');
//     _consultationFeeController = TextEditingController(text: derm?.consultationFee?.toString() ?? '0.0');
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _nameController.dispose();
//     _specialtyController.dispose();
//     _locationController.dispose();
//     _descriptionController.dispose();
//     _imageAssetController.dispose();
//     _ratingController.dispose();
//     _emailController.dispose();
//     _qualificationsController.dispose();
//     _experienceYearsController.dispose();
//     _consultationFeeController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _selectTime(BuildContext context, bool isStartTime) async {
//     final selectedTime = await showTimePicker(
//       context: context,
//       initialTime: isStartTime ? _startTime : _endTime,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(primary: Colors.blue.shade600),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (selectedTime != null) {
//       setState(() {
//         if (isStartTime) {
//           _startTime = selectedTime;
//         } else {
//           _endTime = selectedTime;
//         }
//       });
//     }
//   }
//
//   void _saveForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isSaving = true);
//
//       try {
//         final dermatologist = Dermatologist(
//           id: widget.dermatologist?.id ?? '',
//           name: _nameController.text.trim(),
//           specialty: _specialtyController.text.trim(),
//           location: _locationController.text.trim(),
//           description: _descriptionController.text.trim(),
//           imageAsset: _imageAssetController.text.trim(),
//           rating: double.parse(_ratingController.text),
//           email: _emailController.text.trim(),
//           workingDays: _workingDays,
//           startTime: _startTime,
//           endTime: _endTime,
//           qualifications: _qualificationsController.text.split(", "),
//           experienceYears: int.parse(_experienceYearsController.text),
//           consultationFee: double.parse(_consultationFeeController.text),
//         );
//
//         widget.onSave(dermatologist);
//         Navigator.pop(context);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } finally {
//         if (mounted) {
//           setState(() => _isSaving = false);
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: ScaleTransition(
//         scale: _scaleAnimation,
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.9,
//           height: MediaQuery.of(context).size.height * 0.85,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 20,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               // Header
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.blue.shade600, Colors.blue.shade400],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       widget.dermatologist == null ? Icons.person_add : Icons.edit,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         widget.dermatologist == null
//                             ? 'Add New Dermatologist'
//                             : 'Edit Dermatologist',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Form Content
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildTextField(
//                           controller: _nameController,
//                           label: 'Full Name',
//                           icon: Icons.person,
//                           validator: (value) => value?.isEmpty == true ? 'Please enter a name' : null,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _specialtyController,
//                           label: 'Specialty',
//                           icon: Icons.medical_services,
//                           validator: (value) => value?.isEmpty == true ? 'Please enter specialty' : null,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _locationController,
//                           label: 'Location',
//                           icon: Icons.location_on,
//                           validator: (value) => value?.isEmpty == true ? 'Please enter location' : null,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _descriptionController,
//                           label: 'Description',
//                           icon: Icons.description,
//                           maxLines: 3,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _imageAssetController,
//                           label: 'Image Asset Path',
//                           icon: Icons.image,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _ratingController,
//                           label: 'Rating',
//                           icon: Icons.star,
//                           keyboardType: TextInputType.number,
//                           validator: (value) {
//                             if (value?.isEmpty == true) return 'Please enter rating';
//                             final rating = double.tryParse(value!);
//                             if (rating == null || rating < 0 || rating > 5) {
//                               return 'Rating must be 0-5';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _emailController,
//                           label: 'Email',
//                           icon: Icons.email,
//                           keyboardType: TextInputType.emailAddress,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _qualificationsController,
//                           label: 'Qualifications',
//                           icon: Icons.school,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _experienceYearsController,
//                           label: 'Experience (Years)',
//                           icon: Icons.access_time,
//                           keyboardType: TextInputType.number,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _consultationFeeController,
//                           label: 'Consultation Fee',
//                           icon: Icons.money,
//                           keyboardType: TextInputType.number,
//                         ),
//                         const SizedBox(height: 16),
//
//                         // Working Days
//                         const Text(
//                           'Working Days',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: [
//                             'Monday', 'Tuesday', 'Wednesday',
//                             'Thursday', 'Friday', 'Saturday', 'Sunday'
//                           ].map((day) {
//                             final isSelected = _workingDays.contains(day);
//                             return FilterChip(
//                               label: Text(day),
//                               selected: isSelected,
//                               onSelected: (selected) {
//                                 setState(() {
//                                   if (selected) {
//                                     _workingDays.add(day);
//                                   } else {
//                                     _workingDays.remove(day);
//                                   }
//                                 });
//                               },
//                               selectedColor: Colors.blue.shade600,
//                               checkmarkColor: Colors.white,
//                               backgroundColor: Colors.grey.shade100,
//                               labelStyle: TextStyle(
//                                 color: isSelected ? Colors.white : Colors.grey.shade700,
//                                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Working Hours
//                         const Text(
//                           'Working Hours',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade50,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.grey.shade300),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Start Time',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     InkWell(
//                                       onTap: () => _selectTime(context, true),
//                                       child: Row(
//                                         children: [
//                                           Icon(Icons.access_time,
//                                               color: Colors.blue.shade600, size: 20),
//                                           const SizedBox(width: 8),
//                                           Text(
//                                             _startTime.format(context),
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade50,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.grey.shade300),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'End Time',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     InkWell(
//                                       onTap: () => _selectTime(context, false),
//                                       child: Row(
//                                         children: [
//                                           Icon(Icons.access_time,
//                                               color: Colors.blue.shade600, size: 20),
//                                           const SizedBox(width: 8),
//                                           Text(
//                                             _endTime.format(context),
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Action Buttons
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(20),
//                     bottomRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: _isSaving ? null : () => Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           side: BorderSide(color: Colors.grey.shade400),
//                         ),
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: _isSaving ? null : _saveForm,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue.shade600,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: _isSaving
//                             ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                             : Text(
//                           widget.dermatologist == null ? 'Add Doctor' : 'Update Doctor',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     String? Function(String?)? validator,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//   }) {
//     return TextFormField(
//       controller: controller,
//       validator: validator,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.blue.shade600),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//         filled: true,
//         fillColor: Colors.grey.shade50,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       ),
//     );
//   }
// }
//





// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:skincare_app/dermatologist_model.dart';
//
// class AdminDermatologistScreen extends StatefulWidget {
//   const AdminDermatologistScreen({super.key});
//
//   @override
//   State<AdminDermatologistScreen> createState() =>
//       _AdminDermatologistScreenState();
// }
//
// class _AdminDermatologistScreenState extends State<AdminDermatologistScreen>
//     with TickerProviderStateMixin {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<Dermatologist> _allDermatologists = [];
//   List<Dermatologist> _filteredDermatologists = [];
//   final TextEditingController _searchController = TextEditingController();
//   bool _isLoading = true;
//
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _fetchDermatologists();
//     _searchController.addListener(_filterDermatologists);
//   }
//
//   void _initializeAnimations() {
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );
//
//     _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));
//
//     _fadeController.forward();
//     _slideController.forward();
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.red.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
//
//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle_outline, color: Colors.white),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.green.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
//
//   Future<void> _fetchDermatologists() async {
//     try {
//       setState(() => _isLoading = true);
//
//       final snapshot = await _firestore
//           .collection('dermatologists')
//           .where('isActive', isEqualTo: true)
//           .get();
//
//       final docs = snapshot.docs.map((doc) {
//         return Dermatologist.fromMap(doc.id, doc.data());
//       }).toList();
//
//       setState(() {
//         _allDermatologists = docs;
//         _filteredDermatologists = docs;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showErrorSnackBar('Error fetching dermatologists: $e');
//     }
//   }
//
//   void _filterDermatologists() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       if (query.isEmpty) {
//         _filteredDermatologists = _allDermatologists;
//       } else {
//         _filteredDermatologists = _allDermatologists.where(
//               (derm) =>
//           derm.name.toLowerCase().contains(query) ||
//               derm.location.toLowerCase().contains(query) ||
//               derm.specialty.toLowerCase().contains(query),
//         ).toList();
//       }
//     });
//   }
//
//   void _addNewDermatologist() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => DermatologistForm(
//         onSave: (derm) => _saveDermatologist(derm),
//       ),
//     );
//   }
//
//   void _editDermatologist(Dermatologist dermatologist) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => DermatologistForm(
//         dermatologist: dermatologist,
//         onSave: (derm) => _updateDermatologist(derm),
//       ),
//     );
//   }
//
//   Future<void> _saveDermatologist(Dermatologist derm) async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _showErrorSnackBar('Admin not authenticated. Please log in again.');
//       return;
//     }
//
//     try {
//       await _firestore.collection('dermatologists').add({
//         ...derm.toMap(),
//         'isActive': true,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//
//       await _fetchDermatologists();
//       _showSuccessSnackBar('Dermatologist added successfully');
//     } catch (e) {
//       _showErrorSnackBar('Error adding dermatologist: $e');
//     }
//   }
//
//   Future<void> _updateDermatologist(Dermatologist derm) async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _showErrorSnackBar('Admin not authenticated. Please log in again.');
//       return;
//     }
//
//     try {
//       await _firestore.collection('dermatologists').doc(derm.id).update({
//         ...derm.toMap(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//
//       await _fetchDermatologists();
//       _showSuccessSnackBar('Dermatologist updated successfully');
//     } catch (e) {
//       _showErrorSnackBar('Error updating dermatologist: $e');
//     }
//   }
//
//   Future<void> _deleteDermatologist(String id, String name) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Confirm Deletion'),
//         content: Text('Are you sure you want to delete Dr. $name?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//
//     if (confirmed != true) return;
//
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _showErrorSnackBar('Admin not authenticated. Please log in again.');
//       return;
//     }
//
//     try {
//       await _firestore.collection('dermatologists').doc(id).update({
//         'isActive': false,
//         'deletedAt': FieldValue.serverTimestamp(),
//       });
//
//       await _fetchDermatologists();
//       _showSuccessSnackBar('Dermatologist deleted successfully');
//     } catch (e) {
//       _showErrorSnackBar('Error deleting dermatologist: $e');
//     }
//   }
//
//   void _signOut() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       if (mounted) {
//         Navigator.of(context).pushReplacementNamed('/login');
//       }
//     } catch (e) {
//       _showErrorSnackBar('Error signing out: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text(
//           'Manage Dermatologists',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: _signOut,
//           tooltip: 'Back to Login',
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 8),
//             child: IconButton(
//               icon: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade600,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(Icons.add, color: Colors.white),
//               ),
//               onPressed: _addNewDermatologist,
//               tooltip: 'Add Dermatologist',
//             ),
//           ),
//         ],
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: Column(
//             children: [
//               // Header Stats Card
//               Container(
//                 margin: const EdgeInsets.all(16),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.blue.shade600, Colors.blue.shade400],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.blue.shade200,
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.local_hospital, color: Colors.white, size: 32),
//                     const SizedBox(width: 16),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Total Dermatologists',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.9),
//                             fontSize: 14,
//                           ),
//                         ),
//                         Text(
//                           '${_allDermatologists.length}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Search Bar
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     labelText: 'Search dermatologists...',
//                     prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
//                     suffixIcon: _searchController.text.isNotEmpty
//                         ? IconButton(
//                       icon: const Icon(Icons.clear),
//                       onPressed: () {
//                         _searchController.clear();
//                         _filterDermatologists();
//                       },
//                     )
//                         : null,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Dermatologists List
//               Expanded(
//                 child: _isLoading
//                     ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                             Colors.blue.shade600),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Loading dermatologists...',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                     : _filteredDermatologists.isEmpty
//                     ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.search_off,
//                         size: 64,
//                         color: Colors.grey.shade400,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         _searchController.text.isEmpty
//                             ? 'No dermatologists found'
//                             : 'No results for "${_searchController.text}"',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                     : ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: _filteredDermatologists.length,
//                   itemBuilder: (context, index) {
//                     final derm = _filteredDermatologists[index];
//                     return TweenAnimationBuilder<double>(
//                       duration: Duration(
//                           milliseconds: 300 + (index * 100)),
//                       tween: Tween(begin: 0.0, end: 1.0),
//                       builder: (context, value, child) {
//                         return Transform.translate(
//                           offset: Offset(0, 50 * (1 - value)),
//                           child: Opacity(
//                             opacity: value,
//                             child: Container(
//                               margin: const EdgeInsets.only(bottom: 12),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius:
//                                 BorderRadius.circular(16),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.shade200,
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: ListTile(
//                                 contentPadding: const EdgeInsets.all(16),
//                                 leading: Hero(
//                                   tag: 'doctor_${derm.id}',
//                                   child: Container(
//                                     width: 60,
//                                     height: 60,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.grey.shade300,
//                                           blurRadius: 8,
//                                           offset:
//                                           const Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: CircleAvatar(
//                                       radius: 30,
//                                       backgroundColor:
//                                       Colors.grey.shade200,
//                                       backgroundImage: derm.imageAsset
//                                           .isNotEmpty
//                                           ? NetworkImage(
//                                           derm.imageAsset)
//                                           : null,
//                                       child: derm.imageAsset.isEmpty
//                                           ? Icon(
//                                         Icons.person,
//                                         size: 30,
//                                         color: Colors
//                                             .grey.shade600,
//                                       )
//                                           : null,
//                                     ),
//                                   ),
//                                 ),
//                                 title: Text(
//                                   derm.name,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                                   children: [
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       derm.specialty,
//                                       style: TextStyle(
//                                         color: Colors.blue.shade600,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 2),
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.location_on,
//                                           size: 14,
//                                           color: Colors.grey.shade600,
//                                         ),
//                                         const SizedBox(width: 2),
//                                         Expanded(
//                                           child: Text(
//                                             derm.location,
//                                             style: TextStyle(
//                                               color: Colors
//                                                   .grey.shade600,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.blue.shade50,
//                                         borderRadius:
//                                         BorderRadius.circular(8),
//                                       ),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.edit,
//                                           color: Colors.blue.shade600,
//                                           size: 20,
//                                         ),
//                                         onPressed: () =>
//                                             _editDermatologist(derm),
//                                         tooltip: 'Edit',
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.red.shade50,
//                                         borderRadius:
//                                         BorderRadius.circular(8),
//                                       ),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.delete,
//                                           color: Colors.red.shade600,
//                                           size: 20,
//                                         ),
//                                         onPressed: () =>
//                                             _deleteDermatologist(
//                                                 derm.id, derm.name),
//                                         tooltip: 'Delete',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 onTap: () => _editDermatologist(derm),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class DermatologistForm extends StatefulWidget {
//   final Dermatologist? dermatologist;
//   final Function(Dermatologist) onSave;
//
//   const DermatologistForm({
//     super.key,
//     this.dermatologist,
//     required this.onSave,
//   });
//
//   @override
//   State<DermatologistForm> createState() => _DermatologistFormState();
// }
//
// class _DermatologistFormState extends State<DermatologistForm>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _specialtyController;
//   late TextEditingController _locationController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _imageAssetController;
//   late TextEditingController _ratingController;
//   late TextEditingController _emailController;
//   late List<String> _workingDays;
//   late TimeOfDay _startTime;
//   late TimeOfDay _endTime;
//   late TextEditingController _qualificationsController;
//   late TextEditingController _experienceYearsController;
//   late TextEditingController _consultationFeeController;
//   bool _isSaving = false;
//
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _initializeFormData();
//   }
//
//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );
//
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.elasticOut,
//     ));
//
//     _animationController.forward();
//   }
//
//   void _initializeFormData() {
//     final derm = widget.dermatologist;
//     _nameController = TextEditingController(text: derm?.name ?? '');
//     _specialtyController = TextEditingController(text: derm?.specialty ?? '');
//     _locationController = TextEditingController(text: derm?.location ?? '');
//     _descriptionController = TextEditingController(text: derm?.description ?? '');
//     _imageAssetController = TextEditingController(text: derm?.imageAsset ?? '');
//     _ratingController = TextEditingController(text: derm?.rating.toString() ?? '4.5');
//     _emailController = TextEditingController(text: derm?.email ?? '');
//     _workingDays = List.from(derm?.workingDays ?? ['Monday', 'Wednesday', 'Friday']);
//     _startTime = derm?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
//     _endTime = derm?.endTime ?? const TimeOfDay(hour: 17, minute: 0);
//     _qualificationsController = TextEditingController(text: derm?.qualifications?.join(", ") ?? '');
//     _experienceYearsController = TextEditingController(text: derm?.experienceYears?.toString() ?? '0');
//     _consultationFeeController = TextEditingController(text: derm?.consultationFee?.toString() ?? '0.0');
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _nameController.dispose();
//     _specialtyController.dispose();
//     _locationController.dispose();
//     _descriptionController.dispose();
//     _imageAssetController.dispose();
//     _ratingController.dispose();
//     _emailController.dispose();
//     _qualificationsController.dispose();
//     _experienceYearsController.dispose();
//     _consultationFeeController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _selectTime(BuildContext context, bool isStartTime) async {
//     final selectedTime = await showTimePicker(
//       context: context,
//       initialTime: isStartTime ? _startTime : _endTime,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(primary: Colors.blue.shade600),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (selectedTime != null) {
//       setState(() {
//         if (isStartTime) {
//           _startTime = selectedTime;
//         } else {
//           _endTime = selectedTime;
//         }
//       });
//     }
//   }
//
//   void _saveForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isSaving = true);
//
//       try {
//         final dermatologist = Dermatologist(
//           id: widget.dermatologist?.id ?? '',
//           name: _nameController.text.trim(),
//           specialty: _specialtyController.text.trim(),
//           location: _locationController.text.trim(),
//           description: _descriptionController.text.trim(),
//           imageAsset: _imageAssetController.text.trim(),
//           rating: double.parse(_ratingController.text),
//           email: _emailController.text.trim(),
//           workingDays: _workingDays,
//           startTime: _startTime,
//           endTime: _endTime,
//           qualifications: _qualificationsController.text.split(", "),
//           experienceYears: int.parse(_experienceYearsController.text),
//           consultationFee: double.parse(_consultationFeeController.text),
//         );
//
//         widget.onSave(dermatologist);
//         Navigator.pop(context);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } finally {
//         if (mounted) {
//           setState(() => _isSaving = false);
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: ScaleTransition(
//         scale: _scaleAnimation,
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.9,
//           height: MediaQuery.of(context).size.height * 0.85,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 20,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               // Header
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.blue.shade600, Colors.blue.shade400],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       widget.dermatologist == null
//                           ? Icons.person_add
//                           : Icons.edit,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         widget.dermatologist == null
//                             ? 'Add New Dermatologist'
//                             : 'Edit Dermatologist',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//               ),
//               // Form Content
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildTextField(
//                           controller: _nameController,
//                           label: 'Full Name',
//                           icon: Icons.person,
//                           validator: (value) => value?.isEmpty == true
//                               ? 'Please enter a name'
//                               : null,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _specialtyController,
//                           label: 'Specialty',
//                           icon: Icons.medical_services,
//                           validator: (value) => value?.isEmpty == true
//                               ? 'Please enter specialty'
//                               : null,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _locationController,
//                           label: 'Location',
//                           icon: Icons.location_on,
//                           validator: (value) => value?.isEmpty == true
//                               ? 'Please enter location'
//                               : null,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _descriptionController,
//                           label: 'Description',
//                           icon: Icons.description,
//                           maxLines: 3,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _imageAssetController,
//                           label: 'Image Asset Path',
//                           icon: Icons.image,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _ratingController,
//                           label: 'Rating',
//                           icon: Icons.star,
//                           keyboardType: TextInputType.number,
//                           validator: (value) {
//                             if (value?.isEmpty == true) return 'Please enter rating';
//                             final rating = double.tryParse(value!);
//                             if (rating == null || rating < 0 || rating > 5) {
//                               return 'Rating must be 0-5';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _emailController,
//                           label: 'Email',
//                           icon: Icons.email,
//                           keyboardType: TextInputType.emailAddress,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _qualificationsController,
//                           label: 'Qualifications',
//                           icon: Icons.school,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _experienceYearsController,
//                           label: 'Experience (Years)',
//                           icon: Icons.access_time,
//                           keyboardType: TextInputType.number,
//                         ),
//                         const SizedBox(height: 16),
//
//                         _buildTextField(
//                           controller: _consultationFeeController,
//                           label: 'Consultation Fee',
//                           icon: Icons.money,
//                           keyboardType: TextInputType.number,
//                         ),
//                         const SizedBox(height: 16),
//
//                         // Working Days
//                         const Text(
//                           'Working Days',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: [
//                             'Monday', 'Tuesday', 'Wednesday',
//                             'Thursday', 'Friday', 'Saturday', 'Sunday'
//                           ].map((day) {
//                             final isSelected = _workingDays.contains(day);
//                             return FilterChip(
//                               label: Text(day),
//                               selected: isSelected,
//                               onSelected: (selected) {
//                                 setState(() {
//                                   if (selected) {
//                                     _workingDays.add(day);
//                                   } else {
//                                     _workingDays.remove(day);
//                                   }
//                                 });
//                               },
//                               selectedColor: Colors.blue.shade600,
//                               checkmarkColor: Colors.white,
//                               backgroundColor: Colors.grey.shade100,
//                               labelStyle: TextStyle(
//                                 color: isSelected ? Colors.white : Colors.grey.shade700,
//                                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Working Hours
//                         const Text(
//                           'Working Hours',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade50,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.grey.shade300),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Start Time',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     InkWell(
//                                       onTap: () => _selectTime(context, true),
//                                       child: Row(
//                                         children: [
//                                           Icon(Icons.access_time,
//                                               color: Colors.blue.shade600, size: 20),
//                                           const SizedBox(width: 8),
//                                           Text(
//                                             _startTime.format(context),
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade50,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.grey.shade300),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'End Time',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     InkWell(
//                                       onTap: () => _selectTime(context, false),
//                                       child: Row(
//                                         children: [
//                                           Icon(Icons.access_time,
//                                               color: Colors.blue.shade600, size: 20),
//                                           const SizedBox(width: 8),
//                                           Text(
//                                             _endTime.format(context),
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Action Buttons
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(20),
//                     bottomRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: _isSaving ? null : () => Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           side: BorderSide(color: Colors.grey.shade400),
//                         ),
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: _isSaving ? null : _saveForm,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue.shade600,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: _isSaving
//                             ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                             : Text(
//                           widget.dermatologist == null ? 'Add Doctor' : 'Update Doctor',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     String? Function(String?)? validator,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//   }) {
//     return TextFormField(
//       controller: controller,
//       validator: validator,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.blue.shade600),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//         filled: true,
//         fillColor: Colors.grey.shade50,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       ),
//     );
//   }
// }
//
//
//



import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:skincare_app/dermatologist_model.dart';

class AdminDermatologistScreen extends StatefulWidget {
  const AdminDermatologistScreen({super.key});

  @override
  State<AdminDermatologistScreen> createState() =>
      _AdminDermatologistScreenState();
}

class _AdminDermatologistScreenState extends State<AdminDermatologistScreen>
    with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Dermatologist> _allDermatologists = [];
  List<Dermatologist> _filteredDermatologists = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _fetchDermatologists();
    _searchController.addListener(_filterDermatologists);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _fetchDermatologists() async {
    try {
      setState(() => _isLoading = true);

      final snapshot = await _firestore
          .collection('dermatologists')
          .where('isActive', isEqualTo: true)
          .get();

      final docs = snapshot.docs.map((doc) {
        return Dermatologist.fromMap(doc.id, doc.data());
      }).toList();

      setState(() {
        _allDermatologists = docs;
        _filteredDermatologists = docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error fetching dermatologists: $e');
    }
  }

  void _filterDermatologists() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredDermatologists = _allDermatologists;
      } else {
        _filteredDermatologists = _allDermatologists.where(
              (derm) =>
          derm.name.toLowerCase().contains(query) ||
              derm.location.toLowerCase().contains(query) ||
              derm.specialty.toLowerCase().contains(query),
        ).toList();
      }
    });
  }

  void _addNewDermatologist() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DermatologistForm(
        onSave: (derm) => _saveDermatologist(derm),
      ),
    );
  }

  void _editDermatologist(Dermatologist dermatologist) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DermatologistForm(
        dermatologist: dermatologist,
        onSave: (derm) => _updateDermatologist(derm),
      ),
    );
  }

  Future<void> _saveDermatologist(Dermatologist derm) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showErrorSnackBar('Admin not authenticated. Please log in again.');
      return;
    }

    try {
      await _firestore.collection('dermatologists').add({
        ...derm.toMap(),
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _fetchDermatologists();
      _showSuccessSnackBar('Dermatologist added successfully');
    } catch (e) {
      _showErrorSnackBar('Error adding dermatologist: $e');
    }
  }

  Future<void> _updateDermatologist(Dermatologist derm) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showErrorSnackBar('Admin not authenticated. Please log in again.');
      return;
    }

    try {
      await _firestore.collection('dermatologists').doc(derm.id).update({
        ...derm.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _fetchDermatologists();
      _showSuccessSnackBar('Dermatologist updated successfully');
    } catch (e) {
      _showErrorSnackBar('Error updating dermatologist: $e');
    }
  }

  Future<void> _deleteDermatologist(String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete Dr. $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showErrorSnackBar('Admin not authenticated. Please log in again.');
      return;
    }

    try {
      await _firestore.collection('dermatologists').doc(id).update({
        'isActive': false,
        'deletedAt': FieldValue.serverTimestamp(),
      });

      await _fetchDermatologists();
      _showSuccessSnackBar('Dermatologist deleted successfully');
    } catch (e) {
      _showErrorSnackBar('Error deleting dermatologist: $e');
    }
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      _showErrorSnackBar('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Manage Dermatologists',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _signOut,
          tooltip: 'Back to Login',
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              onPressed: _addNewDermatologist,
              tooltip: 'Add Dermatologist',
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Header Stats Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_hospital, color: Colors.white, size: 32),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Dermatologists',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${_allDermatologists.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search dermatologists...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterDermatologists();
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Dermatologists List
              Expanded(
                child: _isLoading
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue.shade600),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading dermatologists...',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
                    : _filteredDermatologists.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchController.text.isEmpty
                            ? 'No dermatologists found'
                            : 'No results for "${_searchController.text}"',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredDermatologists.length,
                  itemBuilder: (context, index) {
                    final derm = _filteredDermatologists[index];
                    return TweenAnimationBuilder<double>(
                      duration: Duration(
                          milliseconds: 300 + (index * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: Hero(
                                  tag: 'doctor_${derm.id}',
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 8,
                                          offset:
                                          const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor:
                                      Colors.grey.shade200,
                                      backgroundImage: derm.imageAsset
                                          .isNotEmpty
                                          ? NetworkImage(
                                          derm.imageAsset)
                                          : null,
                                      child: derm.imageAsset.isEmpty
                                          ? Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors
                                            .grey.shade600,
                                      )
                                          : null,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  derm.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      derm.specialty,
                                      style: TextStyle(
                                        color: Colors.blue.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          child: Text(
                                            derm.location,
                                            style: TextStyle(
                                              color: Colors
                                                  .grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.blue.shade600,
                                          size: 20,
                                        ),
                                        onPressed: () =>
                                            _editDermatologist(derm),
                                        tooltip: 'Edit',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red.shade600,
                                          size: 20,
                                        ),
                                        onPressed: () =>
                                            _deleteDermatologist(
                                                derm.id, derm.name),
                                        tooltip: 'Delete',
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () => _editDermatologist(derm),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DermatologistForm extends StatefulWidget {
  final Dermatologist? dermatologist;
  final Function(Dermatologist) onSave;

  const DermatologistForm({
    super.key,
    this.dermatologist,
    required this.onSave,
  });

  @override
  State<DermatologistForm> createState() => _DermatologistFormState();
}

class _DermatologistFormState extends State<DermatologistForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _ratingController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _qualificationsController;
  late TextEditingController _experienceYearsController;
  late TextEditingController _consultationFeeController;

  late List<String> _workingDays;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  bool _isSaving = false;
  File? _imageFile;
  String? _imageUrl;
  bool _imageChanged = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeFormData();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  void _initializeFormData() {
    final derm = widget.dermatologist;
    _nameController = TextEditingController(text: derm?.name ?? '');
    _specialtyController = TextEditingController(text: derm?.specialty ?? '');
    _locationController = TextEditingController(text: derm?.location ?? '');
    _descriptionController = TextEditingController(text: derm?.description ?? '');
    _ratingController = TextEditingController(text: derm?.rating.toString() ?? '4.5');
    _emailController = TextEditingController(text: derm?.email ?? '');
    _phoneNumberController = TextEditingController(text: derm?.phoneNumber ?? '');
    _qualificationsController = TextEditingController(text: derm?.qualifications?.join(", ") ?? '');
    _experienceYearsController = TextEditingController(text: derm?.experienceYears?.toString() ?? '0');
    _consultationFeeController = TextEditingController(text: derm?.consultationFee?.toString() ?? '0.0');

    _workingDays = List.from(derm?.workingDays ?? ['Monday', 'Wednesday', 'Friday']);
    _startTime = derm?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
    _endTime = derm?.endTime ?? const TimeOfDay(hour: 17, minute: 0);
    _imageUrl = derm?.imageAsset;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _specialtyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _qualificationsController.dispose();
    _experienceYearsController.dispose();
    _consultationFeeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageChanged = true;
      });
    }
  }

  // Future<String?> _uploadImage() async {
  //   if (_imageFile == null) return null;
  //
  //   try {
  //     final storageRef = FirebaseStorage.instance.ref();
  //     final imageRef = storageRef.child(
  //         'dermatologist_images/${DateTime.now().millisecondsSinceEpoch}.jpg'); // You may want to use a unique ID or name to prevent overwriting
  //
  //     await imageRef.putFile(_imageFile!); // Upload the file to Firebase Storage
  //     return await imageRef.getDownloadURL(); // Get the URL of the uploaded file
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Image upload failed: $e')),
  //     );
  //     return null;
  //   }
  // }




  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;
    // Add before upload
    if (await _imageFile!.length() == 0) {
      throw Exception('Selected image file is empty');
    }
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child(
          'dermatologist_images/${DateTime.now().millisecondsSinceEpoch}.jpg'
      );

      // Upload the file and wait for completion
      final uploadTask = imageRef.putFile(_imageFile!);
      final taskSnapshot = await uploadTask;

      // Verify successful upload
      if (taskSnapshot.state == TaskState.success) {
        return await imageRef.getDownloadURL();
      } else {
        throw Exception('Upload task failed: ${taskSnapshot.state}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload failed: ${e.toString()}')),
      );
      return null;
    }
  }


  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.blue.shade600),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = selectedTime;
        } else {
          _endTime = selectedTime;
        }
      });
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      // Add this in _saveForm() before upload
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Uploading image...'),
            ],
          ),
        ),
      );

      try {
        String? imageUrl = _imageUrl;

        // Upload new image if selected
        if (_imageChanged) {
          imageUrl = await _uploadImage() ?? _imageUrl;
          Navigator.of(context, rootNavigator: true).pop();
        }

        final dermatologist = Dermatologist(
          id: widget.dermatologist?.id ?? '',
          name: _nameController.text.trim(),
          specialty: _specialtyController.text.trim(),
          location: _locationController.text.trim(),
          description: _descriptionController.text.trim(),
          imageAsset: imageUrl ?? '',
          rating: double.parse(_ratingController.text),
          email: _emailController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          workingDays: _workingDays,
          startTime: _startTime,
          endTime: _endTime,
          qualifications: _qualificationsController.text.split(", "),
          experienceYears: int.parse(_experienceYearsController.text),
          consultationFee: double.parse(_consultationFeeController.text),
        );

        widget.onSave(dermatologist);
        Navigator.pop(context);
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.dermatologist == null
                          ? Icons.person_add
                          : Icons.edit,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.dermatologist == null
                            ? 'Add New Dermatologist'
                            : 'Edit Dermatologist',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Image Picker
                        Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage: _imageFile != null
                                      ? FileImage(_imageFile!)
                                      : (_imageUrl != null && _imageUrl!.isNotEmpty)
                                      ? NetworkImage(_imageUrl!)
                                      : null,
                                  child: _imageFile == null &&
                                      (_imageUrl == null || _imageUrl!.isEmpty)
                                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: _pickImage,
                                child: const Text(
                                  'Change Photo',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: Icons.person,
                          validator: (value) => value?.isEmpty == true
                              ? 'Please enter a name'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _phoneNumberController,
                          label: 'Phone Number',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (value) => value?.isEmpty == true
                              ? 'Please enter phone number'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _specialtyController,
                          label: 'Specialty',
                          icon: Icons.medical_services,
                          validator: (value) => value?.isEmpty == true
                              ? 'Please enter specialty'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _locationController,
                          label: 'Location',
                          icon: Icons.location_on,
                          validator: (value) => value?.isEmpty == true
                              ? 'Please enter location'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          icon: Icons.description,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _ratingController,
                          label: 'Rating',
                          icon: Icons.star,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty == true) return 'Please enter rating';
                            final rating = double.tryParse(value!);
                            if (rating == null || rating < 0 || rating > 5) {
                              return 'Rating must be 0-5';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _qualificationsController,
                          label: 'Qualifications',
                          icon: Icons.school,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _experienceYearsController,
                          label: 'Experience (Years)',
                          icon: Icons.work_history,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty == true) return 'Please enter experience';
                            final years = int.tryParse(value!);
                            if (years == null || years < 0) {
                              return 'Enter valid experience';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _consultationFeeController,
                          label: 'Consultation Fee',
                          icon: Icons.money,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty == true) return 'Please enter fee';
                            final fee = double.tryParse(value!);
                            if (fee == null || fee < 0) {
                              return 'Enter valid fee';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Working Days
                        const Text(
                          'Working Days',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            'Monday', 'Tuesday', 'Wednesday',
                            'Thursday', 'Friday', 'Saturday', 'Sunday'
                          ].map((day) {
                            final isSelected = _workingDays.contains(day);
                            return FilterChip(
                              label: Text(day),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _workingDays.add(day);
                                  } else {
                                    _workingDays.remove(day);
                                  }
                                });
                              },
                              selectedColor: Colors.blue.shade600,
                              checkmarkColor: Colors.white,
                              backgroundColor: Colors.grey.shade100,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey.shade700,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        // Working Hours
                        const Text(
                          'Working Hours',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Start Time',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    InkWell(
                                      onTap: () => _selectTime(context, true),
                                      child: Row(
                                        children: [
                                          Icon(Icons.access_time,
                                              color: Colors.blue.shade600, size: 20),
                                          const SizedBox(width: 8),
                                          Text(
                                            _startTime.format(context),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'End Time',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    InkWell(
                                      onTap: () => _selectTime(context, false),
                                      child: Row(
                                        children: [
                                          Icon(Icons.access_time,
                                              color: Colors.blue.shade600, size: 20),
                                          const SizedBox(width: 8),
                                          Text(
                                            _endTime.format(context),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Action Buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSaving ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          widget.dermatologist == null ? 'Add Doctor' : 'Update Doctor',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}








