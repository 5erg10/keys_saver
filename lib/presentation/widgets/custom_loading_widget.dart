import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {

  final String label;
  final Color textColor;

  const CustomLoading({super.key, required this.label, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 350.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 150.0,
            width: 150.0,
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeWidth: 2.0,
            ),
          ),
          const SizedBox(height: 50.0),
          Text(label, style: TextStyle(color: textColor, fontSize: 16.0, decoration: TextDecoration.none, fontWeight: FontWeight.w200))
        ]
      ),
    );
  }
}