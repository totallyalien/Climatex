import 'dart:ffi';
import 'dart:math';
import 'dart:ui';
import 'package:climatex/component/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:climatex/ui/testing.dart';
import 'package:lottie/lottie.dart';
import 'testing.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:climatex/component/home.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:free_place_search/core/api.dart';
import 'package:free_place_search/models/address.dart';
import 'package:climatex/component/custom_autoc.dart';

// Color k_body = Color.fromARGB(255, 61, 129, 138);

class location extends StatefulWidget {
  const location(@required this.data, {super.key});

  final List data;

  @override
  State<location> createState() => _location(data);
}

class _location extends State<location> {
  _location(@required this.data);

  final List data;
  int _select = 0;

  @override
  void initState() {
    super.initState();
  }

  late double current_time = double.parse(data[1][0][0]);
  late double minslide = double.parse(data[1][0][0]);
  late double maxslide = double.parse(data[1][data[1].length - 1][0]);
  double temp_index = 0;

  MyWeatherPlace m1 = MyWeatherPlace();
  var _search_icon = "assets/homeicon/4791-foggy.json";
  int _index = 0;
  late List listdata = ["Sathyamangalam", "Clear", "clear sky", 37.49];

  var _icon = "assets/homeicon/4791-foggy.json";
  late var _Dicon;

  var AM_PM = "AM";

