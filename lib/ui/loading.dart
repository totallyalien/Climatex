import 'package:climatex/ui/location.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:climatex/ui/testing.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    getLocation(context);
  }

  void getLocation(context) async {
    MyLocation loc = MyLocation();
    await loc.determinePosition(context);
    double lator = loc.lat;
    double longor = loc.long;
    print("getLodfffffffffffhfhhfhfhfff");
    print(lator);
    MyWeather weath = MyWeather(lator, longor);
    await weath.getweather();
    await weath.getLoc();
    await weath.hourlyforecast();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return location([weath.current_weather_list, weath.hourly_weather_list]);
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
