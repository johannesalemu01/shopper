import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopper/screens/auth/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final picker = ImagePicker();
  File? _imageFile;
  final supabase = Supabase.instance.client;

  int _selectedIndex = 0;

  Future<void> uploadProduct() async {
    if (_imageFile == null ||
        _productNameController.text.isEmpty ||
        _productPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      final imageName = DateTime.now().millisecondsSinceEpoch.toString();
      await supabase.storage
          .from('product-images')
          .upload('uploads/$imageName', _imageFile!);

      final publicUrl = supabase.storage
          .from('product-images')
          .getPublicUrl('uploads/$imageName');

      await FirebaseFirestore.instance.collection('products').add({
        'name': _productNameController.text,
        'price': double.parse(_productPriceController.text),
        'imageUrl': publicUrl,
        'sellerId': FirebaseAuth.instance.currentUser!.uid,
        'buyerId': null,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product uploaded successfully!")),
      );

      setState(() {
        _imageFile = null;
        _productNameController.clear();
        _productPriceController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading product: $e")),
      );
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Widget _uploadProductScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 50),
        child: Column(
          children: [
            TextField(
              controller: _productNameController,
              decoration: const InputDecoration(
                  labelText: "Product Name",
                  hintText: 'Enter the name of the product',
                  hintStyle: TextStyle(color: Colors.blueGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  )),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _productPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                labelText: "Product Price",
                hintText: 'Enter the price of the product',
                hintStyle: TextStyle(color: Colors.blueGrey),
              ),
            ),
            const SizedBox(height: 35),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 350,
                width: double.infinity,
                color: const Color(0xff2d3845),
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : const Center(
                        child: Text(
                        "Tap to select an image",
                        style: TextStyle(color: Colors.white),
                      )),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadProduct,
              child: const Text("Upload Product"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listedProductsScreen() {
    final sellerId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('sellerId', isEqualTo: sellerId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No products listed yet."));
        }

        final products = snapshot.data!.docs;

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              leading: Image.network(product['imageUrl'], width: 50),
              title: Text(product['name']),
              subtitle: Text("Price: \$${product['price']}\n"
                  "Listed: ${product['timestamp'].toDate()}"),
              trailing: GestureDetector(
                  onTap: () => removeProduct(product),
                  child: Icon(Icons.delete)),
            );
          },
        );
      },
    );
  }

  void removeProduct(DocumentSnapshot product) {
    FirebaseFirestore.instance.collection('products').doc(product.id).delete();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  File? imageFile;

  Future<void> selectImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final screens = [_uploadProductScreen(), _listedProductsScreen()];
    void logout(BuildContext context) async {
      await auth.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }

    String text = auth.currentUser?.email ?? '';
    String letter = text.isNotEmpty ? text[0] : '?';
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
                    child: imageFile != null
                        ? Image.file(
                            imageFile!,
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
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
                const SizedBox(
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
              leading: const Text(
                'logout',
                style: TextStyle(
                    color: Color.fromARGB(255, 236, 232, 232), fontSize: 16),
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
      backgroundColor: const Color.fromARGB(255, 198, 203, 209),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Seller Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file),
            label: "Upload Product",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "View Products",
          ),
        ],
      ),
    );
  }
}
