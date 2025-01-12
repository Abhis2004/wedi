import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedi/services/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchWidgets with ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  List<String> searchHistory = [];

  SearchWidgets() {
    _loadSearchHistory();
  }

  _loadSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('searchHistory') ?? [];
    searchHistory = history;
    notifyListeners();
  }

  _saveSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('searchHistory', searchHistory);
  }

  addToSearchHistory(String city) {
    if (!searchHistory.contains(city)) {
      searchHistory.insert(0, city);
      _saveSearchHistory();
      notifyListeners();
    }
  }

  Widget searchBar({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search City",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSubmitted: (value) {
              String city = searchController.text.trim();
              if (city.isNotEmpty) {
                Provider.of<WeatherService>(context, listen: false)
                    .getWeather(cityName: city, context: context);
                addToSearchHistory(city);
                searchController.clear();
              }
            },
          ),
          if (searchHistory.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Text(
                    'Search History',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: searchHistory.map((city) {
                        return Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<WeatherService>(context, listen: false)
                                  .getWeather(cityName: city, context: context);
                              searchController.text = city;
                            },
                            child: Chip(
                              label: Text(city),
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}