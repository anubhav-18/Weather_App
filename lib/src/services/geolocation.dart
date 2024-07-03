import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/src/reusable_widget/custom_snackbar.dart';

// Function to get the current location of the user
Future<Position> getLocation(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showCustomSnackBar(context, 'The location service is not enabled.', isError: true);
    return Future.error('The location service is not enabled.');
  }

  // Check and request location permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showCustomSnackBar(context, 'The location permission is denied.', isError: true);
      return Future.error('The location permission is denied.');
    }
  }

  // Handle permanently denied location permissions
  if (permission == LocationPermission.deniedForever) {
    showCustomSnackBar(context, 'Location permissions are permanently denied.', isError: true);
    return Future.error('Location permissions are permanently denied.');
  }

  // Get the current position of the device with desired accuracy
  try {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  } catch (e) {
    showCustomSnackBar(context, 'Failed to get current location: $e', isError: true);
    return Future.error('Failed to get current location: $e');
  }
}