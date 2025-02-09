import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopper/screens/auth/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isHidden = true;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    FocusScope.of(context).unfocus(); 

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userDoc.exists) {
          String role = userDoc['role'];
          if (role == 'buyer') {
          
            Navigator.pushReplacementNamed(context, '/buyerhome');
          } else if (role == 'seller') {
            Navigator.pushReplacementNamed(context, '/sellerhome');
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Role not recognized')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('user data not found, please signup')));
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'User not found. Redirecting to sign-up.';
        Navigator.pushReplacementNamed(context, '/signup');
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Please try again.';
      } else {
        errorMessage = 'An error occurred. Please try again later.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(size: 0),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Image.asset('assets/images/authbg4.jpg'),
                  ),
                  const Positioned(
                    bottom: 0,
                    left: 150,
                    child: Text(
                      'LogIn',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(158, 186, 168, 159),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 50),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 35, 43, 53),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(224, 255, 255, 255),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0.8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 214, 238, 238),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                labelText: 'Email',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 41, 39, 39),
                                ),
                                hintText: 'Please enter your email',
                                hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 146, 148, 149),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email.';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              obscureText: isHidden,
                              controller: passwordController,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() {
                                    isHidden = !isHidden;
                                  }),
                                  icon: isHidden
                                      ? const Icon(Icons.visibility_rounded)
                                      : const Icon(
                                          Icons.visibility_off_rounded),
                                ),
                                isDense: true,
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(224, 255, 255, 255),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0.8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0.8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText: 'Please enter your password',
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 41, 39, 39),
                                ),
                                hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 146, 148, 149),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password.';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters.';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    GestureDetector(
                      onTap: isLoading ? null : _login,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        width: 350,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color.fromARGB(255, 92, 40, 13),
                            Color.fromARGB(255, 137, 52, 10),
                            Color.fromARGB(255, 117, 48, 13),
                          ]),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 142, 140, 140),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ),
                            );
                          },
                          child: const Text(
                            'Create new account',
                            style: TextStyle(
                              color: Color.fromARGB(255, 208, 177, 177),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
