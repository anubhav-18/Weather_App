import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherProvider extends ChangeNotifier {
  // List to store recent search cities
  List<String> _recentSearches = [];
  // Nullable string to store the selected city
  String? _selectedCity;

  // String to store the selected unit of temperature
  String _selectedUnit = 'Celsius (\u00B0C)'; // Initial unit

  // Constructor to load recent searches and selected unit when the provider is created
  WeatherProvider() {
    _loadRecentSearches();
    _loadSelectedUnit();
  }

  // Getters for accessing the private fields
  String? get selectedCity => _selectedCity;
  List<String> get recentSearches => _recentSearches;
  String get selectedUnit => _selectedUnit;

  // Method to set the selected city and save it in recent searches and SharedPreferences
  void setSelectedCity(String city) async {
    _selectedCity = city;
    addRecentSearch(city);
    await _saveRecentSearches(); // Save to SharedPreferences
    notifyListeners(); // Notify listeners about the change
    print('Selected City Saved: $_selectedCity'); // Debug print
  }

  // Method to set the selected unit and save it in SharedPreferences
  void setSelectedUnit(String unit) {
    _selectedUnit = unit;
    _saveSelectedUnit(); // Save the selected unit
    notifyListeners(); // Notify listeners about the change
  }

  // Method to add a city to recent searches
  void addRecentSearch(String city) async {
    if (!recentSearches.contains(city)) {
      _recentSearches.remove(city); // Remove city if it already exists in the list
    }
    _recentSearches.insert(0, city); // Add city to the start of the list
    if (_recentSearches.length > 5) {
      _recentSearches.removeLast(); // Remove the last city if the list exceeds 5 items
    }
    await _saveRecentSearches(); // Save updated recent searches to SharedPreferences
    notifyListeners(); // Notify listeners about the change
  }

  // Method to save the selected unit to SharedPreferences
  Future<void> _saveSelectedUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedUnit', _selectedUnit);
  }

  // Load the selected unit from SharedPreferences when the app starts
  Future<void> _loadSelectedUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedUnit = prefs.getString('selectedUnit') ?? 'Celsius (\u00B0C)';
  }

  // Load recent searches and selected city from SharedPreferences when the app starts
  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _recentSearches = prefs.getStringList('recentSearches') ?? [];
    _selectedCity = prefs.getString('selectedCity');
    notifyListeners(); // Notify listeners about the change
  }

  // Save recent searches and selected city to SharedPreferences
  Future<void> _saveRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentSearches', recentSearches);
    await prefs.setString('selectedCity', _selectedCity ?? "");
    print('Selected City save recent searches: $_selectedCity'); // Debug print
  }

  // Method to delete a city from recent searches
  void deleteRecentSearch(String city) async {
    _recentSearches.remove(city);
    await _saveRecentSearches(); // Save updated recent searches to SharedPreferences
    notifyListeners(); // Notify listeners about the change
  }

  // Method to clear all recent searches
  void clearRecentSearches() async {
    _recentSearches.clear();
    await _saveRecentSearches(); // Save updated recent searches to SharedPreferences
    notifyListeners(); // Notify listeners about the change
  }
}
