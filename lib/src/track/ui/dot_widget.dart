import 'package:flutter/material.dart';

class DotWidget extends StatelessWidget {
  final String _cityName;
  final String _etaText;

  DotWidget(@required this._cityName,@required this._etaText);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                _cityName,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
          ),
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.grey,
            child: SizedBox(),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                _etaText,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
