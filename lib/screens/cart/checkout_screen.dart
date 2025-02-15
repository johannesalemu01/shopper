import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopper/proviers/cart_provider.dart';
import 'package:shopper/proviers/history_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopper/screens/home/buyer/buyer_screen.dart';

class CheckoutScreen extends ConsumerWidget {
  final double totalPrice;
  final List cartProducts;

  const CheckoutScreen({
    super.key,
    required this.totalPrice,
    required this.cartProducts,
  });

  Future<void> confirmPurchase(BuildContext context, WidgetRef ref) async {
    for (var product in cartProducts) {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .update({
        'isSold': true,
        'buyerId': FirebaseAuth.instance.currentUser?.uid,
      });
    }

    ref.read(historyProvider.notifier).addPurchase(
          totalPrice: totalPrice,
          date: DateTime.now(),
          sellerName: '${FirebaseAuth.instance.currentUser?.displayName}',
        );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Confirmed!'),
        content: const Text(
            'Thank you for your purchase. Your order has been placed.'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(cartNotifierProvider.notifier).deleteAll();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => BuyerScreen()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = FirebaseAuth.instance.currentUser;
    user?.displayName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: cartProducts.map((product) {
                  return ListTile(
                    leading:
                        Image.network(product.image, height: 80, width: 80),
                    title: Text(
                      product.name,
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Text(
                      '\$${product.price}',
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => confirmPurchase(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Confirm Purchase',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
