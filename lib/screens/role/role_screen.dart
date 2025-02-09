import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectRoleScreen extends StatelessWidget {
  final String userId; 

  const SelectRoleScreen({super.key, required this.userId});

  // Function to update the user's role in Firestore
  Future<void> setUserRole(String role) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .set({'role': role}, SetOptions(merge: true));
      print('User role updated to $role');
    } catch (e) {
      print('Error updating user role: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2d3845),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 27, 35, 44),
        title: const Text(
          'Select Your Role',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Join as:',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  await setUserRole('seller'); // Save the role as "seller"
                  Navigator.pushReplacementNamed(context,
                      '/sellerhome'); // Navigate to seller's home screen
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Seller',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await setUserRole('buyer'); // Save the role as "buyer"
                  Navigator.pushReplacementNamed(
                      context, '/buyerhome'); // Navigate to buyer's home screen
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Buyer',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
