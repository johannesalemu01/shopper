import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;
  final DateTime timestamp;
  final bool isSold;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.timestamp,
    required this.isSold,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      image: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isSold: data['isSold'] ?? false,
    );
  }
}
