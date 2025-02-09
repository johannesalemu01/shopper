import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopper/proviers/cart_provider.dart';

import 'package:shopper/proviers/history_provider.dart';

class CheckoutScreen extends ConsumerWidget {
  final double totalPrice;
  final List cartProducts;

  const CheckoutScreen({
    super.key,
    required this.totalPrice,
    required this.cartProducts,
  });
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
                        Image.network(product.image, height: 50, width: 50),
                    title: Text(product.name),
                    trailing: Text('\$${product.price}'),
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
              onPressed: () {
                ref.read(historyProvider.notifier).addPurchase(
                      totalPrice: totalPrice,
                      date: DateTime.now(),
                      sellerName: '${user?.displayName}',
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
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
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