  @override
  Widget build(BuildContext context) {
    if (minslide > maxslide) {
      maxslide = 24.0;
    }

    if (current_time >= 12) {
      AM_PM = "PM";
    }

    switch (data[0][1]) {
      case "Cloudy":
        if (current_time > 19) {
          _icon = "assets/homeicon/4796-weather-cloudynight.json";
          _Dicon = _icon;
        } else {
          _icon = "assets/homeicon/4800-weather-partly-cloudy.json";
          _Dicon = _icon;
        }
        break;
      case "Mostly cloudy":
        if (current_time > 19) {
          _icon = "assets/homeicon/4796-weather-cloudynight.json";
          _Dicon = _icon;
        } else {
          _icon = "assets/homeicon/sunny.json";
          _Dicon = _icon;
        }
        break;
      case "Partly cloudy":
        if (current_time > 19) {
          _icon = "assets/homeicon/4799-weather-night.json";
          _Dicon = _icon;
        } else {
          _icon = "assets/homeicon/4800-weather-partly-cloudy.json";
          _Dicon = _icon;
        }
        break;
      case "Intermittent clouds":
        if (current_time > 19) {
          _icon = "assets/homeicon/4799-weather-night.json";
          _Dicon = _icon;
        } else {
          _icon = "assets/homeicon/sunny.json";
          _Dicon = _icon;
        }
        break;

      case "Mostly clear":
        if (current_time > 19) {
          _icon = "assets/homeicon/4799-weather-night.json";
          _Dicon = _icon;
        } else {
          _icon = "assets/homeicon/4804-weather-sunny.json";
          _Dicon = _icon;
        }
        break;

      case "Rain":
        if (current_time > 19) {
          _icon = "assets/homeicon/4797-weather-rainynight.json";
          _Dicon = _icon;
        } else {
          _icon = "assets/homeicon/4801-weather-partly-shower.json";
          _Dicon = _icon;
        }
        break;

      default:
        if (current_time > 19) {
          _icon = "assets/homeicon/4799-weather-night.json";
          _Dicon = _icon;
        } else {
          _icon = "assets/homeicon/sunny.json";
          _Dicon = _icon;
        }
        break;
    }

    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: data[2].primary,
            borderRadius: BorderRadius.all(Radius.circular(70))),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: GNav(
            iconSize: 20.0,
            activeColor: Colors.white,
            tabBackgroundColor: data[2].primaryContainer,
            tabBorderRadius: 50,
            tabMargin: EdgeInsets.all(5),
            duration: Duration(milliseconds: 1),
            style: GnavStyle.google,
            // mainAxisAlignment: MainAxisAlignment.center,
            tabs: [
              GButton(icon: Icons.home),
              GButton(icon: Icons.timeline),
              GButton(icon: Icons.search),
            ],
            selectedIndex: _select,
            onTabChange: (value) {
              setState(() {
                _select = value;
              });
            },
          ),
        ),
      ),
      body: [
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: weather_details_upper(context, data[0], _icon),
              ),
            ],
          ),
        ),
        SafeArea(
          child: timeline(),
        ),
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      placeAutocomplete.widget(onDone: (e) async {
                        listdata = await m1.getplaceWeather(e.address!);
                        switch (listdata[1]) {
                          case "Cloudy":
                            _search_icon =
                                "assets/homeicon/4800-weather-partly-cloudy.json";
                            _index = 1;

                            break;
                          case "Mostly cloudy":
                            _search_icon = "assets/homeicon/sunny.json";
                            _index = 1;

                            break;
                          case "Partly cloudy":
                            _search_icon =
                                "assets/homeicon/4800-weather-partly-cloudy.json";
                            _index = 1;

                            break;
                          case "Intermittent clouds":
                            _search_icon = "assets/homeicon/sunny.json";
                            _index = 1;

                            break;

                          case "Mostly clear":
                            _search_icon =
                                "assets/homeicon/4804-weather-sunny.json";
                            _index = 1;

                            break;

                          case "Rain":
                            _search_icon =
                                "assets/homeicon/4801-weather-partly-shower.json";
                            _index = 1;

                            break;

                          default:
                            _search_icon = "assets/homeicon/sunny.json";
                            _index = 1;

                            break;
                        }

                        setState(() {
                          _index = 1;
                        });
                      }),
                      Container(
                          child: [
                        LottieBuilder.asset(
                            "assets/homeicon/108365-search-for-value.json"),
                        weather_details_upper(context, listdata, _search_icon)
                      ][_index])
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: settings(),
              ),
            ],
          ),
        )
      ][_select],
    );
  }

  Column timeline() {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                  child: Center(
                child: Container(
                  child: Text(data[1][temp_index.toInt()][3].toString() + " C",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 100,
                              // color: Colors.white54,
                              fontWeight: FontWeight.bold))
                      .animate()
                      .fadeIn(),
                ),
              )),
              Container(
                child: LottieBuilder.asset(_Dicon),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      current_time.toInt().toString(),
                      style: TextStyle(
                        // color: Colors.white54,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AM_PM,
                        style: TextStyle(
                          // color: Colors.white54,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      // color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Slider(
                          // activeColor: Colors.white,
                          // inactiveColor: Colors.white54,
                          value: current_time,
                          min: minslide,
                          max: maxslide,
                          onChanged: (value) {
                            value = value.ceilToDouble();

                            setState(() {
                              print(data[1][temp_index.toInt()][2].runtimeType);
                              current_time = value;
                              temp_index = value - minslide;
                              if (current_time >= 12) {
                                AM_PM = "PM";
                              } else {
                                AM_PM = "AM";
                              }
                              switch (data[1][temp_index.toInt()][1]) {
                                case "Cloudy":
                                  if (!data[1][temp_index.toInt()][2]) {
                                    _Dicon =
                                        "assets/homeicon/4796-weather-cloudynight.json";
                                  } else {
                                    _Dicon =
                                        "assets/homeicon/4800-weather-partly-cloudy.json";
                                  }
                                  break;
                                case "Mostly cloudy":
                                  if (!data[1][temp_index.toInt()][2]) {
                                    _Dicon =
                                        "assets/homeicon/4796-weather-cloudynight.json";
                                  } else {
                                    _Dicon = "assets/homeicon/sunny.json";
                                  }
                                  break;
                                case "Partly cloudy":
                                  if (!data[1][temp_index.toInt()][2]) {
                                    _Dicon =
                                        "assets/homeicon/4799-weather-night.json";
                                  } else {
                                    _Dicon =
                                        "assets/homeicon/4800-weather-partly-cloudy.json";
                                  }
                                  break;
                                case "Intermittent clouds":
                                  if (!data[1][temp_index.toInt()][2]) {
                                    _Dicon =
                                        "assets/homeicon/4799-weather-night.json";
                                  } else {
                                    _Dicon = "assets/homeicon/sunny.json";
                                  }
                                  break;

                                case "Mostly clear":
                                  if (!data[1][temp_index.toInt()][2]) {
                                    _Dicon =
                                        "assets/homeicon/4799-weather-night.json";
                                  } else {
                                    _Dicon =
                                        "assets/homeicon/4804-weather-sunny.json";
                                  }
                                  break;

                                case "Rain":
                                  if (!data[1][temp_index.toInt()][2]) {
                                    _Dicon =
                                        "assets/homeicon/4797-weather-rainynight.json";
                                  } else {
                                    _Dicon =
                                        "assets/homeicon/4801-weather-partly-shower.json";
                                  }
                                  break;

                                default:
                                  if (!data[1][temp_index.toInt()][2]) {
                                    _Dicon =
                                        "assets/homeicon/4799-weather-night.json";
                                  } else {
                                    _Dicon = "assets/homeicon/sunny.json";
                                  }
                                  break;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
