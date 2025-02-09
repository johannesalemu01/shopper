import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopper/screens/auth/login.dart';
import 'package:shopper/screens/home/buyer/buyer_screen.dart';
import 'package:shopper/screens/home/seller/seller_screen.dart';
import 'package:shopper/screens/role/role_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  Future<String?> getUserRole(String userId) async {
    final firestore = FirebaseFirestore.instance;
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data()?['role'];
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _checkAuthState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data != null) {
          final user = snapshot.data!;
          return FutureBuilder<String?>(
            future: getUserRole(user.uid),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (roleSnapshot.hasData) {
                final role = roleSnapshot.data;
                if (role == 'seller') {
                  return const SellerScreen();
                } else if (role == 'buyer') {
                  return BuyerScreen();
                }
              }

              return SelectRoleScreen(userId: user.uid);
            },
          );
        }

        return const Login();
      },
    );
  }

  Future<User?> _checkAuthState() async {
    final auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      await auth.signOut();
    }
    return auth.currentUser;
  }
}
