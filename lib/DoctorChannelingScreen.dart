// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:skincare_app/shared_widgets.dart';
// import 'BookAppointment.dart';
// import 'dermatologist_model.dart';
//
//
// class DoctorChannelingScreen extends StatefulWidget {
//   const DoctorChannelingScreen({super.key});
//
//   @override
//   State<DoctorChannelingScreen> createState() => _DoctorChannelingScreenState();
// }
//
// class _DoctorChannelingScreenState extends State<DoctorChannelingScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   // List<Dermatologist> filteredDermatologists = [...dermatologists];
//   List<Dermatologist> dermatologists = [];
//   List<Dermatologist> filteredDermatologists = [];
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchDermatologists();
//     _searchController.addListener(() => _filterDermatologists(_searchController.text));
//     _searchController.addListener(
//           () => _filterDermatologists(_searchController.text),
//     );
//   }
//
//   void _fetchDermatologists() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('dermatologists')
//           .where('isActive', isEqualTo: true)
//           .get();
//
//       final docs = snapshot.docs.map((doc) =>
//           Dermatologist.fromMap(doc.id, doc.data())
//       ).toList();
//
//       setState(() {
//         dermatologists = docs;
//         filteredDermatologists = docs;
//       });
//     } catch (e) {
//       print("Error fetching dermatologists: $e");
//     }
//   }
//
//   void _filterDermatologists(String query) {
//     if (query.isEmpty) {
//       setState(() => filteredDermatologists = dermatologists);
//       return;
//     }
//
//     setState(() {
//       filteredDermatologists = dermatologists
//           .where((derm) => derm.name.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const CustomHeader(),
//             const CustomNavigationBar(activeRoute: 'Doctor Channelling'),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // Search Bar
//                     Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: SearchBar(
//                         controller: _searchController,
//                         hintText: 'Search Your Doctor',
//                         leading: const Icon(Icons.search),
//                         onChanged: (value) => _filterDermatologists(value),
//                       ),
//                     ),
//
//                     // Center Image
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 20),
//                       child: Image.asset(
//                         'assets/images/Doctorimage.png',
//                         width: 200,
//                         height: 200,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//
//                     // Contact Your Doctor text
//                     const Padding(
//                       padding: EdgeInsets.only(bottom: 20),
//                       child: Text(
//                         'Contact Your Doctor',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//
//                     // Short Description
//                     const Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 40,
//                         vertical: 10,
//                       ),
//                       child: Text(
//                         'Book an appointment with doctor. Chat or talk with doctor and get consultations.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     ),
//
//                     // Horizontal Scroll Dermatologist Cards
//                     SizedBox(
//                       height: 300,
//                       child:
//                           filteredDermatologists.isEmpty
//                               ? const Center(child: Text('No doctors found'))
//                               : ListView.separated(
//                                 scrollDirection: Axis.horizontal,
//                                 padding: const EdgeInsets.all(20),
//                                 itemCount: filteredDermatologists.length,
//                                 separatorBuilder:
//                                     (context, index) =>
//                                         const SizedBox(width: 20),
//                                 itemBuilder:
//                                     (context, index) => DermatologistCard(
//                                       dermatologist:
//                                           filteredDermatologists[index],
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder:
//                                                 (
//                                                   context,
//                                                 ) => BookAppointmentScreen(
//                                                   dermatologist:
//                                                       filteredDermatologists[index], userId: '', userName: '', userEmail: '', userPhone: '',
//                                                 ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                               ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class DermatologistCard extends StatelessWidget {
//   final Dermatologist dermatologist;
//   final VoidCallback onTap;
//
//   const DermatologistCard({
//     super.key,
//     required this.dermatologist,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 280,
//         decoration: BoxDecoration(
//           color: const Color(0xFF004237),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Top Row with Avatar and Rating
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Doctor Avatar
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundImage: AssetImage(dermatologist.imageAsset),
//                 ),
//
//                 // Rating
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.amber,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.star, color: Colors.white, size: 16),
//                       const SizedBox(width: 4),
//                       Text(
//                         dermatologist.rating.toString(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             // Doctor Name
//             Text(
//               dermatologist.name,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             // Location
//             Text(
//               dermatologist.location,
//               style: const TextStyle(color: Colors.white70, fontSize: 14),
//             ),
//
//             const SizedBox(height: 15),
//
//             // Description
//             Expanded(
//               child: Text(
//                 dermatologist.description,
//                 style: const TextStyle(color: Colors.white, fontSize: 14),
//                 maxLines: 4,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skincare_app/shared_widgets.dart';
import 'BookAppointment.dart';
import 'dermatologist_model.dart';

