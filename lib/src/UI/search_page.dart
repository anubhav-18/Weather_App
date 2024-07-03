import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/provider/weather_provider.dart';
import 'package:weather_app/src/reusable_widget/custom_snackbar.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> _suggestion = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: primaryBckgnd),
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: whiteColor,
                  hintText: 'Search for a city...', // Shortened hint text
                  hintStyle: const TextStyle(
                    color: textColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: primaryBckgnd,
                      size: 30,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: primaryBckgnd,
                    ),
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        _suggestion.clear();
                      });
                    },
                  ),
                ),
              ),
            ),
            const Divider(thickness: 1, color: greycolor2),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: whiteColor,
                      ),
                    )
                  : searchController.text.isEmpty
                      ? weatherProvider.recentSearches.isEmpty
                          ? Center(
                              child: Text(
                                "No recent searches",
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            )
                          : ListView.builder(
                              itemCount: weatherProvider.recentSearches.length,
                              itemBuilder: (context, index) {
                                final locationString =
                                    weatherProvider.recentSearches[index];
                                return ListTile(
                                  title: Text(
                                    locationString,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context, locationString);
                                  },
                                  leading: const Icon(
                                    Icons.history,
                                    color: whiteColor,
                                    size: 20,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      weatherProvider.deleteRecentSearch(locationString);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                );
                              },
                            )
                      : ListView.builder(
                          itemCount: _suggestion.length,
                          itemBuilder: (context, index) {
                            final location = _suggestion[index];
                            return InkWell(
                              onTap: () => _onSuggestionSelected(location),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_pin,
                                      size: 20,
                                      color: whiteColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            location['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                          Text(
                                            "${location['state'] ?? ''}, ${location['country']}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: greycolor2
                                                      .withOpacity(0.9),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestion.clear();
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiUrl =
          'http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$apiKey';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _suggestion = data
              .map((location) => {
                    'name': location['name'],
                    'state': location['state'] ?? '', // Handle missing state
                    'country': location['country']
                  })
              .toList();
          _isLoading = false;
        });
      } else {
        showCustomSnackBar(context,
            'Error fetching city suggestions. Please Try Again Later!');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching city suggestions: $e');
      showCustomSnackBar(
          context, 'Error fetching city suggestions. Please Try Again Later!');
    }
  }

  void _onSuggestionSelected(Map<String, dynamic> selectedLocation) {
    final cityName = selectedLocation['name'];
    final stateName = selectedLocation['state'];
    final countryCode = selectedLocation['country'];

    // Build full location string for WeatherScreen
    String locationString = cityName;
    if (stateName.isNotEmpty) {
      locationString += ', $stateName';
    }
    locationString += ', $countryCode';

    print('Selected location: $locationString');

    Provider.of<WeatherProvider>(context, listen: false)
        .setSelectedCity(locationString);
    String _selectedCity =
        Provider.of<WeatherProvider>(context, listen: false).selectedCity ?? "";
    print(_selectedCity);
    Navigator.pop(context, locationString);
  }
}
