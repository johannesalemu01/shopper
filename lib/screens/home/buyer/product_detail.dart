import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopper/proviers/cart_provider.dart';
import 'package:shopper/models/product.dart';
import 'package:shopper/screens/cart/cart_screen.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  Future<DocumentSnapshot> fetchProductDetails() async {
    return await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text('Product Detail'),
          backgroundColor: const Color.fromARGB(255, 200, 231, 228)),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchProductDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
                child: Text('Product not found',
                    style: TextStyle(color: Colors.white)));
          }

          var productData = snapshot.data!.data() as Map<String, dynamic>;
          final product = Product.fromFirestore(snapshot.data!);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: productData['imageUrl'] ?? '',
                      width: double.infinity,
                      height: 500,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return Icon(Icons.error,
                            size: 100, color: Colors.white);
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.black54,
                        child: Text(
                          '\$${productData['price']?.toString() ?? '0'}',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productData['name'].toString().toUpperCase() ??
                            'No name',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        productData['description'] ?? 'No description',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(cartNotifierProvider.notifier)
                              .addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added to cart')),
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CartScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('Add to Cart',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
