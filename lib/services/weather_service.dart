import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedi/config/weather_config.dart';

class WeatherService with ChangeNotifier {
  String cityName = "Mumbai";
  String get getCityName => cityName;
  static const url = 'http://api.weatherapi.com/v1/forecast.json';
  static final String _apikey = "8e8fa271482c4ef4961204230251101";
  Weather? _weather;
  Weather? get weather => _weather;
  bool celcius = true;
  bool get getCelcius => celcius;

  unitChecker() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("celcius") == true) {
      celcius = true;
    } else if (prefs.getBool("celcius") == false) {
      celcius = false;
    } else {
      celcius = true;
    }
    notifyListeners();
  }

  void changeUnit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    celcius = !celcius;
    prefs.setBool("celcius", celcius);
    notifyListeners();
  }

  checkCity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("city") != null) {
      cityName = prefs.getString("city")!;
    }
    notifyListeners();
  }

  changeCity({required String city}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cityName = city;
    prefs.setString("city", city);
    notifyListeners();
  }

  Future<Weather> fetchWeather(String cityName) async {
    final response =
        await http.get(Uri.parse('$url?q=$cityName&key=$_apikey&days=4'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      if (kDebugMode) {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      throw Exception('Failed to load weather data');
    }
  }

  getWeather({required BuildContext context, required String cityName}) async {
    try {
      final weather = await fetchWeather(cityName);

      _weather = weather;
      changeCity(city: _weather!.cityName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Unable to fetch weather data"),
      ));
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
  }
}