class DoctorChannelingScreen extends StatefulWidget {
  const DoctorChannelingScreen({super.key});

  @override
  State<DoctorChannelingScreen> createState() => _DoctorChannelingScreenState();
}

class _DoctorChannelingScreenState extends State<DoctorChannelingScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Dermatologist> dermatologists = [];
  List<Dermatologist> filteredDermatologists = [];

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _fetchDermatologists();
    _searchController.addListener(() => _filterDermatologists(_searchController.text));

    // Initialize animations
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _floatAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _pulseController.repeat(reverse: true);
    _floatController.repeat(reverse: true);
  }

  void _fetchDermatologists() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('dermatologists')
          .where('isActive', isEqualTo: true)
          .get();

      final docs = snapshot.docs.map((doc) =>
          Dermatologist.fromMap(doc.id, doc.data())
      ).toList();

      setState(() {
        dermatologists = docs;
        filteredDermatologists = docs;
      });
    } catch (e) {
      print("Error fetching dermatologists: $e");
    }
  }

  void _filterDermatologists(String query) {
    if (query.isEmpty) {
      setState(() => filteredDermatologists = dermatologists);
      return;
    }

    setState(() {
      filteredDermatologists = dermatologists
          .where((derm) => derm.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            const CustomNavigationBar(activeRoute: 'Doctor Channelling'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SearchBar(
                          controller: _searchController,
                          hintText: 'Search Your Doctor',
                          leading: const Icon(Icons.search, color: Colors.grey),
                          onChanged: (value) => _filterDermatologists(value),
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Animated Center Image
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_pulseController, _floatController]),
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnimation.value),
                            child: Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                decoration: BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                ).toString().isNotEmpty ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 20,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ) : null,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/images/Doctorimage.png',
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Contact Your Doctor text with gradient
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF004237), Colors.teal],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          'Contact Your Doctor',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // Enhanced Description
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.withOpacity(0.1)),
                        ),
                        child: const Text(
                          'Book an appointment with doctor. Chat or talk with doctor and get consultations.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Enhanced Horizontal Scroll Dermatologist Cards
                    SizedBox(
                      height: 340, // Increased height to accommodate button
                      child: filteredDermatologists.isEmpty
                          ? const Center(
                        child: Text(
                          'No doctors found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                          : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(20),
                        itemCount: filteredDermatologists.length,
                        separatorBuilder: (context, index) =>
                        const SizedBox(width: 20),
                        itemBuilder: (context, index) => EnhancedDermatologistCard(
                          dermatologist: filteredDermatologists[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookAppointmentScreen(
                                  dermatologist: filteredDermatologists[index],
                                  userId: '',
                                  userName: '',
                                  userEmail: '',
                                  userPhone: '',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EnhancedDermatologistCard extends StatefulWidget {
  final Dermatologist dermatologist;
  final VoidCallback onTap;

  const EnhancedDermatologistCard({
    super.key,
    required this.dermatologist,
    required this.onTap,
  });

  @override
  State<EnhancedDermatologistCard> createState() => _EnhancedDermatologistCardState();
}

class _EnhancedDermatologistCardState extends State<EnhancedDermatologistCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() => _isHovered = true);
              _hoverController.forward();
            },
            onTapUp: (_) {
              setState(() => _isHovered = false);
              _hoverController.reverse();
            },
            onTapCancel: () {
              setState(() => _isHovered = false);
              _hoverController.reverse();
            },
            child: Container(
              width: 290,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF004237),
                    Color(0xFF005A4A),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF004237).withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    spreadRadius: -2,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row with Avatar and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Enhanced Doctor Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(widget.dermatologist.imageAsset),
                          ),
                        ),
                      ),

                      // Enhanced Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.amber, Colors.orange],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              widget.dermatologist.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Doctor Name
                  Text(
                    widget.dermatologist.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Location with Icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white70,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.dermatologist.location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Expanded(
                    child: Text(
                      widget.dermatologist.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Enhanced Book Now Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF004237),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Book Now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
