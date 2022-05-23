import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smart_advertising/pages/home.dart';
import 'package:smart_advertising/pages/registeration.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        next: Icon(Icons.navigate_next_outlined),
        skip: Text('Skip',
          style: TextStyle(
            color: Colors.red
          ),
        ),
        onSkip: () => gotoHome(context),
        pages: [
          PageViewModel(
            title: "Title of first page",
            body: "Here you can write the description of the page, to explain something...",
            image:  Center(child: Image.asset('assets/PredictiveAnalysis.png',width: 350,)),
          ),
          PageViewModel(
            title: "Title of second page",
            body: "Here you can write the description of the page, to explain something...",
            image:  Center(child: Image.asset('assets/Process.png',width: 350,)),

          ),
          PageViewModel(
            title: "Title of second page",
            body: "Here you can write the description of the page, to explain something...",
            image:  Center(child: Image.asset('assets/InThought.png',width: 350,)),
          )
        ],
        done: Text('Next'),
        onDone: () => gotoHome(context),
        dotsDecorator:  getDotsDecoration(),
      ),
    );
  }

  void gotoHome(context) =>
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RegisterationScreen()),
      );

  DotsDecorator getDotsDecoration()=> DotsDecorator (
    color: Color(0xFFBDBDBD),
    activeColor: Color(0xFFFF5AAC),
    size: Size(10, 10),
    activeSize: Size(15, 15),
  );
}