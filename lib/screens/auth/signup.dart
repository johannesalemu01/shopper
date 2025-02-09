import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopper/screens/auth/login.dart';
import 'package:shopper/screens/home/buyer/buyer_screen.dart';
import 'package:shopper/screens/role/role_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  bool ishidden = true;
  final auth = FirebaseAuth.instance;

  Future<void> updateDisplayName(String name) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.updateDisplayName(nameController.text.trim());
      await user.reload();
      user = FirebaseAuth.instance.currentUser;
    }
  }

  Future<void> signup() async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SelectRoleScreen(userId: userCredential.user!.uid)),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred.')),
      );
    }
  }

  @override
  build(context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(size: 0),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Stack(children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: Image.asset(
                    'assets/images/authbg6.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                    top: 55,
                    right: 40,
                    child: InkWell(
                      onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BuyerScreen())),
                      child: Text(
                        'skip',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 82, 78, 78),
                            fontSize: 20),
                      ),
                    )),
                Positioned(
                  bottom: 0,
                  left: 150,
                  child: Text(
                    'SignUp',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(158, 190, 134, 104)),
                  ),
                ),
              ]),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 30, 38, 47),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                        child: Column(
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(224, 255, 255, 255),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 0.8),
                                      borderRadius: BorderRadius.circular(8)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.8,
                                        color:
                                            Color.fromARGB(157, 244, 244, 244),
                                      ),
                                      borderRadius: BorderRadius.circular(8)),
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 41, 39, 39),
                                  ),
                                  hintText: 'please enter your username',
                                  hintStyle: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 146, 148, 149)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(224, 255, 255, 255),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 0.8),
                                      borderRadius: BorderRadius.circular(8)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: const Color.fromARGB(
                                            255, 214, 238, 238),
                                      ),
                                      borderRadius: BorderRadius.circular(8)),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 41, 39, 39),
                                  ),
                                  hintText: 'please enter your email',
                                  hintStyle: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 146, 148, 149)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              obscureText: ishidden,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() {
                                      ishidden = !ishidden;
                                    }),
                                    icon: ishidden
                                        ? Icon(Icons.visibility_rounded)
                                        : Icon(Icons.visibility_off_rounded),
                                  ),
                                  isDense: true,
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(224, 255, 255, 255),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 0.8),
                                      borderRadius: BorderRadius.circular(8)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 0.8),
                                      borderRadius: BorderRadius.circular(8)),
                                  hintText: 'please enter your password',
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 41, 39, 39),
                                  ),
                                  hintStyle: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 146, 148, 149)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: signup,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        width: 350,
                        decoration: const BoxDecoration(
                            // color: Color.fromARGB(244, 75, 53, 18),
                            color: Color.fromARGB(255, 2, 104, 104),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: const Text(
                          'SignUp',
                          style: TextStyle(
                              color: Color.fromARGB(255, 222, 221, 221),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already  have an account?  ',
                          style: TextStyle(fontSize: 16, color: Colors.white54),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          child: const Text(
                            'login ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 235, 124, 81),
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    )
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
