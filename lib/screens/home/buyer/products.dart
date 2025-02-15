import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopper/models/product.dart';
import 'package:shopper/proviers/cart_provider.dart';
import 'package:shopper/proviers/product_provider.dart';
import 'package:shopper/screens/home/animated_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopper/screens/home/buyer/product_detail.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String _sortOption = 'name';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 62, 73),
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 31, 62, 73),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: PopupMenuButton<String>(
              color: Colors.white,
              onSelected: (value) {
                setState(() {
                  _sortOption = value;
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'name',
                  child: Text('Sort by Name'),
                ),
                const PopupMenuItem(
                  value: 'price',
                  child: Text('Sort by Price'),
                ),
                const PopupMenuItem(
                  value: 'date',
                  child: Text('Sort by Added Date'),
                ),
              ],
              child: const Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: productsAsync.when(
          data: (products) {
            products.sort((a, b) {
              switch (_sortOption) {
                case 'price':
                  return a.price.compareTo(b.price);
                case 'date':
                  return a.timestamp.compareTo(b.timestamp);
                case 'name':
                default:
                  return a.name.compareTo(b.name);
              }
            });

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
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(productId: product.id),
                      ),
                    );
                  },
                  child: AnimatedZIndexItem(
                    product: product,
                    isInCart: ref.watch(cartNotifierProvider).contains(product),
                    onAddToCart: () => ref
                        .read(cartNotifierProvider.notifier)
                        .addToCart(products[index]),
                    onRemoveFromCart: () => ref
                        .read(cartNotifierProvider.notifier)
                        .removeFromCart(products[index]),
                  ),
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
