// // dermatologist_model.dart
// class Dermatologist {
//   final String name;
//   final String location;
//   final String description;
//   final String imageAsset;
//   final double rating;
//
//   Dermatologist({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageAsset,
//     required this.rating,
//   });
// }

// dermatologist_model.dart
class Dermatologist {
  final String id; // Firestore document ID
  final String name;
  final String location;
  final String description;
  final String imageAsset;
  final double rating;
  final String email; // For sending notifications
  final List<String> workingDays; // e.g., ['Mon', 'Tue', 'Wed']
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Dermatologist({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imageAsset,
    required this.rating,
    required this.email,
    required this.workingDays,
    required this.startTime,
    required this.endTime,
  });

  factory Dermatologist.fromMap(String id, Map<String, dynamic> map) {
    final startTimeParts = (map['startTime'] as String).split(':');
    final endTimeParts = (map['endTime'] as String).split(':');

    return Dermatologist(
      id: id,
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      imageAsset: map['imageAsset'] ?? '',
      rating: (map['rating'] as num).toDouble(),
      email: map['email'] ?? '',
      workingDays: List<String>.from(map['workingDays'] ?? []),
      startTime: TimeOfDay(hour: int.parse(startTimeParts[0]), minute: int.parse(startTimeParts[1])),
      endTime: TimeOfDay(hour: int.parse(endTimeParts[0]), minute: int.parse(endTimeParts[1])),
    );
  }
}