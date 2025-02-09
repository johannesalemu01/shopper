import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopper/firebase_options.dart';
import 'package:shopper/main_page.dart';
import 'package:shopper/screens/auth/login.dart';
import 'package:shopper/screens/auth/signup.dart';
import 'package:shopper/screens/home/buyer/buyer_screen.dart';
import 'package:shopper/screens/home/seller/seller_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: 'https://mjmtiamtkxzabsymsvlr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1qbXRpYW10a3h6YWJzeW1zdmxyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczMzU2NzMsImV4cCI6MjA1MjkxMTY3M30.wIpX2-ZyaXpV8iQtrLunOszbwfzjA-5BRvwb9UIjhp4',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/signup': (context) => const SignUp(),
        '/login': (context) => const Login(),
        '/buyerhome': (context) => BuyerScreen(),
        '/sellerhome': (context) => SellerScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: MainPage(),
    );
  }
}
