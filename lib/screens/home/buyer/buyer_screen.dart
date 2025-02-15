import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopper/proviers/cart_provider.dart';
import 'package:shopper/proviers/product_provider.dart';
import 'package:shopper/screens/auth/login.dart';
import 'package:shopper/screens/cart/cart_screen.dart';
import 'package:shopper/screens/home/buyer/buyer_history.dart';
import 'package:shopper/screens/home/buyer/products.dart';
import 'package:shopper/shared/cart_icon.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shopper/screens/home/buyer/product_detail.dart';

class BuyerScreen extends ConsumerStatefulWidget {
  const BuyerScreen({super.key});

  @override
  _BuyerScreenState createState() => _BuyerScreenState();
}

class _BuyerScreenState extends ConsumerState<BuyerScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  File? imageFile;
  bool _isUploading = false;
  String? imageStore;

  void logout(BuildContext context) async {
    await auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  Future<void> selectImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
      uploadProfileImage();
    }
  }

  Future<void> uploadProfileImage() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final path = 'uploads/$fileName';

      await Supabase.instance.client.storage
          .from('avatar')
          .upload(path, imageFile!, fileOptions: FileOptions(upsert: true));
      imageStore =
          Supabase.instance.client.storage.from('avatar').getPublicUrl(path);
      storeProileimage();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> storeProileimage() async {
    final user = FirebaseAuth.instance.currentUser;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);
    await userDocRef.update({
      'imageUrl': imageStore,
    });
    setState(() {
      imageUrl = imageStore;
    });
  }

  String? imageUrl;
  @override
  initState() {
    super.initState();
    fetchUserImage();
  }

  Future<void> fetchUserImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        imageUrl = userDoc.data()?['imageUrl'];
      });
    }
  }

  void onNavItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void navigateToDetail(BuildContext context, String productId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productId: productId),
      ),
    );
  }

  int selectedIndex = 0;

  final List<Widget> navScreen = [
    ProductsScreen(),
    CartScreen(),
    HistoryScreen()
  ];

  @override
  Widget build(BuildContext context) {
    String text = auth.currentUser?.email ?? '';
    String letter = text.isNotEmpty ? text[0] : '?';
    final cartList = ref.watch(cartNotifierProvider);
    final products = ref.watch(productProvider);

    final appBarTitles = [
      ' Product on Sale',
      null,
      null,
    ];
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(auth.currentUser?.displayName ?? ""),
              accountEmail: Text(text),
              currentAccountPicture: CircleAvatar(
                child: GestureDetector(
                  onTap: selectImage,
                  child: ClipOval(
                    child: imageUrl != null
                        ? Image.network(
                            '$imageUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, size: 40);
                            },
                          )
                        : Center(
                            child: Text(
                              letter,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/authbg2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopify_sharp,
                  color: Color.fromARGB(255, 98, 187, 88),
                ),
                SizedBox(
                  width: 8,
                ),
                const Text(
                  'Shopper',
                  style: TextStyle(
                      color: Color.fromARGB(255, 229, 246, 229),
                      fontStyle: FontStyle.italic,
                      fontSize: 20),
                ),
              ],
            ),
            ListTile(
              leading: Text(
                'logout',
                style: TextStyle(
                    color: const Color.fromARGB(255, 236, 232, 232),
                    fontSize: 16),
              ),
              trailing: IconButton(
                onPressed: () => logout(context),
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      appBar: appBarTitles[selectedIndex] != null
          ? AppBar(
              title: Text('${appBarTitles[selectedIndex]}'),
              backgroundColor: Color.fromARGB(255, 192, 205, 213),
              actions: const [CartIcon()],
            )
          : null,
      body: navScreen[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xff2d3845),
          currentIndex: selectedIndex,
          onTap: (index) => setState(() {
                selectedIndex = index;
              }),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
          ]),
    );
  }
}
