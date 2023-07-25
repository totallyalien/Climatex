import 'dart:convert';
import 'package:flutter/material.dart';

import 'dart:ffi';
import 'package:climatex/component/custom_autoc.dart';
import 'package:free_place_search/models/address.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'loading.dart';

var apikey = "5c0f353a5c32618b4522ef241dc649b1";

// var accapikey = "YY5hEbWO1YOQH1eivOIHFFTwm4u1yzV0";

var accapikey = "3seOl8EUPSkanx0gLwXkGT2xZGKfbC5s";

// var apikey = "8e601d8ae6ec1661f23d61d27a1666c7";
// https://api.openweathermap.org/data/2.5/weather?lat=12&lon=32&appid=8e601d8ae6ec1661f23d61d27a1666c7&units=metric

class MyLocation {
  late double lat;
  late double long;

  Future<void> determinePosition(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();

    if ((permission == LocationPermission.denied)) {
      permission = await Geolocator.requestPermission();
      Navigator.pop(context); // pop current page
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Loading();
      }));
    }

    try {
      Position? position = await Geolocator.getCurrentPosition(
          forceAndroidLocationManager: true,
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 6));

      lat = position.latitude;
      long = position.longitude;
      print("liveLocccccccccccccccccc");
      print(lat);
    } catch (e) {
      Position? pos = await Geolocator.getLastKnownPosition();
      lat = await pos!.latitude;
      long = await pos.longitude;
      print("LastLocccccccccccccccc");
      print(lat);
      print(e);
    }
  }
}

class MyWeatherPlace {
  List custom_current_weather_list = [];

  Future<List> getplaceWeather(Address place) async {
    print(place);
    late String string_loc_endpoint =
        "https://api.openweathermap.org/data/2.5/weather?q=$place&appid=$apikey&units=metric";

    print(string_loc_endpoint);

    var url = Uri.parse(string_loc_endpoint);
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    print(data);
    custom_current_weather_list = [
      data["name"],
      data["weather"][0]["main"],
      data["weather"][0]["description"],
      data["main"]["temp"],
    ];
    return custom_current_weather_list;
  }
}

class MyWeather {
  late double lat;
  late double long;
  late int locKey;
  late List current_weather_list;
  late List custom_current_weather_list;
  late List hourly_weather_list;

  MyWeather(this.lat, this.long);
  late String current_endpoint =
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apikey&units=metric";

  late String loc_endpoint =
      "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=$accapikey&q=$lat%2C$long";

  late String hourly_endpoint =
      "http://dataservice.accuweather.com/forecasts/v1/hourly/12hour/$locKey?apikey=$accapikey&metric=true";

  Future<void> getweather() async {
    var url = Uri.parse(current_endpoint);
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    current_weather_list = [
      data["name"],
      data["weather"][0]["main"],
      data["weather"][0]["description"],
      data["main"]["temp"],
    ];
    print(current_weather_list);
  }

  Future<void> getLoc() async {
    var url = Uri.parse(loc_endpoint);
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    print(data);
    locKey = int.parse(data["Key"]);
    // locKey = 2806025;
  }

  //forecast
  Future<void> hourlyforecast() async {
    var url = Uri.parse(hourly_endpoint);
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    print(data);
    hourly_weather_list = [];

    for (int i = 0; i < data.length; i++) {
      hourly_weather_list.add([
        data[i]["DateTime"].split("T")[1].split("+")[0].split(":")[0],
        data[i]["IconPhrase"],
        data[i]["IsDaylight"],
        data[i]["Temperature"]["Value"]
      ]);
    }

    print(hourly_weather_list);
  }
  //weather_feel
}
