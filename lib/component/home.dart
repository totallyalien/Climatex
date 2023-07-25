import 'package:flutter/material.dart';
import 'package:climatex/ui/location.dart';
import 'package:lottie/lottie.dart';

Column weather_details_upper(context, data, icon) {
  return Column(
    children: [
      SizedBox(
        height: 80,
      ),
      Container(
          child: Container(
        width: double.infinity,
        child: Center(
          child: Text(data[0].toString(),
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Poppins",
                // color: Color.alphaBlend(Colors.white, Colors.transparent)),
              )),
        ),
      )),
      SizedBox(
        height: 10,
      ),
      Container(
        child: Container(
            width: double.infinity,
            child: Center(
              child: Text(
                data[2],
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  // color: Colors.white54,
                ),
              ),
            )),
      ),
      SizedBox(
        height: 30,
      ),
      Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  data[3].round().toString(),
                  style: TextStyle(
                      // color: Colors.white70,
                      fontSize: 170,
                      fontWeight: FontWeight.w800,
                      fontFamily: "Poppins"),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
                child: Container(
                  // decoration:
                  // BoxDecoration(boxShadow: [BoxShadow(blurRadius: 30)]),
                  child: Icon(
                    Icons.circle_rounded,
                    // color: Colors.white70,
                    size: 35,
                  ),
                ),
              )
            ],
          ),
          Container(
              padding: EdgeInsets.only(top: 150),
              child: Container(
                child: LottieBuilder.asset(icon),
                // decoration: BoxDecoration(boxShadow: [
                //   BoxShadow(
                //     // blurRadius: 200,
                //   )
                // ]),
              ))
        ],
      ),
    ],
  );
}
