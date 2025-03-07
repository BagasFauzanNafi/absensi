import 'package:flutter/material.dart';

void customSnackbar(BuildContext context, IconData icon, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.deepOrange,
      shape: const StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
  );
}