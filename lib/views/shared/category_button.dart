import 'package:flutter/material.dart';
import 'package:sneaker_app/views/shared/app_style.dart';

class CategoryBtn extends StatelessWidget {
  const CategoryBtn(
      {super.key, this.onPress, required this.buttonClr, required this.label});
  final void Function()? onPress;
  final Color buttonClr;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        height: 46,
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: buttonClr,
              style: BorderStyle.solid,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(9))),
        child: Center(
          child: Text(
            label,
            style: appStyle(16, buttonClr, FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
