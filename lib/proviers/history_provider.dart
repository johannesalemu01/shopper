import 'package:flutter_riverpod/flutter_riverpod.dart';

class Purchase {
  final DateTime date;
  final double totalPrice;
  final String sellerName;

  Purchase({
    required this.date,
    required this.totalPrice,
    required this.sellerName,
  });
}

class HistoryNotifier extends StateNotifier<List<Purchase>> {
  HistoryNotifier() : super([]);

  void addPurchase({
    required DateTime date,
    required double totalPrice,
    required String sellerName,
  }) {
    state = [
      ...state,
      Purchase(date: date, totalPrice: totalPrice, sellerName: sellerName),
    ];
  }


  void clearHistory() {
    state = [];
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<Purchase>>((ref) {
  return HistoryNotifier();
});
