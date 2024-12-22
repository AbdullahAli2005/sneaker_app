import 'package:flutter/material.dart';

import 'app_style.dart';

class CheckoutButton extends StatelessWidget {
  const CheckoutButton({super.key, this.onTap, required this.label});

  final void Function()? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Center(
            child:
                Text(label, style: appStyle(18, Colors.white, FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}
