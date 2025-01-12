import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wedi/services/weather_service.dart';
import 'package:wedi/widgets/search_widgets.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String getWeatherAnimation(int? code) {
    if (code == null) return 'assets/sunny.json';

    if (code < 1002) {
      return 'assets/sunny.json';
    } else if (code < 1148) {
      return 'assets/cloud.json';
    } else if (code < 1206) {
      return 'assets/rain.json';
    } else {
      return 'assets/snow.json';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<WeatherService>(context, listen: false).checkCity();
      await Provider.of<WeatherService>(context, listen: false).unitChecker();
      await Provider.of<WeatherService>(context, listen: false).getWeather(
          cityName:
              Provider.of<WeatherService>(context, listen: false).getCityName,
          context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer2<WeatherService, SearchWidgets>(
            builder: (context, weatherServices, searchWidgets, _) {
          if (weatherServices.weather == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  searchWidgets.searchBar(context: context),
                  Lottie.asset(
                    getWeatherAnimation(weatherServices.weather!.code),
                  ),
                  Text(
                    weatherServices.weather!.cityName,
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: const Color.fromARGB(255, 165, 114, 174),
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    weatherServices.weather!.weatherCondition,
                    style: const TextStyle(fontSize: 30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${weatherServices.getCelcius ? weatherServices.weather!.tempC : weatherServices.weather!.tempF}${weatherServices.getCelcius ? '°C' : '°F'}',
                        style: const TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 2,
                        height: 30,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            '°F',
                            style: TextStyle(fontSize: 20),
                          ),
                          Switch(
                            activeTrackColor: Colors.deepPurple,
                            inactiveTrackColor: Colors.blue,
                            value: weatherServices.getCelcius == false
                                ? false
                                : true,
                            onChanged: (value) {
                              weatherServices.changeUnit();
                            },
                          ),
                          Text(
                            '°C',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'Humidity: ${weatherServices.weather!.humidity}%',
                    style: const TextStyle(fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: weatherServices.weather!.threeDayForecast
                          .map((forecast) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          child: ListTile(
                            title: Text(
                              forecast.date,
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Condition: ${forecast.weatherCondition}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Max Temp: ${weatherServices.getCelcius ? forecast.maxTempC : forecast.maxTempF}${weatherServices.getCelcius ? '°C' : '°F'}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Min Temp: ${weatherServices.getCelcius ? forecast.minTempC : forecast.minTempF}${weatherServices.getCelcius ? '°C' : '°F'}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Humidity: ${forecast.humidity}%',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
