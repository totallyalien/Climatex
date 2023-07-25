import 'package:climatex/ui/location.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:climatex/ui/testing.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Loading extends StatefulWidget {
  const Loading(@required this.data, {super.key});
  final ColorScheme data;

  @override
  State<Loading> createState() => _LoadingState(data);
}

class _LoadingState extends State<Loading> {
  _LoadingState(@required this.data);

  final ColorScheme data;

  @override
  void initState() {
    super.initState();
    getLocation(context);
  }

  void getLocation(context) async {
    MyLocation loc = MyLocation();
    await loc.determinePosition(data, context);
    double lator = loc.lat;
    double longor = loc.long;
    print("getLodfffffffffffhfhhfhfhfff");
    print(lator);
    MyWeather weath = MyWeather(lator, longor);
    await weath.getweather();
    await weath.getLoc();
    await weath.hourlyforecast();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return location(
          [weath.current_weather_list, weath.hourly_weather_list, data]);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: LottieBuilder.asset("assets/locationloading.json"),
        )),
      ),
    );
  }
}
