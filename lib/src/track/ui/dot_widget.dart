import 'package:flutter/material.dart';

class DotWidget extends StatelessWidget {
  final String _cityName;

  DotWidget(@required this._cityName);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.grey,
            child: SizedBox(),
          ),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(
              _cityName,
              style: Theme.of(context).textTheme.subtitle,
            ),
          ),
        ],
      ),
    );
  }
}
