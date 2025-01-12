import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedi/pages/weather_page.dart';
import 'package:wedi/services/weather_service.dart';
import 'package:wedi/widgets/search_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WeatherService()),
        ChangeNotifierProvider(create: (context) => SearchWidgets()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: WeatherPage(),
      ),
    );
  }
}
