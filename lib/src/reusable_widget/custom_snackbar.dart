import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
  bool isLoading = false,
  bool isDuration = false,
  bool isBehaviourFloat = true,
  Duration time = const Duration(days: 1),
}) {
  final Color backgroundColor = isError ? Colors.red : whiteColor;

  final snackBar = SnackBar(
    content: Row(
      children: [
        // Optional icon based on error or success
        isError
            ? const Icon(Icons.error_outline, color: whiteColor)
            : const Icon(Icons.check_circle_outline, color: primaryBckgnd),
        const SizedBox(width: 10),
        Flexible(
          // Wrap text in Flexible to allow wrapping
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isError ? whiteColor : primaryBckgnd,
                ),
          ),
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: CircularProgressIndicator(
              color: whiteColor,
              strokeWidth: 2,
            ),
          ),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior:
        // isBehaviourFloat ?
        SnackBarBehavior.floating,
    // SnackBarBehavior.fixed,
    margin: const EdgeInsets.only(
      left: 16,
      right: 16,
      bottom: 20,
    ),
    duration: isDuration ? time : const Duration(seconds: 2),
    elevation: 6.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  );

  final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
  if (scaffoldMessenger != null) {
    scaffoldMessenger.showSnackBar(snackBar);
  }
}
