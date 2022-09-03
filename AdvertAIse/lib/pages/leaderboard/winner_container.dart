import 'package:advertaise/model/themes.dart';
import 'package:flutter/material.dart';

class WinnerContainer extends StatelessWidget {
  final bool isFirst;
  final Color color;
  final String winnerPosition;
  final String url;
  final String winnerName;
  final String rank;
  final double height;
  const WinnerContainer(
      {Key? key,
      required this.isFirst,
      required this.color,
      required this.winnerPosition,
      required this.winnerName,
      required this.rank,
      required this.height,
      required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.yellow.shade600,
                    Colors.orange,
                    Colors.red
                  ]),
                  border: Border.all(
                    color: Colors.amber,
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    height: (height == null) ? 150.0 : height,
                    width: 90.0,
                    decoration: BoxDecoration(
                      color: myColors.calculatorButton,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Stack(
              children: [
                if (isFirst)
                  Image.asset(
                    'assets/crown.png',
                    height: 30.0,
                    width: 90.0,
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 45.0),
                  child: Container(
                    height: 60.0,
                    width: 90.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red),
                      image: DecorationImage(
                          image: AssetImage(
                              (url == null) ? 'assets/user.png' : url),
                          fit: BoxFit.contain),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 105.0, left: 35.0),
                  child: Container(
                      height: 20.0,
                      width: 20.0,
                      // color: Colors.red,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: (color == null) ? Colors.red : color,
                          ),
                          color: (color == null) ? Colors.red : color),
                      child: Center(
                        child: Text(
                          (rank == null) ? '1' : rank,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
              ],
            ),
          ),
          Positioned(
            top: 150.0,
            child: Container(
              width: 100.0,
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      (winnerName == null) ? "Anonymous" : winnerName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      rank.toString(),
                      style: TextStyle(
                        color: (color == null) ? Colors.white : color,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
