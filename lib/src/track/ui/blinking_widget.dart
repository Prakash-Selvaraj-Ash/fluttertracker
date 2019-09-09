import 'package:flutter/material.dart';

class BlinkingDot extends StatefulWidget {
  final double _marginLeft;

  BlinkingDot(@required this._marginLeft);
  @override
  _BlinkingDotState createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<BlinkingDot>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
    new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        margin: EdgeInsets.fromLTRB(widget._marginLeft, 0, 0, 0),
        child: CircleAvatar(
          radius: 10,
          backgroundColor: Theme.of(context).primaryColor,
          child: SizedBox(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}