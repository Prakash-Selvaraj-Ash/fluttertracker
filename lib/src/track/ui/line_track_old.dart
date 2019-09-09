import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'dart:async';
import './blinking_widget.dart';
import './dot_widget.dart';

class LineTrackOld extends StatefulWidget {
  @override
  _LineTrackOldState createState() => _LineTrackOldState();

  double _blinkingDotPosition = 28;
  bool _blinkingEnabled = false;
  var _trackingText = "Bus Not Started";

  List _cities = [
    "Cmbt",
    "Mmda",
    "Vadapalani",
    "Ashok nagar",
    "Kasi theatre",
    "Guindy",
    "ABC School"
  ];
}

class _LineTrackOldState extends State<LineTrackOld> {
  var sub = null;
  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: 3),
      new Duration(seconds: 5),
    );

    sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        if (widget._blinkingDotPosition <
            ((widget._cities.length * 100) + 28)) {
          if(widget._blinkingDotPosition == 33) {
            widget._blinkingEnabled = true;
            widget._trackingText = 'Bus Started';
          }
          widget._blinkingDotPosition += 5;
          if (widget._blinkingDotPosition > 100 && widget._blinkingDotPosition % 100 == 28) {
            widget._trackingText = 'Bus Crossed ' +
                widget._cities[(widget._blinkingDotPosition / 100).round() - 1];
          }
        } else {
          widget._trackingText = 'Bus Reached School';
          widget._blinkingEnabled = false;
          sub.cancel();
        }
      });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(sub != null) {
      sub.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    startTimer();
    return Container(
      margin: EdgeInsets.fromLTRB(20, 70, 20, 70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(50, 8, 50, 0),
                  child: Container(
                    height: 2,
                    width: widget._cities.length * 100.0 - 10,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.grey,
                              child: SizedBox(),
                            ),
                          ],
                        ),
                        Text(
                          'Not Started',
                          style: Theme.of(context).textTheme.subtitle,
                        )
                      ],
                    ),
                    ...(widget._cities as List).map((city) {
                      return DotWidget(city);
                    }).toList()
                  ],
                ),
                widget._blinkingEnabled
                    ? BlinkingDot(widget._blinkingDotPosition)
                    : Container(
                  margin: EdgeInsets.fromLTRB(
                      widget._blinkingDotPosition, 0, 0, 0),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.transparent,
                    child: SizedBox(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            widget._trackingText,
            style: Theme.of(context).textTheme.title,
          )
        ],
      ),
    );
  }
}
