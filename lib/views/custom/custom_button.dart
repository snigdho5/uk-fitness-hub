import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(kDefaultPadding),
          border: Border.all(color: primaryColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.4),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding / 2, vertical: kDefaultPadding),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontSize: kDefaultPadding * 1.2,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
