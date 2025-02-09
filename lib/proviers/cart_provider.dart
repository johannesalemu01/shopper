import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shopper/models/product.dart';

part 'cart_provider.g.dart';

@riverpod
class cartNotifier extends _$cartNotifier {
  @override
  Set<Product> build() {
    return {};
  }

  void addToCart(Product product) {
    if (!state.contains(product)) {
      state = {...state, product};
    }
  }

  void removeFromCart(Product product) {
    if (state.contains(product)) {
      state = state.where((prod) {
        return prod.id != product.id;
      }).toSet();
    }
  }

  void deleteAll() {
    state = {};
  }

  void removeProduct(Product product) {
    state = state.where((prod) {
      return prod.id != product.id;
    }).toSet();
  }


}




@riverpod
double cartTotal(Ref ref) {
  final cartProducts = ref.watch(cartNotifierProvider);

  double total = 0;
  for (Product product in cartProducts) {
    total += product.price;
  }
  return total;
}

@riverpod
int cartCount(ref) {
  return ref.watch(cartNotifierProvider).length;
}

