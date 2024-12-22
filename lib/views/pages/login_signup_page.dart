import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sneaker_app/views/pages/mainscreen.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isSignup = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isLoading = true);

      try {
        UserCredential userCredential;
        if (isSignup) {
          if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
            showErrorMessage('Passwords do not match');
            return;
          }
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
        } else {
          userCredential = await _auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
        }
        // Navigate to MainScreen and pass email
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(userEmail: userCredential.user?.email ?? ''),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // Handle errors
        showErrorMessage(e.message ?? 'An error occurred. Please try again later.');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Login/Signup Form
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isSignup ? 'Signup' : 'Login',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField(
                        'Email',
                        controller: emailController,
                      ),
                      const SizedBox(height: 12),
                      buildTextField(
                        'Password',
                        controller: passwordController,
                        obscureText: true,
                      ),
                      if (isSignup)
                        const SizedBox(height: 12),
                      if (isSignup)
                        buildTextField(
                          'Confirm Password',
                          controller: confirmPasswordController,
                          obscureText: true,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                if (!isLoading)
                  GestureDetector(
                    onTap: submit,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 137, 137, 137),
                        // gradient: LinearGradient(
                        //   colors: [Colors.grey[800]!, const Color.fromARGB(255, 99, 99, 99)!],
                        //   begin: Alignment.topLeft,
                        //   end: Alignment.bottomRight,
                        // ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      child: Text(
                        isSignup ? 'Signup' : 'Login',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (!isSignup)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isSignup
                          ? 'Already have an account? '
                          : 'Don’t have an account? ',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => isSignup = !isSignup);
                      },
                      child: Text(
                        isSignup ? 'Login' : 'Signup',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
    String labelText, {
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: Colors.grey[400]!), // Light grey when focused
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: Colors.grey[500]!), // Darker grey when not focused
        ),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey[700], // Dark gray for background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      cursorColor: const Color.fromARGB(255, 202, 202, 202),
      validator: (value) {
        if (value!.isEmpty) return 'Please enter $labelText';
        if (labelText == 'Email' &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }
}
