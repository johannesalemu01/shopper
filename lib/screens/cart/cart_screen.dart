import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopper/proviers/cart_provider.dart';
import 'package:shopper/screens/cart/checkout_screen.dart';
import 'package:shopper/screens/home/buyer/buyer_screen.dart';
import 'package:shopper/screens/home/buyer/products.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool showTotal = false;

  @override
  Widget build(BuildContext context) {
    final cartProducts = ref.watch(cartNotifierProvider);
    final totalPrice = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 218, 206),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BuyerScreen()),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        title: const Text(
          'Your Cart',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              ref.read(cartNotifierProvider.notifier).deleteAll();
            },
          ),
        ],
      ),
      body: cartProducts.isEmpty
          ? Center(
              child: Text(
                'Cart is empty',
                style: TextStyle(
                    color: const Color.fromARGB(255, 89, 115, 128),
                    fontSize: 20),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 30),
                    child: Column(
                      children: cartProducts.map((product) {
                        return Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.network(
                                    product.image,
                                    height: 90,
                                    width: 90,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(product.name),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                'Br ${product.price.toString()}',
                                textAlign: TextAlign.end,
                              ),
                              const SizedBox(
                                width: 70,
                              ),
                              InkWell(
                                onTap: () {
                                  ref
                                      .read(cartNotifierProvider.notifier)
                                      .removeProduct(product);
                                },
                                child: const Icon(Icons.cancel),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showTotal = true;
                      });
                    },
                    child: cartProducts.isNotEmpty
                        ? const Text('Total Price')
                        : const SizedBox(),
                  ),
                  showTotal && cartProducts.isNotEmpty
                      ? Card(
                          color: const Color.fromARGB(255, 140, 174, 192),
                          elevation: 5,
                          shape: const StadiumBorder(
                              side: BorderSide(color: Colors.transparent)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              'Total: Br ${totalPrice.toString()}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 40,
                  ),
                  cartProducts.isNotEmpty
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  totalPrice: totalPrice.toDouble(),
                                  cartProducts: cartProducts.toList(),
                                ),
                              ),
                            );
                          },
                          child: const Text('Proceed to Checkout'),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
    );
  }
}
