import 'package:flutter/material.dart';

class LocationScreen extends StatelessWidget {
  final weatherData;

  LocationScreen({this.weatherData});

  @override
  Widget build(BuildContext context) {
    double temperature = weatherData['main']['temp'];
    String cityName = weatherData['name'];
    String weatherCondition = weatherData['weather'][0]['main'];

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Temperature: $temperature°C',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              'City: $cityName',
              style: TextStyle(fontSize: 25),
            ),
            Text(
              'Condition: $weatherCondition',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
