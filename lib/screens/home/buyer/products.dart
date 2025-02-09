import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopper/models/product.dart';
import 'package:shopper/proviers/cart_provider.dart';
import 'package:shopper/proviers/product_provider.dart';
import 'package:shopper/screens/home/animated_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 62, 73),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: productsAsync.when(
          data: (products) {
            return GridView.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 2
                        : 4,
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
                childAspectRatio:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 0.55
                        : 0.7,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return AnimatedZIndexItem(
                  product: product,
                  isInCart: ref.watch(cartNotifierProvider).contains(product),
                  onAddToCart: () => ref
                      .read(cartNotifierProvider.notifier)
                      .addToCart(products[index]),
                  onRemoveFromCart: () => ref
                      .read(cartNotifierProvider.notifier)
                      .removeFromCart(products[index]),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text(
              'Error: $err',
              style: const TextStyle(color: Colors.white),
            ),
          ), 
        ),
      ),
    );
  }
}
































































































































