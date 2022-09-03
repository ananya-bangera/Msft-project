import 'package:advertaise/model/themes.dart';
import 'package:flutter/material.dart';

class ContestantList extends StatelessWidget {
  final String url;
  final String name;
  final String rank;
  const ContestantList(
      {Key? key, required this.url, required this.name, required this.rank})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, bottom: 5.0, top: 10.0),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.red,
              Colors.red.shade400,
              Colors.orange,
              Colors.yellow.shade400,
            ]),
            borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
                color: myColors.calculatorButton,
                borderRadius: BorderRadius.circular(15.0)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      (url == null) ? 'assets/user.png' : url,
                      height: 60.0,
                      width: 60.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (name == null) ? 'Name' : name,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '@${(name == null) ? 'Name' : name}',
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        (rank == null) ? '1' : rank,
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
