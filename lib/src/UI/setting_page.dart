import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/src/provider/weather_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // String _selectedUnit = 'Celsius (\u00B0C)';

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        return Scaffold(
          backgroundColor: primaryBckgnd,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: whiteColor,
              ),
            ),
            title: const Text(
              'Settings',
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: whiteColor,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              child: ListTile(
                tileColor: secondaryBckgnd,
                title: Text(
                  'Temperature Unit',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                subtitle: Text(
                  weatherProvider.selectedUnit,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: greycolor2.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                onTap: () {
                  _showUnitSelectionDialog(weatherProvider);
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 26,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showUnitSelectionDialog(WeatherProvider weatherProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Select Temperature Unit',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: textColor,),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Celsius (\u00B0C)'),
                onTap: () {
                  weatherProvider
                      .setSelectedUnit('Celsius (\u00B0C)'); // Update provider
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Fahrenheit (\u00B0F)'),
                onTap: () {
                  weatherProvider.setSelectedUnit(
                      'Fahrenheit (\u00B0F)'); // Update provider
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
