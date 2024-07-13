import 'package:flutter/material.dart';

class CustomSnackbar {

  final String text;
  final Function? onUndoPressed;
  final String? undoLabelText;
  final Color? backGroundColor;
  final BuildContext context;
  final int hideTimeout;
  final Color textColor;

  const CustomSnackbar({
    required this.text,
    this.onUndoPressed,
    this.undoLabelText,
    this.backGroundColor,
    required this.context,
    this.hideTimeout = 10,
    this.textColor = Colors.white
  });

  void showSnackBar() {
    final snackBar = SnackBar(
      content: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(text,style: TextStyle(color: textColor))
        )
      ),
      action: undoLabelText != null && onUndoPressed != null ? SnackBarAction(
        label: undoLabelText!,
        onPressed: () {
          onUndoPressed!();
        },
      ) : null,
      duration: Duration(seconds: hideTimeout),
      backgroundColor: backGroundColor ?? Colors.amber,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
   
  }
}