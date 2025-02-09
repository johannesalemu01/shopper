import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/product.dart';

part 'product_provider.g.dart';

@riverpod
Stream<List<Product>> product(ref) {
  return FirebaseFirestore.instance
      .collection('products')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Product(
        id: doc.id,
        name: data['name'] ?? 'No Name',
        price: data['price']?.toDouble() ?? 0.0,
        image: data['imageUrl'] ?? '',
      );
    }).toList();
  });
}

@riverpod
List<Product> reducedProduct(ref) {
  final productStream = ref.watch(productProvider);

  return productStream.maybeWhen(
    data: (products) => products.where((p) => p.price > 50).toList(),
    orElse: () => [],
  );
}
