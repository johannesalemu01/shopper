import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopper/proviers/history_provider.dart';
import 'package:shopper/screens/home/buyer/buyer_screen.dart';
import 'package:shopper/screens/home/buyer/products.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BuyerScreen()),
            );
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Purchase History',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'No purchase history yet.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : Column(
              children: [
                Flexible(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final purchase = history[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(
                            'Purchased from: ${purchase.sellerName}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Date: ${purchase.date.toLocal().toString().split(' ')[0]}',
                          ),
                          trailing: Text(
                            'Br ${purchase.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      () {
                        ref.read(historyProvider.notifier).clearHistory();
                      }();
                    },
                    child: const Text('Clear History'),
                  ),
                ),
              ],
            ),
    );
  }
}
