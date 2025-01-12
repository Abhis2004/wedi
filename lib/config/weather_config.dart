import 'package:flutter/material.dart';

class Weather with ChangeNotifier {
  String cityName;
  String weatherCondition;
  int code;
  double tempC;
  double tempF;
  int humidity;
  List<Forecast> threeDayForecast;

  Weather({
    required this.cityName,
    required this.weatherCondition,
    required this.code,
    required this.tempC,
    required this.tempF,
    required this.humidity,
    required this.threeDayForecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    List<Forecast> forecastList = (json['forecast']['forecastday'] as List)
        .map((item) {
          return Forecast.fromJson(item);
        })
        .skip(1)
        .take(3)
        .toList();

    return Weather(
      cityName: json['location']['name'],
      weatherCondition: json['current']['condition']['text'],
      code: json['current']['condition']['code'],
      tempC: json['current']['temp_c'].toDouble(),
      tempF: json['current']['temp_f'].toDouble(),
      humidity: json['current']['humidity'],
      threeDayForecast: forecastList,
    );
  }
}

class Forecast {
  String date;
  String weatherCondition;
  double maxTempC;
  double minTempC;
  double maxTempF;
  double minTempF;
  int humidity;

  Forecast({
    required this.date,
    required this.weatherCondition,
    required this.maxTempC,
    required this.minTempC,
    required this.maxTempF,
    required this.minTempF,
    required this.humidity,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: json['date'],
      weatherCondition: json['day']['condition']['text'],
      maxTempC: json['day']['maxtemp_c'].toDouble(),
      minTempC: json['day']['mintemp_c'].toDouble(),
      maxTempF: json['day']['maxtemp_f'].toDouble(),
      minTempF: json['day']['mintemp_f'].toDouble(),
      humidity: json['day']['avghumidity'],
    );
  }
}
