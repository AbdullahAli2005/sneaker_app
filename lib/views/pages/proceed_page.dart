import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_app/controllers/mainscreen_provider.dart';
import 'package:sneaker_app/views/pages/mainscreen.dart';

class ProceedPage extends StatelessWidget {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  final String phone;

   ProceedPage({super.key, required this.phone});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2E2E2),
        title: const Text("Order Confirmation"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Lottie animation
            Center(
              child: Lottie.asset(
                'assets/animation/success.json',
                width: 400,
                height: 300,
                repeat: false,
              ),
            ),
            const SizedBox(height: 20),
            // Order confirmation text
            const Text(
              "Your order is confirmed",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Information text
            Text(
              "We have sent order confirmation and other details to $phone.",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Continue Shopping Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Set the page index to Home (0)
                  context.read<MainScreenNotifier>().pageIndex = 0;

                  // Navigate back to MainScreen and ensure it doesn't add to the stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen(userEmail: userEmail)),
                    (route) => false, // Clear the navigation stack
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
