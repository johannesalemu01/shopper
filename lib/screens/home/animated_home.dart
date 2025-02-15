import 'package:flutter/material.dart';
import 'package:shopper/models/product.dart';
import 'package:shopper/proviers/product_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopper/screens/home/buyer/product_detail.dart';

class AnimatedZIndexItem extends StatefulWidget {
  final Product product;
  final bool isInCart;
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromCart;

  const AnimatedZIndexItem({
    super.key,
    required this.product,
    required this.isInCart,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  });

  @override
  _AnimatedZIndexItemState createState() => _AnimatedZIndexItemState();
}

class _AnimatedZIndexItemState extends State<AnimatedZIndexItem> {
  bool isCardOnTop = true;

  void toggleCardState() {
    setState(() {
      isCardOnTop = !isCardOnTop;
    });
  }

  bool isImageFetched = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailScreen(productId: widget.product.id),
          ),
        );
      },
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: isCardOnTop ? 0 : 5,
            left: isCardOnTop ? 0 : 5,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              transform: isCardOnTop ? Matrix4.identity() : Matrix4.identity()
                ..scale(0.95),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isCardOnTop ? 1.0 : 0.7,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: isCardOnTop ? 5 : 2,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: const EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 38, 55, 63)
                          .withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InteractiveViewer(
                          child: CachedNetworkImage(
                            imageUrl: widget.product.image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            widget.product.name.toUpperCase(),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 66, 84, 67),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Br ${widget.product.price.toString()}",
                            style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 66, 84, 67),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: 0,
            right: isCardOnTop ? 10 : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isCardOnTop ? 0.7 : 1.0,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(247, 238, 173, 99),
                ),
                onPressed: () {
                  toggleCardState();
                  if (widget.isInCart) {
                    widget.onRemoveFromCart();
                  } else {
                    widget.onAddToCart();
                  }
                },
                child: Text(
                  widget.isInCart ? 'Remove' : 'Add to Cart',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
