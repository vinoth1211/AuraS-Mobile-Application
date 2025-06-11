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
// class _AdminDermatologistScreenState extends State<AdminDermatologistScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final List<Dermatologist> _dermatologists = [];
//   final TextEditingController _searchController = TextEditingController();
//   bool _isLoading = true;
//   // String? getAdminUid() {
//   //   return FirebaseAuth.instance.currentUser?.uid;
//   // }
//
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchDermatologists();
//     _searchController.addListener(_filterDermatologists);
//   }
//
//   // Add snackbar helper methods
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
//
//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
//
//
//   Future<void> _fetchDermatologists() async {
//     try {
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
//         _dermatologists.addAll(docs);
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching dermatologists: $e')),
//       );
//     }
//   }
//
//   void _filterDermatologists() {
//     final query = _searchController.text.toLowerCase();
//     if (query.isEmpty) {
//       setState(() {});
//       return;
//     }
//
//     setState(() {
//       _dermatologists.retainWhere(
//               (derm) => derm.name.toLowerCase().contains(query)
//       );
//     });
//   }
//
//   void _addNewDermatologist() {
//     showDialog(
//       context: context,
//       builder: (context) => DermatologistForm(
//         onSave: (derm) => _saveDermatologist(derm),
//       ),
//     );
//   }
//
//   void _editDermatologist(Dermatologist dermatologist) {
//     showDialog(
//       context: context,
//       builder: (context) => DermatologistForm(
//         dermatologist: dermatologist,
//         onSave: (derm) => _updateDermatologist(derm),
//       ),
//     );
//   }
//
//   // Future<void> _saveDermatologist(Dermatologist derm) async {
//   //   if (getAdminUid() == null) {
//   //     _showErrorSnackBar('Admin not authenticated');
//   //     return;
//   //   }
//   //   try {
//   //     await _firestore.collection('dermatologists').add({
//   //       'name': derm.name,
//   //       'location': derm.location,
//   //       'description': derm.description,
//   //       'imageAsset': derm.imageAsset,
//   //       'rating': derm.rating,
//   //       'email': derm.email,
//   //       'workingDays': derm.workingDays,
//   //       'startTime': '${derm.startTime.hour}:${derm.startTime.minute}',
//   //       'endTime': '${derm.endTime.hour}:${derm.endTime.minute}',
//   //       'isActive': true,
//   //     });
//   //     _fetchDermatologists(); // Refresh list
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('Dermatologist added successfully')),
//   //     );
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Error adding dermatologist: $e')),
//   //     );
//   //   }
//   // }
//   //
//   // Future<void> _updateDermatologist(Dermatologist derm) async {
//   //   try {
//   //     await _firestore.collection('dermatologists').doc(derm.id).update({
//   //       'name': derm.name,
//   //       'location': derm.location,
//   //       'description': derm.description,
//   //       'imageAsset': derm.imageAsset,
//   //       'rating': derm.rating,
//   //       'email': derm.email,
//   //       'workingDays': derm.workingDays,
//   //       'startTime': '${derm.startTime.hour}:${derm.startTime.minute}',
//   //       'endTime': '${derm.endTime.hour}:${derm.endTime.minute}',
//   //     });
//   //     _fetchDermatologists(); // Refresh list
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('Dermatologist updated successfully')),
//   //     );
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Error updating dermatologist: $e')),
//   //     );
//   //   }
//   // }
//   //
//   // Future<void> _deleteDermatologist(String id) async {
//   //   try {
//   //     await _firestore.collection('dermatologists').doc(id).update({
//   //       'isActive': false,
//   //     });
//   //     _fetchDermatologists(); // Refresh list
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('Dermatologist deleted successfully')),
//   //     );
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Error deleting dermatologist: $e')),
//   //     );
//   //   }
//   // }
//
//   Future<void> _saveDermatologist(Dermatologist derm) async {
//     // Check if admin is authenticated
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _showErrorSnackBar('Admin not authenticated. Please log in again.');
//       return;
//     }
//
//     try {
//       await _firestore.collection('dermatologists').add(derm.toMap());
//       _fetchDermatologists(); // Refresh list
//       _showSuccessSnackBar('Dermatologist added successfully');
//     } catch (e) {
//       _showErrorSnackBar('Error adding dermatologist: $e');
//     }
//   }
//
//   Future<void> _updateDermatologist(Dermatologist derm) async {
//     // Check if admin is authenticated
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _showErrorSnackBar('Admin not authenticated. Please log in again.');
//       return;
//     }
//
//     try {
//       await _firestore.collection('dermatologists').doc(derm.id).update(derm.toMap());
//       _fetchDermatologists(); // Refresh list
//       _showSuccessSnackBar('Dermatologist updated successfully');
//     } catch (e) {
//       _showErrorSnackBar('Error updating dermatologist: $e');
//     }
//   }
//
//   Future<void> _deleteDermatologist(String id) async {
//     // Check if admin is authenticated
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _showErrorSnackBar('Admin not authenticated. Please log in again.');
//       return;
//     }
//
//     try {
//       await _firestore.collection('dermatologists').doc(id).update({
//         'isActive': false,
//       });
//       _fetchDermatologists(); // Refresh list
//       _showSuccessSnackBar('Dermatologist deleted successfully');
//     } catch (e) {
//       _showErrorSnackBar('Error deleting dermatologist: $e');
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Manage Dermatologists'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: _addNewDermatologist,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(
//                 labelText: 'Search Dermatologists',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _dermatologists.isEmpty
//                 ? const Center(child: Text('No dermatologists found'))
//                 : ListView.builder(
//               itemCount: _dermatologists.length,
//               itemBuilder: (context, index) {
//                 final derm = _dermatologists[index];
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundImage: AssetImage(derm.imageAsset),
//                   ),
//                   title: Text(derm.name),
//                   subtitle: Text(derm.specialty),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.edit),
//                         onPressed: () => _editDermatologist(derm),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () => _deleteDermatologist(derm.id),
//                       ),
//                     ],
//                   ),
//                   onTap: () => _editDermatologist(derm),
//                 );
//               },
//             ),
//           ),
//         ],
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
// class _DermatologistFormState extends State<DermatologistForm> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _locationController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _imageAssetController;
//   late TextEditingController _ratingController;
//   late TextEditingController _emailController;
//   late List<String> _workingDays;
//   late TimeOfDay _startTime;
//   late TimeOfDay _endTime;
//
//   @override
//   void initState() {
//     super.initState();
//     final derm = widget.dermatologist;
//     _nameController = TextEditingController(text: derm?.name ?? '');
//     _locationController = TextEditingController(text: derm?.location ?? '');
//     _descriptionController = TextEditingController(text: derm?.description ?? '');
//     _imageAssetController = TextEditingController(text: derm?.imageAsset ?? '');
//     _ratingController = TextEditingController(text: derm?.rating.toString() ?? '4.5');
//     _emailController = TextEditingController(text: derm?.email ?? '');
//     _workingDays = derm?.workingDays ?? ['Monday', 'Wednesday', 'Friday'];
//     _startTime = derm?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
//     _endTime = derm?.endTime ?? const TimeOfDay(hour: 17, minute: 0);
//   }
//
//   Future<void> _selectTime(BuildContext context, bool isStartTime) async {
//     final selectedTime = await showTimePicker(
//       context: context,
//       initialTime: isStartTime ? _startTime : _endTime,
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
//   void _saveForm() {
//     if (_formKey.currentState!.validate()) {
//       final dermatologist = Dermatologist(
//         id: widget.dermatologist?.id ?? '',
//         name: _nameController.text,
//         location: _locationController.text,
//         description: _descriptionController.text,
//         imageAsset: _imageAssetController.text,
//         rating: double.parse(_ratingController.text),
//         email: _emailController.text,
//         workingDays: _workingDays,
//         startTime: _startTime,
//         endTime: _endTime,
//       );
//       widget.onSave(dermatologist);
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(widget.dermatologist == null
//           ? 'Add Dermatologist'
//           : 'Edit Dermatologist'),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _locationController,
//                 decoration: const InputDecoration(labelText: 'Location'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a location';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//               ),
//               TextFormField(
//                 controller: _imageAssetController,
//                 decoration: const InputDecoration(labelText: 'Image Asset Path'),
//               ),
//               TextFormField(
//                 controller: _ratingController,
//                 decoration: const InputDecoration(labelText: 'Rating'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a rating';
//                   }
//                   if (double.tryParse(value) == null) {
//                     return 'Please enter a valid number';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               const SizedBox(height: 16),
//               const Text('Working Days:'),
//               Wrap(
//                 children: [
//                   'Monday', 'Tuesday', 'Wednesday',
//                   'Thursday', 'Friday', 'Saturday', 'Sunday'
//                 ].map((day) {
//                   return FilterChip(
//                     label: Text(day),
//                     selected: _workingDays.contains(day),
//                     onSelected: (selected) {
//                       setState(() {
//                         if (selected) {
//                           _workingDays.add(day);
//                         } else {
//                           _workingDays.remove(day);
//                         }
//                       });
//                     },
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   const Text('Start Time:'),
//                   const SizedBox(width: 10),
//                   TextButton(
//                     onPressed: () => _selectTime(context, true),
//                     child: Text(_startTime.format(context)),
//                   ),
//                   const Spacer(),
//                   const Text('End Time:'),
//                   const SizedBox(width: 10),
//                   TextButton(
//                     onPressed: () => _selectTime(context, false),
//                     child: Text(_endTime.format(context)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _saveForm,
//           child: const Text('Save'),
//         ),
//       ],
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDermatologistScreen extends StatefulWidget {
  const AddDermatologistScreen({Key? key}) : super(key: key);

  @override
  State<AddDermatologistScreen> createState() => _AddDermatologistScreenState();
}

class _AddDermatologistScreenState extends State<AddDermatologistScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Controllers for text fields
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _experienceController = TextEditingController();
  final _consultationFeeController = TextEditingController();
  final _qualificationController = TextEditingController();

  // Form state variables
  double _rating = 4.0;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  List<String> _selectedWorkingDays = [];
  List<String> _qualifications = [];
  bool _isActive = true;
  bool _isLoading = false;

  // Available working days
  final List<String> _availableDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    _consultationFeeController.dispose();
    _qualificationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _addQualification() {
    if (_qualificationController.text.trim().isNotEmpty) {
      setState(() {
        _qualifications.add(_qualificationController.text.trim());
        _qualificationController.clear();
      });
    }
  }

  void _removeQualification(int index) {
    setState(() {
      _qualifications.removeAt(index);
    });
  }

  Future<void> _saveDermatologist() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedWorkingDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one working day'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dermatologistData = {
        'name': _nameController.text.trim(),
        'location': _locationController.text.trim(),
        'description': _descriptionController.text.trim(),
        'imageAsset': 'assets/images/default_doctor.png', // Default image
        'rating': _rating,
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        'workingDays': _selectedWorkingDays,
        'startTime': '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
        'endTime': '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
        'specialty': 'Dermatologist',
        'isActive': _isActive,
        'qualifications': _qualifications,
        'experienceYears': int.tryParse(_experienceController.text) ?? 0,
        'consultationFee': double.tryParse(_consultationFeeController.text) ?? 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('dermatologists')
          .add(dermatologistData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dermatologist added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding dermatologist: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Dermatologist'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Information Section
                _buildSectionHeader('Basic Information'),
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the doctor\'s name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter email address';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number (Optional)',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _locationController,
                  label: 'Location/Clinic',
                  icon: Icons.location_on,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  icon: Icons.description,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Professional Information Section
                _buildSectionHeader('Professional Information'),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _experienceController,
                        label: 'Experience (Years)',
                        icon: Icons.work,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final exp = int.tryParse(value);
                            if (exp == null || exp < 0 || exp > 50) {
                              return 'Enter valid experience (0-50)';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _consultationFeeController,
                        label: 'Consultation Fee',
                        icon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final fee = double.tryParse(value);
                            if (fee == null || fee < 0) {
                              return 'Enter valid fee';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Rating Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rating: ${_rating.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Slider(
                          value: _rating,
                          min: 1.0,
                          max: 5.0,
                          divisions: 40,
                          activeColor: Colors.teal,
                          onChanged: (value) {
                            setState(() {
                              _rating = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Qualifications Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Qualifications',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _qualificationController,
                                decoration: const InputDecoration(
                                  hintText: 'Add qualification',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                onFieldSubmitted: (value) => _addQualification(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _addQualification,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                        if (_qualifications.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _qualifications.asMap().entries.map((entry) {
                              return Chip(
                                label: Text(entry.value),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () => _removeQualification(entry.key),
                                backgroundColor: Colors.teal.shade50,
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Schedule Section
                _buildSectionHeader('Schedule Information'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Working Days',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableDays.map((day) {
                            final isSelected = _selectedWorkingDays.contains(day);
                            return FilterChip(
                              label: Text(day),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedWorkingDays.add(day);
                                  } else {
                                    _selectedWorkingDays.remove(day);
                                  }
                                });
                              },
                              selectedColor: Colors.teal.shade100,
                              checkmarkColor: Colors.teal,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Working Hours
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Working Hours',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTimeSelector(
                                'Start Time',
                                _startTime,
                                    () => _selectTime(context, true),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTimeSelector(
                                'End Time',
                                _endTime,
                                    () => _selectTime(context, false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Status Toggle
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Active Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Switch(
                          value: _isActive,
                          onChanged: (value) {
                            setState(() {
                              _isActive = value;
                            });
                          },
                          activeColor: Colors.teal,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveDermatologist,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Add Dermatologist',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildTimeSelector(String label, TimeOfDay time, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time.format(context),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}